class Correspondence < ActiveRecord::Base
  before_save :set_users
  before_save :set_positions

  has_many :correspondence_positions
  has_many :positions, through: :correspondence_positions

  has_many :correspondence_users
  has_many :users, through: :correspondence_users

  has_many :messages


  private
    def set_users
      if users.any?
        self.json_users = self.users.as_json(only: [:id, :fullname, :avatar])
      end
    end

    def set_positions
      if users.any?
        self.json_positions = self.positions.as_json(only: [:id, :user_id, :trade_type_id, :option_id, :weight, :weight_dimension_id, :weight_min, :weight_min_dimension_id, :price, :currency_id, :price_weight_dimension_id])
      end
    end
end
