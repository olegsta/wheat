class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    {
      original: object.file.url,
      thumb: object.file.thumb.url
    }
  end
end
