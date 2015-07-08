class PositionsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: Position.all.pluck(:coords, :title, :weight, :price)
      end
    end
  end

  def search
    render json: {points: Position.all.pluck(:coords, :title, :weight, :price)}
  end
end
