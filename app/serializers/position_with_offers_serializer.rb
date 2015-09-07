class PositionWithOffersSerializer < PositionSerializer
  attributes :offers

  has_many :offers
end
