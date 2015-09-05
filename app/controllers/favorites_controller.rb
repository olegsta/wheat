class FavoritesController < ApplicationController

  def index
    respond_to do |format|
      format.json {
        @favorites = current_user.favorites_from_cache rescue []
        render json: MultiJson.dump(@favorites)
      }
    end
  end

  def update
    respond_to do |format|
      format.json {
        favorite_position = FavoritePosition.where user_id: current_user.id, position_id: params[:id]

        if favorite_position.any?
          favorite_position.first.destroy
        else
          favorite_position.create
        end
        
        @favorites = current_user.favorites_from_cache

        render json: MultiJson.dump(@favorites)
      }
    end
  end
end
