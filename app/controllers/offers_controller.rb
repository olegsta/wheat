class OffersController < ApplicationController
  before_action :permission, only: [:create, :update]

  def index
    respond_to do |format|
      format.html
      format.json {
        if current_user
          @offers = current_user.offers_from_cache
        else
          @offers = []
        end
        render json: MultiJson.dump(@offers)
      }
    end
  end

  def create
    respond_to do |format|
      format.json {
        position_offers = PositionsOffer.where(position_id: params[:position_id], offer_id: params[:offer_id])
        if position_offers.any?
          render json: {msg: "Предложение было отправлено ранее"}, status: 422
        else
          position_offer = PositionsOffer.new(position_id: params[:position_id], offer_id: params[:offer_id])
          if position_offer.save
            
            user_ids = [current_user.id, Position.find(params[:position_id]).user_id]
            position_ids = [params[:position_id], params[:offer_id]]

            unless Correspondence.between_users(user_ids)
              Correspondence.create_between_users user_ids
            end

            unless @correspondence = Correspondence.between_positions(position_ids)
              @correspondence = Correspondence.create_between_users user_ids
              @correspondence.associate_with_positions position_ids
            end

            Message.create(correspondence_id: @correspondence.id, body: "Новое предложение", user_id: current_user.id)
            
            render json: {msg: "Предложение было успешно отправлено"}
          else
            render json: {msg: position_offer.errors.first.last}, status: 422
          end
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json {
        PositionsOffer.where(position_id: params[:position_id], offer_id: params[:offer_id]).destroy
      }
    end
  end

  private
    def permission
      @position = current_user.positions.find_by(id: params[:offer_id])

      unless @position
        render json: {msg: "Нет прав на данное действие"}, status: 422
      end
    end
end
