class SearchController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {positions: Position.all.pluck(:id, :lat, :lng, :trade_type_id, :option_id, :weight, :weight_dimension_id, :price, :currency_id, :price_weight_dimension_id)}
      end
    end
  end
end
