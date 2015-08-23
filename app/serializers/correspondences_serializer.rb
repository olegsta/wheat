class CorrespondencesSerializer < ActiveModel::Serializer
  attributes :id, :user, :position, :correspondence_type

  def user
    object.json_users.select{ |user| user["id"] != scope.current_user.id }.first
  end

  def position
    object.json_positions.select{ |position| position["id"] != scope.current_user.id }.first
  end
end
