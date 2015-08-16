class CurrencySerializer < ActiveModel::Serializer
  attributes :id, :title

  def title
    I18n.t("currency")[object.name.to_sym]
  end
end
