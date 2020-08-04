# frozen_string_literal: true

module RequestHelpers
  def delete(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def get(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def options(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def patch(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def post(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def put(path, **args)
    args[:headers] ||= {}
    args[:headers].merge!(host_headers)
    super(path, **args)
  end

  def host_headers
    {
      Host: Rails.configuration.x.hub.host
    }
  end

  module Shortlinks
    def host_headers
      {
        Host: Rails.configuration.x.shortlinks.host
      }
    end
  end
end
