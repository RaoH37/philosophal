# frozen_string_literal: true

require_relative 'test_helper'

class TestCpropOptions < Minitest::Test
  include ClassBuilder

  def test_reject_invalid_transform
    error = assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, transform: 'upcase' } }

    assert_includes error.message, '(name)'
  end

  def test_reject_non_boolean_override
    assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, override: nil } }
  end

  def test_reject_non_boolean_immutable
    assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, immutable: 'yes' } }
  end

  def test_reject_non_boolean_track_changes
    assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, track_changes: 'yes' } }
  end

  def test_reject_non_string_description
    assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, description: :name } }
  end

  def test_reject_invalid_json
    assert_raises(Philosophal::ArgumentError) { build_class { cprop :name, String, json: 1 } }
  end

  def test_argument_error_is_a_ruby_argument_error
    assert_operator Philosophal::ArgumentError, :<, ::ArgumentError
  end

  def test_json_string_is_stored_as_symbol
    klass = build_class { cprop :name, String, json: 'Name' }

    assert_equal :Name, klass.philosophal_properties[:name].json_name
  end

  def test_description_is_frozen
    klass = build_class { cprop :name, String, description: +'the name' }

    assert_predicate klass.philosophal_properties[:name].description, :frozen?
  end
end
