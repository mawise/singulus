# frozen_string_literal: true

# [Micropub](https://micropub.spec.indieweb.org/) server implementation.
class MicropubController < ActionController::API
  include Doorkeeper::Helpers::Controller

  before_action :doorkeeper_authorize!

  def create
    @entry = Note.new(entry_params)
    @entry.author_id = doorkeeper_token.resource_owner_id
    @entry.published_at = Time.now.utc
    if save_entry
      PublishWorker.perform_async('create', 'note', @entry.id)
      head :accepted, location: @entry.permalink_url
    end
  end

  def show
    case query_params[:q]
    when 'config'
      render json: {}.to_json
    end
  end

  private

  def entry_params
    params.permit(:content)
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
