class PositionSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :weight, :weight_dimension, :weight_dimension_id, :title, :description,
             :trade_type, :trade_type_id, :currency, :price, :user, :weight_min, :weight_min_dimension_id,
             :weight_min_dimension, :city, :lat, :lng, :address, :price_weight_dimension, :price_weight_dimension_id, :option, :option_id, :category

  has_one :option, serializer: OptionSerializer
  has_one :category, serializer: CategorySerializer
  has_one :weight_dimension
  has_one :weight_min_dimension

  def user
    {
      id: object.user.id,
      fullname: object.user.fullname
    }
  end

  def trade_type
    {
      id: object.trade_type_id,
      title: I18n.t("position.dictionary.trade_types")[object.trade_type_id]
    }
  end

  def currency
    {
      id: object.currency_id,
      title: I18n.t("currency")[object.currency.try(:name).try(:to_sym)]
    }
  end

  def weight_min_dimension
    {
      id: object.weight_min_dimension_id,
      title: I18n.t("weight")[object.weight_min_dimension.try(:name).try(:to_sym)],
    }
  end

  def weight_dimension
    {
      id: object.weight_dimension_id,
      title: I18n.t("weight")[object.weight_dimension.try(:name).try(:to_sym)]
    }
  end

  def price_weight_dimension
    {
      id: object.price_weight_dimension_id,
      title: I18n.t("weight")[object.price_weight_dimension.try(:name).try(:to_sym)]
    }
  end
end
