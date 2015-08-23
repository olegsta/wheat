class CorrespondenceUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :correspondence

  validates :user, presence: true
  validates :correspondence, presence: true
end
