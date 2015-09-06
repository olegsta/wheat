class SearchController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        if params[:query].present?
          @positions = Position.where id: Position.search_for_ids(params[:query], :per_page => 10000)
        else
          @positions = Position
        end
        
        if params[:filters].present?
          @positions = @positions.filter JSON.parse(params[:filters])
        end

        @positions ||= Position.all_from_cache
        render json: MultiJson.dump(@positions.pluck_fields)
      end
    end
  end

  def suitable
    @suit_positions = Position.where id: params[:id]
    @positions = Position.find_suitable(@suit_positions).where.not(user_id: current_user.id)
    render json: MultiJson.dump(@positions.pluck_fields)
  end
end
