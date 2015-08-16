class OptionSerializer < ActiveModel::Serializer
  attributes :id, :title
  
  def title
    I18n.t('option.'+object.title)
  end

end
