release: rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY:-5} -q default -q hugo -q webmention -q photo_derivatives
