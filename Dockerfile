ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-alpine AS base

WORKDIR /rails

# 1. RUNTIME DEPENDENCIES
# gcompat: for the tailwindcss binary
# sqlite-libs: for your sqlite3 gem
# ca-certificates: for Postmark emails
# libvips: for image_processing (Active Storage)
RUN apk add --no-cache \
    curl \
    vips \
    sqlite-libs \
    tzdata \
    gcompat \
    bash \
    ca-certificates

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    RUBYOPT="--yjit"


# 2. BUILD STAGE
FROM base AS build

# build-base: needed to compile bcrypt and sqlite3 gems
RUN apk add --no-cache build-base git yaml-dev

COPY Gemfile Gemfile.lock ./

COPY . .

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Precompile bootsnap & assets (Tailwind binary runs here)
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# 3. FINAL STAGE
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Ensure the rails user owns the storage directory for SQLite/SolidQueue
RUN addgroup --system --gid 1000 rails && \
    adduser rails --uid 1000 --ingroup rails --shell /bin/bash --disabled-password && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80
# Thruster handles the serving, Rails handles the app
CMD ["./bin/thrust", "./bin/rails", "server"]
