class Position < ActiveRecord::Base
  include AASM
  
  before_save :set_category_id
  before_save :set_etalon
  before_save :set_index_field

  has_many :positions_offers
  has_many :positions, through: :positions_offers
  has_many :offers, through: :positions_offers
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
  validates :price_discount, :allow_blank => true, numericality: { greater_than_or_equal_to: 0 }


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


  def self.filter filters = []
    currencies = Currency.all
    user_currency = currencies.first
    sql = []
    filters.each do |filter|
      query = {}
      
      if filter["weight_from"] or filter["weight_to"]
        weight_from = (filter["weight_from"] || 0).to_f * WeightDimension.dimensions[filter["weight_from_dimension_id"]].convert
        weight_to = (filter["weight_to"] || Float::INFINITY).to_f * WeightDimension.dimensions[filter["weight_to_dimension_id"]].convert
        query[:weight_etalon] = (weight_from..weight_to)
      end

      if filter["price_from"] or filter["price_to"]
        price_from = (filter["price_from"] || 0).to_f
        price_to = (filter["price_to"] || Float::INFINITY).to_f
        
        query[:price_etalon] = currencies.map do |currency|
          converted_price_from = price_from / currency.get_rate(user_currency.name) / WeightDimension.dimensions[filter["price_from_weight_dimension_id"]].convert
          converted_price_to = price_to / currency.get_rate(user_currency.name) / WeightDimension.dimensions[filter["price_to_weight_dimension_id"]].convert
          (converted_price_from..converted_price_to)
        end
      end

      if filter["trade_type_id"]
        query[:trade_type_id] = filter["trade_type_id"]
      end

      if filter["option_id"]
        query[:option_id] = filter["option_id"]
      end

      sql << self.where(query).to_sql
    end
    
    self.find_by_sql sql.join(" OR ")
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
      self.weight_etalon = self.weight * WeightDimension.dimensions[self.weight_dimension_id].convert
      self.weight_min_etalon = self.weight_min * WeightDimension.dimensions[self.weight_min_dimension_id].convert
      self.price_etalon = self.price / WeightDimension.dimensions[self.price_weight_dimension_id].convert
    end
end
