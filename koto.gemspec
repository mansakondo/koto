# frozen_string_literal: true

require_relative "lib/koto/version"

Gem::Specification.new do |spec|
  spec.name          = "koto"
  spec.version       = Koto::VERSION
  spec.authors       = ["mansakondo"]
  spec.email         = ["mansakondo22@gmail.com"]

  spec.summary       = "A Ruby symbol solver"
  spec.homepage      = "https://github.com/mansakondo/koto.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'parser', '~> 3.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
