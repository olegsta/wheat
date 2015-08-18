class PositionsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        render json: current_user.positions.where(status: params[:status]).includes(:offers, :user, :option, :category, :weight_dimension, :price_weight_dimension, :weight_min_dimension, :currency, :attachments), each_serializer: PositionWithOffersSerializer
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
    @position = current_user.positions.new(position_params)

    if @position.save
      associate_attachment
      save_template
      render json: {msg: "Позиция успешно создана"}
    else
      render json: {errors: @position.errors}, status: 422
    end
  end

  def update
    @position = current_user.positions.find params[:id]
    if @position.update(position_params)
      associate_attachment
      render json: {msg: "Позиция успешно обновлена"}
    else
      render json: {errors: @position.errors}, status: 422
    end
  end

  private
    def position_params
      params.require(:position).permit( :title, :trade_type_id, :option_id, :title, :weight,
                                        :weight_dimension_id, :weight_min, :weight_min_dimension_id,
                                        :price, :currency_id, :price_weight_dimension_id, :price_discount,
                                        :address, :city, :lat, :lng, :description)
    end

    def associate_attachment
      attachments = params[:position][:attachments]
      if attachments.present?
        attachment_ids = attachments.map{|attachment| attachment[:id]}
        Attachment.where(id: attachment_ids).update_all(position_id: @position.id)
      end
      current_user.attachments.where(position_id: nil).destroy_all
    end

    def save_template
      if params[:position][:is_template].present?
        current_user.templates.create title: params[:position][:template_title], position: @position.attributes
      end
    end
end
