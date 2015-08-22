class Correspondence < ActiveRecord::Base
  before_create :set_json_users

  has_many :correspondence_positions
  has_many :positions, through: :correspondence_positions

  has_many :correspondence_users
  has_many :users, through: :correspondence_users

  has_many :messages

  def set_users
    self.json_users = self.users.as_json(only: [:id, :fullname, :avatar])
  end
end
