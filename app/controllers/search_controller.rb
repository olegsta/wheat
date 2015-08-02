class SearchController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {positions: Position.all.pluck(:coords, :title, :weight, :price)}
      end
    end
  end
end
