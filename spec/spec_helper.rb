require "simplecov"
require "simplecov-console"

if ENV["COVERAGE"]
  SimpleCov.start {
    enable_coverage :branch
  }
end

require_relative "../lib/reloj"

module AyudasDeZonaHoraria
  def en_zona(nombre)
    tz_original = ENV.to_h.slice("TZ")
    ENV["TZ"] = nombre
    yield
  ensure
    ENV.delete("TZ")
    ENV.update(tz_original)
  end
end

RSpec.configure { |config|
  config.include(AyudasDeZonaHoraria)
}
