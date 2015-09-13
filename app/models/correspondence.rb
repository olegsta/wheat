class Correspondence < ActiveRecord::Base
  has_many :correspondence_positions
  has_many :positions, through: :correspondence_positions

  has_many :correspondence_users
  has_many :users, through: :correspondence_users

  has_many :messages

  def self.create_between_users user_ids
    correspondence = Correspondence.create
    correspondence.update(user_ids: user_ids)
    correspondence.update(users_ids: user_ids, json_users: correspondence.users.as_json(only: [:id, :fullname, :avatar]))
    correspondence
  end

  def associate_with_positions position_ids
    self.position_ids = position_ids
    self.update(correspondence_type: 'positions', positions_ids: position_ids, json_positions: self.positions.as_json(only: [:id, :user_id, :trade_type_id, :option_id, :weight, :weight_dimension_id, :weight_min, :weight_min_dimension_id, :price, :currency_id, :price_weight_dimension_id]))
    self
  end

  def self.between_users user_ids
    Correspondence.where("users_ids @> ARRAY[?]::integer[]", user_ids).first
  end

  def self.between_positions position_ids
    Correspondence.where("positions_ids @> ARRAY[?]::integer[]", position_ids).first
  end

end
