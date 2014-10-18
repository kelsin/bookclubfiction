require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bookclubfiction
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators do |g|
      g.orm :mongo_mapper
    end

    # Setup Faye
    Faye::WebSocket.load_adapter('thin') unless Rails.env.production?

    Thread.new { EM.run }
    config.middleware.use(Faye::RackAdapter,
                          :mount => '/faye',
                          :timeout    => 25,
                          :engine  => {
                            :type  => Faye::Redis,
                            :host  => 'localhost',
                            :port  => 6379 })
    config.middleware.delete "Rack::Lock"
  end
end
