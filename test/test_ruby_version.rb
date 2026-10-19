# frozen_string_literal: true

require_relative 'test_helper'

class TestRubyVersion < Minitest::Test
  MINIMUM_RUBY_VERSION = Gem::Version.new('3.3')

  def test_running_ruby_meets_minimum_version
    assert_operator Gem::Version.new(RUBY_VERSION), :>=, MINIMUM_RUBY_VERSION
  end

  def test_gemspec_requires_minimum_version
    gemspec = Gem::Specification.load(File.expand_path('../philosophal.gemspec', __dir__))

    assert_equal Gem::Requirement.new(">= #{MINIMUM_RUBY_VERSION}"), gemspec.required_ruby_version
  end
end
