# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API
  include Doorkeeper::Helpers::Controller

  before_action :doorkeeper_authorize!

  def create
    case request.media_type
    when 'application/x-www-form-urlencoded'
      handle_form_encoded
    when 'application/json'
      handle_json
    end
  end

  def show
    case query_params[:q]
    when 'config'
      render json: {}.to_json
    end
  end

  private

  def handle_form_encoded
    create_entry(entry_params_form_encoded)
  end

  def handle_json
    attrs = entry_params_json[:properties].to_h.transform_values(&:first)
    create_entry(attrs)
  end

  def create_entry(attrs)
    @entry = Note.new(attrs)
    @entry.author_id = doorkeeper_token.resource_owner_id
    @entry.published_at = Time.now.utc
    if save_entry
      PublishWorker.perform_async('create', 'note', @entry.id)
      head :accepted, location: @entry.permalink_url
    else
      render json: { error: 'invalid_request', error_description: @entry.errors.full_messages }.to_json
    end
  end

  def entry_params_form_encoded
    params.permit(:content)
  end

  def entry_params_json
    params.permit(type: [], properties: { content: [] })
  end

  def create_attributes_json
    entry_params_json[:properties].map { |k, v| }
  end

  def save_entry
    on_retry = proc do |_, _try, _, _|
      Rails.logger.info('Collison generating short_uid, trying again')
    end
    Retriable.retriable on: [ActiveRecord::RecordNotUnique], on_retry: on_retry do
      @entry.save
    end
  end

  def query_params
    params.permit(:q)
  end

  def doorkeeper_unauthorized_render_options(*)
    { json: { error: 'unauthorized' } }
  end
end
