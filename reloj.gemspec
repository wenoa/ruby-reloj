require_relative "lib/reloj"

Gem::Specification.new { |spec|
  spec.name = "reloj"
  spec.version = Reloj::VERSION
  spec.authors = ["Wenoa Studio"]
  spec.email = ["desarrollo@wenoa.studio"]

  spec.summary = "Una abstracción de un reloj"
  spec.description = spec.summary
  spec.homepage = "https://github.com/wenoa/ruby-reloj"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
}
