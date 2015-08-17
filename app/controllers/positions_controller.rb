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
        render json: Position.find_by(id: params[:id]), serializer: PositionSerializer
      }
    end
  end

  def create
    position = Position.new(position_params.update(user_id: current_user.id, images: params[:files]))
    if position.save
      render json: {msg: "Позиция успешно создана"}
    else
      render json: {errors: position.errors}, status: 422
    end
  end

  def update
    position = current_user.positions.find params[:id]
    if position.update(position_params)
      if params[:files].try(:any?)
        position.images += params[:files]
        position.save
      end
      render json: {msg: "Позиция успешно обновлена"}
    else
      render json: {errors: position.errors}, status: 422
    end
  end

  private
    def position_params
      temp = params.permit(:title, :trade_type_id, :option_id, :title, :weight, :weight_dimension_id, :weight_min, :weight_min_dimension_id, :price, :currency_id, :price_weight_dimension_id, :price_discount, :address, :city, :lat, :lng, :description)
    end
end
