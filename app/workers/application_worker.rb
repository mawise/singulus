# frozen_string_literal: true

# Base class for all other workers.
class ApplicationWorker
  include Sidekiq::Worker
end
