class CorrespondencePosition < ActiveRecord::Base
  belongs_to :position
  belongs_to :correspondence

  validates :position, presence: true
  validates :correspondence, presence: true
end
