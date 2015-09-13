class CorrespondenceSerializer < CorrespondencesSerializer
  attributes :positions

  has_many :messages

  def positions
    Rails.cache.fetch("correspondence_positions_#{object.id}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(object.positions, each_serializer: PositionSerializer).as_json.group_by{|t| t[:user_id]}
    end
  end
end
