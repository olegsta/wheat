class AttachmentsController < ApplicationController


  def upload
    attachments = params[:attachments].map do |attachment|
      Attachment.create(file: attachment, user_id: current_user.id)
    end

    render json: attachments
  end
end
