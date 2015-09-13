class CorrespondencesController < ApplicationController
  before_action :set_correspondence, only: [:show, :update]

  def index
    render json: current_user.correspondences.includes(:positions, :correspondence_positions, :correspondence_users, :users, :messages).order('updated_at desc'), each_serializer: CorrespondencesSerializer, root: false
  end

  def show
    render json: @correspondence, serializer: CorrespondenceSerializer
  end

  def create
    user_ids = [current_user.id, params[:user_id]]
    unless Correspondence.between_users(user_ids)
      Correspondence.create_between_users user_ids
    end
    render json: {msg: "Переписка успешно создана"}
  end

  def update
    
  end

  private
    def set_correspondence
      @correspondence = current_user.correspondences.find(params[:id])
    end
end
