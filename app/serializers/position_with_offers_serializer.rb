class PositionWithOffersSerializer < PositionSerializer
  has_many :offers, serializer: OfferSerializer

end
