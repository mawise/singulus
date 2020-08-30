# frozen_string_literal: true

# Receives and shows status for webmentions.
class WebmentionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  before_action :allow_site_target_only, only: %i[create]

  def create
    @webmention = Webmention.new(webmention_params)
    @webmention.received_at = Time.now.utc
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

  def allow_site_target_only
    site_url = Rails.configuration.x.site.url
    return if webmention_params[:target_url].blank? || webmention_params[:target_url].start_with?(site_url)

    error = { error: 'invalid_request', error_description: "Target must be on #{site_url}" }
    render json: error.to_json, status: :bad_request
  end

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
