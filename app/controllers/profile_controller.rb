class ProfileController < ApplicationController
  def index
  end

  def show
    render json: User.find(params[:id]).info_from_cache
  end

  def update
    current_user.update(user_params)
  end

  private
    def user_params
      params.permit(:fullname, :email, :phones, :city, :address, :lat, :lng, :company, :additional)
    end
end
