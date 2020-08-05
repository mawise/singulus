# frozen_string_literal: true

# Receives and shows status for webmentions.
class WebmentionsController < ApplicationController
  def create
    @webmention = Webmention.new(webmention_params)
    if @webmention.save
      VerifyWebmentionWorker.perform_async(@webmention.id)
      head :created, location: webmention_url(@webmention.short_uid)
    else
      render json: { errors: @webmention.errors.as_json }.to_json, status: :internal_server_error
    end
  end

  def show
    @webmention = Webmention.find_by(short_uid: params[:id])
    head :not_found if @webmention.blank?
  end

  private

  def webmention_params
    permitted = params.permit(:source, :target)
    permitted[:source_url] = permitted.delete(:source)
    permitted[:target_url] = permitted.delete(:target)
    permitted
  end
end
