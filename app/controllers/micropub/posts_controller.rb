# frozen_string_literal: true

module Micropub
  # Provides  Micropub [create](https://micropub.spec.indieweb.org/#create),
  # [update](https://micropub.spec.indieweb.org/#update), and
  # [delete](https://micropub.spec.indieweb.org/#delete) endpoints.
  class PostsController < MicropubController
    before_action :handle_unsupported_media_type!

    def create
      case request.media_type
      when 'application/x-www-form-urlencoded', 'multipart/form-data'
        post = Micropub::CreatePostMultipart.new.call(post_params_form_encoded)
      when 'application/json'
        post = Micropub::CreatePostJSON.new.call(post_params_json)
      end

      post ? render_success(post) : render_error(post)
    end

    private

    def render_success(post)
      head :accepted, location: post.permalink_url
    end

    def render_error(_post)
      error = { error: 'invalid_request', error_description: @post.errors.full_messages }.to_json
      render json: error, status: :bad_request
    end

    def supported_media_types
      %w[application/json application/x-www-form-urlencoded multipart/form-data]
    end

    def post_params_form_encoded
      %i[category photo].each { |p| params[p] = Array(params[p]) if params.key?(p) }
      default_params.merge(params.permit(:content, category: [], photo: []))
    end

    def post_params_json
      default_params.merge(params.permit(type: [], properties: {}))
    end

    def default_params
      { author_id: doorkeeper_token.resource_owner_id }
    end
  end
end
