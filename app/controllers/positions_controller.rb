class PositionsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        render json: current_user.positions.includes(:offers, :user, :option, :category, :weight_dimension, :price_weight_dimension, :weight_min_dimension, :currency), each_serializer: PositionWithOffersSerializer
      }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        render json: current_user.positions.find_by(id: params[:id]), serializer: PositionSerializer
      }
    end
  end

  def create
    position = Position.new(position_params.update(user_id: current_user.id))
    if position.save
      render json: position_params
    else
      render json: {errors: position.errors}, status: 422
    end
  end

  private
    def position_params
      params.require(:position).permit(:title, :trade_type_id, :option_id, :title, :weight, :weight_dimension_id, :weight_min, :weight_min_dimension_id, :price, :currency_id, :price_weight_dimension_id, :price_discount, :address, :city, :lat, :lng, :description)
    end
end
