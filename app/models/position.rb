class Position < ActiveRecord::Base
  include AASM

  TRADE_TYPES_ASOCIATION = {1 => 2, 2 => 1}

  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  before_save :set_category_id
  before_save :set_etalon
  before_save :set_index_field

  after_commit :regenerate_cache

  has_many :positions_offers, foreign_key: :offer_id
  has_many :positions, through: :positions_offers
  
  has_many :offers_positions, foreign_key: :position_id, class_name: PositionsOffer
  has_many :offers, through: :offers_positions
  
  has_many :attachments
  
  has_many :correspondence_positions, :inverse_of => :position
  has_many :correspondences, through: :correspondence_positions
  
  belongs_to :user
  belongs_to :currency
  belongs_to :weight_dimension
  belongs_to :weight_min_dimension, class_name: WeightDimension
  belongs_to :price_weight_dimension, class_name: WeightDimension
  belongs_to :option
  belongs_to :category

  @@trade_types_ids = [1, 2]
  @@dimensions_ids =  WeightDimension.pluck(:id)
  @@options_ids =  Option.pluck(:id)

  validates :trade_type_id, inclusion: { in: @@trade_types_ids }
  validates :title, presence: true, length: { maximum: 50 }
  validates :option_id, inclusion: { in: @@options_ids }
  validates :address, presence: true
  validates :weight, numericality: { greater_than: 0 }
  validates :weight_min, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_dimension_id, inclusion: { in: @@dimensions_ids }
  validate :less_then_weight
  validate :location
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :price_weight_dimension_id, inclusion: { in: @@dimensions_ids }
  validates :price_discount, :allow_blank => true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 50 }


  aasm :column => :status do
    state :opened, :initial => true
    state :in_process
    state :completed
    state :archive

    event :start_process do
      transitions :to => :in_process, :from => [:opened]
    end

    event :complete do
      transitions :to => :completed, :from => [:in_process]
    end

    event :move_to_archive do
      transitions :to => :archive, :from => [:opened]
    end

    event :open do
      transitions :to => :opened, :from => [:archive]
    end
  end

  def self.statuses
    Position.aasm.states.map do |state|
      {id: state.name, title: I18n.t('position.status.'+state.name.to_s)}
    end
  end

  def self.full
    includes(:offers, :positions_offers, :user, :option, :category, :weight_dimension, :price_weight_dimension, :weight_min_dimension, :currency, :attachments)
  end

  def self.filter filters = []
    currencies = Currency.all
    sql = []
    filters.each do |filter|
      user_currency = Currency.by_index_from_cache[filter[:currency_id]]
      
      query = {}
      query[:trade_type_id] = filter["trade_type_id"] if filter["trade_type_id"]
      query[:option_id] = filter["option_id"] if filter["option_id"]

      
      if filter["weight_from"] or filter["weight_to"]
        weight_from = (filter["weight_from"] || 0).to_f * WeightDimension.by_index_from_cache[filter["weight_from_dimension_id"]][:convert] rescue 0
        weight_to = (filter["weight_to"] || Float::INFINITY).to_f * WeightDimension.by_index_from_cache[filter["weight_to_dimension_id"]][:convert] rescue Float::INFINITY
        # query[:weight_min_etalon] = (weight_from..Float::INFINITY)
        query[:weight_etalon] = (weight_from..weight_to)
      end

      if filter["price_from"] or filter["price_to"]
        price_from = (filter["price_from"] || 0).to_f / WeightDimension.by_index_from_cache[filter["price_from_weight_dimension_id"]][:convert] rescue 0
        price_to = (filter["price_to"] || Float::INFINITY).to_f / WeightDimension.by_index_from_cache[filter["price_to_weight_dimension_id"]][:convert] rescue Float::INFINITY

        price_sql = []
        currencies.each do |currency|
          converted_price_from = price_from / currency.get_rate(user_currency[:name])
          converted_price_to = price_to / currency.get_rate(user_currency[:name])
          position = Position.where currency_id: currency.id, price_etalon: (converted_price_from..converted_price_to)

          price_sql << position.to_sql.split("WHERE")[1]
        end

        price_sql = "(" + price_sql.join(" OR ") + ")"
      end

      in_radius_sql = ""
      if filter["coords"]
        lat = filter["coords"][0]
        lng = filter["coords"][1]
        radius = filter["radius"] || 10
        a = "SIN((lat-#{lat})*PI()/360)  *  SIN((lat-#{lat})*PI()/360)  +  COS(#{lat}*PI()/180) * COS(lat*PI()/180) * SIN((lng-#{lng})*PI()/360) * SIN((lng-#{lng})*PI()/360)"
        in_radius_sql = %{
          #{radius} >= 2 * ATAN2(SQRT(#{a}), SQRT(1-#{a})) * 6378.137
        }
      end

      sql << self.where(query).where(price_sql).where(in_radius_sql).to_sql.split("WHERE")[1]
    end
    self.where sql.join(" OR ")

  end

  # def self.measure lat1, lon1, lat2=37.620393, lon2=55.75396
  #   r = 6378.137;
  #   dLat = (lat2 - lat1) * Math::PI / 180;
  #   dLon = (lon2 - lon1) * Math::PI / 180;
  #   a = Math.sin(dLat/2) * Math.sin(dLat/2) +
  #   Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) *
  #   Math.sin(dLon/2) * Math.sin(dLon/2)
  #   c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  #   r * c
  # end

  def self.find_suitable positions
    filters = positions.map do |position|
      res = {
        option_id: position.option_id,
        weight_from: position.weight_min,
        weight_from_dimension_id: position.weight_min_dimension_id,
        currency_id: position.currency_id
      }

      if position.trade_type_id == 1
        res[:trade_type_id] = 2
        res[:price_to] = position.price * (1 + position.price_discount/100.0)
        res[:price_to_weight_dimension_id] = position.price_weight_dimension_id
      elsif position.trade_type_id == 2
        res[:trade_type_id] = 1
        res[:price_from] = position.price * (1 - position.price_discount/100.0)
        res[:price_from_weight_dimension_id] = position.price_weight_dimension_id
      end
      res.with_indifferent_access
    end

    self.filter filters
  end

  def self.pluck_fields
    self.pluck(:id, :lat, :lng, :trade_type_id, :option_id, :weight, :weight_dimension_id, :price, :currency_id, :price_weight_dimension_id)
  end

  def self.from_cache id
    Rails.cache.fetch("position_#{id}_#{I18n.locale}") do
      Position.find(id)
    end
  end

  def self.serialize_from_cache id
    Rails.cache.fetch("serialize_position_#{id}_#{I18n.locale}") do
      PositionSerializer.new(Position.from_cache(id), root: false).as_json
    end
  end

  def self.all_from_cache
    Rails.cache.fetch("positions_all_#{I18n.locale}") do
      Position.all.pluck_fields
    end
  end


  private

    #
    # ERRORS
    #

    def less_then_weight
      errors.add(:weight_min) if WeightDimension.normalize(self.weight_min, self.weight_min_dimension_id) > WeightDimension.normalize(self.weight, self.weight_dimension_id)
    end

    def location
      errors.add(:lat) unless self.lat && self.lng
    end

    #
    # BEFORE ACTION
    #

    def set_category_id
      self.category_id = Option.find(option_id).category_id
    end

    def set_index_field
      temp = [self.title, self.description]
      [:en, :ru].each do |locale|
        temp << I18n.t('position.dictionary.trade_types', :locale => locale)[self.trade_type_id]
        temp << I18n.t('category.items.'+self.option.category.title, :locale => locale)
        temp << I18n.t('option.'+Option.find(self.option_id).title, :locale => locale)
      end
      self.index_field = temp.join(" ")
    end

    def set_etalon
      self.weight_etalon = self.weight * WeightDimension.by_index_from_cache[self.weight_dimension_id][:convert]
      self.weight_min_etalon = self.weight_min * WeightDimension.by_index_from_cache[self.weight_min_dimension_id][:convert]
      self.price_etalon = self.price / WeightDimension.by_index_from_cache[self.price_weight_dimension_id][:convert]
    end
    
    #
    # AFTER ACTION
    #

    def regenerate_cache
      Rails.cache.delete("user_position_#{self.user_id}_#{self.id}_#{I18n.locale}")
      Rails.cache.delete("user_offers_#{self.id}_#{I18n.locale}")

      Position.statuses.each do |status|
        Rails.cache.delete("user_positions_#{self.user_id}_#{status[:id]}_#{I18n.locale}")
      end
      
      Rails.cache.delete("position_#{self.id}_#{I18n.locale}")
      Rails.cache.delete("serialize_position_#{self.id}_#{I18n.locale}")
      Rails.cache.delete("positions_all_#{I18n.locale}")

      self.correspondences.pluck(:id).each do |correspondence_id|
        Rails.cache.delete("correspondence_position_#{correspondence_id}_#{I18n.locale}")
        Rails.cache.delete("correspondence_positions_#{correspondence_id}_#{I18n.locale}")
      end
    end

end
