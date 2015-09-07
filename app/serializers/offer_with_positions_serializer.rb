class OfferWithPositionsSerializer < PositionSerializer
  attributes :positions

  has_many :positions
end
