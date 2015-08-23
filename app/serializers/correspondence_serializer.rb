class CorrespondenceSerializer < CorrespondencesSerializer
  attributes :positions

  has_many :messages

  def positions
    ActiveModel::ArraySerializer.new(object.positions, each_serializer: PositionSerializer).as_json.group_by{|t| t[:user_id]}
  end
end
