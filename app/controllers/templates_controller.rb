class TemplatesController < ApplicationController
  def index
    render json: {templates: current_user.templates.all}
  end

  def destroy
    current_user.templates.find(params[:id]).destroy
    render json: {msg: "Шаблон успешно удален"}
  end
end
