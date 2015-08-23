class Position < ActiveRecord::Base
  include AASM
  
  before_save :set_category_id

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


  private

    def set_category_id
      self.category_id = Option.find(option_id).category_id
    end

    def less_then_weight
      errors.add(:weight_min) if WeightDimension.normalize(self.weight_min, self.weight_min_dimension_id) > WeightDimension.normalize(self.weight, self.weight_dimension_id)
    end

    def location
      errors.add(:lat) unless self.lat && self.lng
    end
end
