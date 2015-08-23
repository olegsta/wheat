class PositionSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :status, :weight, :weight_dimension, :weight_dimension_id, :title, :description, :images,
             :trade_type, :trade_type_id, :currency, :currency_id, :price, :user_id, :user, :weight_min, :weight_min_dimension_id, :price_discount,
             :weight_min_dimension, :city, :lat, :lng, :address, :price_weight_dimension, :price_weight_dimension_id, :option, :option_id, :category

  has_one :option, serializer: OptionSerializer
  has_one :category, serializer: CategorySerializer
  has_one :weight_dimension
  has_one :weight_min_dimension
  has_many :attachments

  def images
    
  end

  def user
    {
      id: object.user.id,
      fullname: object.user.fullname,
      avatar: object.user.avatar.thumb.url
    }
  end

  def status
    {
      id: object.status.to_sym,
      title: I18n.t("position.status")[object.status.to_sym]
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
