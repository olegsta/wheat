class CorrespondencesSerializer < ActiveModel::Serializer
  attributes :id, :user, :position, :correspondence_type

  def user
    Rails.cache.fetch("correspondence_user_#{object.id}_#{I18n.locale}") do
      user_id = (object.users_ids - [scope.current_user.id]).first
      User.info_from_cache(user_id)
    end
  end

  def position
    if object.positions_ids.any?
      Rails.cache.fetch("correspondence_position_#{object.id}_#{I18n.locale}") do
        index = object.users_ids.index { |id| id != scope.current_user.id}
        position_id = object.positions_ids[index]
        Position.serialize_from_cache(position_id) rescue nil
      end
    end
  end
end
