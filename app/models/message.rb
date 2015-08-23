class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :correspondence, touch: true

  validates :body, presence: true
end
