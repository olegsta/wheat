class CorrespondencesController < ApplicationController
  before_action :set_correspondence, only: [:show, :update]

  def index
    render json: current_user.correspondences, each_serializer: CorrespondencesSerializer, root: false
  end

  def show
    render json: @correspondence, serializer: CorrespondenceSerializer
  end

  def create
    @correspondence = Correspondence.create
    @correspondence.user_ids = [current_user.id, params[:user_id]]
    set_json_correspondence
    render json: {msg: "Переписка успешно создана"}
  end

  def update
    
  end

  private
    def set_correspondence
      @correspondence = current_user.correspondences.find(params[:id])
    end

    def set_json_correspondence
      @correspondence.json_users = @correspondence.users.as_json(only: [:id, :fullname, :avatar])
      @correspondence.json_positions = @correspondence.positions.as_json(only: [:id, :user_id, :trade_type_id, :option_id, :weight, :weight_dimension_id, :weight_min, :weight_min_dimension_id, :price, :currency_id, :price_weight_dimension_id])
      @correspondence.save
    end
end
