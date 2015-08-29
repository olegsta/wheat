class SearchController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        if params[:query].present?
          @positions = Position.where id: Position.search_for_ids(params[:query], :per_page => 10000)
        else
          @positions = Position.all
        end
        if params[:filters].present?
          @positions = @positions.filter JSON.parse(params[:filters])
        end
        render json: {positions: @positions.pluck(:id, :lat, :lng, :trade_type_id, :option_id, :weight, :weight_dimension_id, :price, :currency_id, :price_weight_dimension_id)}
      end
    end
  end
end
