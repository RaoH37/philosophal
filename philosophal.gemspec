# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name     = 'philosophal'
  spec.version  = File.read(File.expand_path('VERSION', __dir__)).strip
  spec.authors  = ['Maxime Désécot']
  spec.email    = ['maxime.desecot@gmail.com']

  spec.summary = 'Typed, auto-converting properties for Ruby classes'
  spec.description = 'Declare typed attributes with cprop: values are converted, transformed, ' \
                     'defaulted or frozen on assignment, with JSON import/export.'
  spec.homepage = 'https://github.com/RaoH37/philosophal'
  spec.required_ruby_version = '>= 3.3'

  spec.license = 'GPL-3.0-only'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = 'https://github.com/RaoH37/philosophal/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/RaoH37/philosophal/blob/main/CHANGELOG.md'

  spec.files = Dir['lib/**/*.rb', 'sig/**/*.rbs', 'sig/manifest.yaml', 'README.md', 'LICENSE', 'CHANGELOG.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'json', '~> 2.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
