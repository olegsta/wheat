class PositionsController < ApplicationController
  before_action :set_position, only: [:destroy, :update, :restore]

  def index
    respond_to do |format|
      format.html
      format.json {
        if current_user
          @positions = current_user.positions_from_cache(params[:status])
        else
          @positions = []
        end
        render json: MultiJson.dump(@positions)
      }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        @position = Position.serialize_from_cache(params[:id])
        result = {position: @position}
        if params[:with_suitable] && current_user && @position[:user_id] != current_user.id
          @suit_positions = current_user.positions.full.find_suitable Position.where(id: params[:id])
          result[:suit_positions] = ActiveModel::ArraySerializer.new(@suit_positions, each_serializer: PositionSerializer, root: false)
        end
        render json: MultiJson.dump(result)
      }
    end
  end

  def create
    @position = current_user.positions.new(position_params)

    if @position.save
      associate_attachment
      save_template
      render json: {msg: "Позиция успешно создана", position: @position}
    else
      render json: {errors: @position.errors}, status: 422
    end
  end

  def update
    if @position.update(position_params)
      associate_attachment
      render json: {msg: "Позиция успешно обновлена", position: @position}
    else
      render json: {errors: @position.errors}, status: 422
    end
  end

  def destroy
    @position.move_to_archive!
    @correspondences = Correspondence.where("#{@position.id} = ANY(positions_ids)")
    @correspondences.each do |correspondence|
      Message.create(correspondence_id: correspondence.id, user_id: current_user.id, body: "Пользователь перенес свою позицию в архив.")
    end
    PositionsOffer.destroy_all("offer_id = #{@position.id} OR position_id = #{@position.id}")
    render json: {msg: "Позиция была перемещена в архив"}
  end

  def restore
    @position.open!
    render json: {msg: "Позиция была восстановлена в рынок"}
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

    def set_position
      @position = current_user.positions.find params[:id]
    end
end
