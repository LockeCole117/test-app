require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

def load_env_file(environment = nil)
  path = "#{Rails.root}/config/env#{environment.nil? ? '' : '.'+environment}.yml"
  return unless File.exist? path
  config = YAML.load(ERB.new(File.new(path).read).result)
  config.each { |key, value| ENV[key.to_s] = value.to_s }
end

module TestApp
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

    config.before_initialize do
      # Load environment variables. config/env.yml contains defaults which are
      # suitable for development. (This file is optional, in staging and production
      # it is deleted and replaced by a generated env.production.yml).
      load_env_file

      # Now look for custom environment variables, stored in env.[environment].yml
      # For development, this file is not checked into source control, so feel
      # free to tweak for your local development setup. This file is optional.
      load_env_file(ENV["RAILS_ENV"])
    end
  end
end
