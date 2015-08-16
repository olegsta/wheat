class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title

  def title
    I18n.t('category.items.'+object.title)
  end

end
