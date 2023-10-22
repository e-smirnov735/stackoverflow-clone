class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def purge
    attachment = ActiveStorage::Attachment.find(params[:id])

    return unless attachment.record.author?(current_user)

    attachment.purge

    redirect_back fallback_location: questions_path
  end
end
