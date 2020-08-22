# ================================================================================
# BUILDER
# ================================================================================

FROM ruby:2.7.1-alpine AS builder

RUN apk add --no-cache build-base nodejs postgresql-dev tzdata yarn

ENV RAILS_ENV=production
ENV RAILS_ROOT=/app/
RUN mkdir -p ${RAILS_ROOT}

WORKDIR ${RAILS_ROOT}

COPY package.json yarn.lock ./
RUN yarn install

# Install gems needed for production
COPY Gemfile* ./
RUN bundle install -j4 --retry 3 --without 'development test' --frozen && \
    bundle clean --force && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the application
COPY . ${RAILS_ROOT}

# Compile assets
RUN SECRET_KEY_BASE=$(bundle exec rails secret) \
    WEBPACK_COMPILE_ONLY=true \
    bundle exec rails webpacker:compile

# Clean up files that will be unnecessary in production
RUN rm -rf log/* node_modules tmp/cache

# ================================================================================
# PRODUCTION
# ================================================================================

FROM ruby:2.7.1-alpine as production

RUN apk add --no-cache \
    file \
    postgresql-client \
    tzdata

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

ENV RAILS_ENV=production
ENV RAILS_ROOT=/app/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR ${RAILS_ROOT}
EXPOSE 3000

COPY --from=builder --chown=app:app /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=app:app /app /app

CMD ["bin/puma", "-C", "config/puma.rb"]
