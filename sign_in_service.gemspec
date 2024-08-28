# frozen_string_literal: true

require_relative 'lib/sign_in_service/version'

Gem::Specification.new do |spec|
  spec.name = 'sign_in_service'
  spec.version = SignInService::VERSION
  spec.authors = ['Riley Anderson']
  spec.email = ['riley.anderson@oddball.io']

  spec.summary = 'Wrapper for the VA SignInService API'
  spec.homepage = 'https://github.com/department-of-veterans-affairs/sign-in-service-rb'
  spec.license  = 'CC0-1.0'
  spec.required_ruby_version = '>= 3.3'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/department-of-veterans-affairs/sign-in-service-rb'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'jwt', '~> 2.8'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
