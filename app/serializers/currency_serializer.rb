class CurrencySerializer < ActiveModel::Serializer
  attributes :id, :title, :name

  def title
    I18n.t("currency")[object.name.to_sym]
  end
end
