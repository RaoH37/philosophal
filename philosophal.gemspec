# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name     = 'philosophal'
  spec.version  = File.read(File.expand_path('VERSION', __dir__)).strip
  spec.authors  = ['Maxime Désécot']
  spec.email    = ['maxime.desecot@gmail.com']

  spec.summary = 'Philosophal setter convertor'
  spec.description = 'Auto convert value on setter method call'
  spec.homepage = 'https://github.com/RaoH37/philosophal'
  spec.required_ruby_version = '>= 3.1'

  spec.license = 'GPL-3.0-only'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/RaoH37/philosophal'
  spec.metadata['changelog_uri'] = 'https://github.com/RaoH37/philosophal/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
