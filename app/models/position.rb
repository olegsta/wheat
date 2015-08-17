class Position < ActiveRecord::Base
  before_save :set_category_id

  has_many :positions_offers
  has_many :positions, through: :positions_offers
  has_many :offers, through: :positions_offers
  
  mount_uploaders :images, ImageUploader

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
  validates :weight_dimension_id, inclusion: { in: @@dimensions_ids }
  validate :less_then_weight
  validate :location
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :price_weight_dimension_id, inclusion: { in: @@dimensions_ids }
  validates :price_discount, :allow_blank => true, numericality: { greater_than_or_equal_to: 0 }

  private

    def set_category_id
      self.category_id = Option.find(option_id).category_id
    end

    def less_then_weight
      errors.add(:weight_min) if self.weight_min.to_f > self.weight.to_f
    end

    def location
      errors.add(:lat) unless self.lat && self.lng
    end
end
