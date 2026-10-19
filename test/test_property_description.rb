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

  def test_description_with_parentheses
    skip 'bug: the description is written inside %(...) in generated code'
    klass = build_class { cprop :name, String, description: 'the name (or nickname' }

    assert_equal 'the name (or nickname', klass.new.name_description
  end

  def test_description_is_not_interpolated
    skip 'bug: the description is evaluated as Ruby code, so #{...} is interpolated'
    klass = build_class { cprop :name, String, description: 'value: #{1 + 1}' } # rubocop:disable Lint/InterpolationCheck

    assert_equal 'value: #{1 + 1}', klass.new.name_description # rubocop:disable Lint/InterpolationCheck
  end
end
