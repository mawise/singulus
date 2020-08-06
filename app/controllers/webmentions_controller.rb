# frozen_string_literal: true

# Receives and shows status for webmentions.
class WebmentionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def create
    @webmention = Webmention.new(webmention_params)
    if @webmention.save
      VerifyWebmentionWorker.perform_async(@webmention.id)
      head :created, location: webmention_url(@webmention.short_uid)
    else
      render json: error_response(@webmention), status: :bad_request
    end
  end

  def show
    @webmention = Webmention.find_by(short_uid: params[:id])
    head :not_found if @webmention.blank?
  end

  private

  def error_response(webmention)
    {
      error: 'invalid_request',
      error_description: webmention.errors.as_json
    }.to_json
  end

  def webmention_params
    permitted = params.permit(:source, :target)
    permitted[:source_url] = permitted.delete(:source)
    permitted[:target_url] = permitted.delete(:target)
    permitted
  end
end
