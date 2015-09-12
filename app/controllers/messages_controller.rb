class MessagesController < ApplicationController
  before_action :set_correspondence, only: [:create]

  def index
  end

  def create
    @message = Message.new(body: params[:body], user_id: current_user.id, correspondence_id: @correspondence.id)
    if @message.save
      render json: {}
    else
      render json: {msg: "Нельзя отправить пустое сообщение"}, status: 422
    end
  end

  private
    def set_correspondence
      @correspondence = current_user.correspondences.find(params[:correspondence_id])
    end
end
