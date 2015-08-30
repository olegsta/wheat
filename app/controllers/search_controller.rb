class SearchController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        if params[:query].present? || params[:filters].present? || params[:id].try(:any?)
          if params[:query].present?
            @positions = Position.where id: Position.search_for_ids(params[:query], :per_page => 10000)
          else
            @positions = Position.all
          end
          
          if params[:filters].present?
            @positions = @positions.filter JSON.parse(params[:filters])
          end

          if params[:id].try(:any?)
            @positions = @positions.find_suitable params[:id]
          end
          
          @positions = @positions.pluck_fields
        else
          @positions = Position.all_from_cache
        end


        render json: MultiJson.dump(@positions)
      end
    end
  end
end
