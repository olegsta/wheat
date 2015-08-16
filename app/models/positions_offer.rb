class PositionsOffer < ActiveRecord::Base
  belongs_to :position
  belongs_to :offer, class_name: Position
end
