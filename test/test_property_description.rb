# frozen_string_literal: true

require_relative 'test_helper'

class TestPropertyDescription < Minitest::Test
  include ClassBuilder

  def test_description_method_present
    assert_respond_to Person.new, :first_name_description
  end

  def test_description_method_not_present
    refute_respond_to Person.new, :last_name_description
  end

  def test_description_equal
    assert_equal 'description of my first name property', Person.new.first_name_description
  end

  def test_cprop_descriptions
    assert_equal({ first_name: 'description of my first name property' }, Person.cprop_descriptions)
  end

  def test_description_with_quotes_and_newline
    description = %(the "name"\nor 'nickname')
    klass = build_class { cprop :name, String, description: }

    assert_equal description, klass.new.name_description
  end

  def test_description_with_parentheses
    klass = build_class { cprop :name, String, description: 'the name (or nickname' }

    assert_equal 'the name (or nickname', klass.new.name_description
  end

  def test_description_is_not_interpolated
    klass = build_class { cprop :name, String, description: 'value: #{1 + 1}' } # rubocop:disable Lint/InterpolationCheck

    assert_equal 'value: #{1 + 1}', klass.new.name_description # rubocop:disable Lint/InterpolationCheck
  end

  def test_subclass_description
    parent = build_class { cprop :name, String, description: 'parent' }
    klass = build_class(parent) { cprop :name, String, description: 'child' }

    assert_equal 'child', klass.new.name_description
    assert_equal 'parent', parent.new.name_description
  end
end
