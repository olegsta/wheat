class CorrespondencesController < ApplicationController
  before_action :set_correspondence, only: [:show, :update]

  def index
    render json: current_user.correspondences, each_serializer: CorrespondencesSerializer
  end

  def show
    render json: @correspondence, serializer: CorrespondenceSerializer
  end

  def create

  end

  def update
    @message = Message.new(body: params[:body], user_id: current_user.id, correspondence_id: @correspondence.id)
    if @message.save
      render json: {}
    else
      render json: {msg: "Нельзя отправить пустое сообщение"}, status: 422
    end
  end

  private
    def set_correspondence
      @correspondence = current_user.correspondences.find(params[:id])
    end
end
