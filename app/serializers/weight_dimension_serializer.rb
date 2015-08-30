class WeightDimensionSerializer < ActiveModel::Serializer
  attributes :id, :title, :convert

  def title
    I18n.t("weight")[object.name.to_sym]
  end
end
