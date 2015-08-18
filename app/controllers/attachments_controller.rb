class AttachmentsController < ApplicationController
  def upload
    attachments = params[:attachments].map do |attachment|
      Attachment.create(file: attachment, user_id: current_user.id)
    end

    render json: attachments
  end

  def destroy
    Attachment.find_by(id: params[:id], user_id: current_user.id).destroy
    render json: {}
  end
end
