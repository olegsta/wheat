class Position < ActiveRecord::Base

  has_many :positions_offers
  has_many :positions, through: :positions_offers
  has_many :offers, through: :positions_offers

  belongs_to :user
  belongs_to :currency
  belongs_to :weight_dimension
  belongs_to :weight_min_dimension, class_name: WeightDimension
  belongs_to :price_weight_dimension, class_name: WeightDimension
  belongs_to :option
  belongs_to :category

  before_save :set_category_id


  private

    def set_category_id
      self.category_id = Option.find(option_id).category_id
    end
end
