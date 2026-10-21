# frozen_string_literal: true

require_relative 'test_helper'

class TestChangedProperties < Minitest::Test
  include ClassBuilder

  def setup
    @klass = build_class do
      cprop :name, String, track_changes: true
      cprop :age, Integer, default: 18, track_changes: true
      cprop :city, String
    end
  end

  def test_is_empty_before_any_assignment
    assert_empty @klass.new.changed_properties
  end

  def test_returns_the_new_values
    obj = @klass.new
    obj.name = 'a'
    obj.age = '30'

    assert_equal({ name: 'a', age: 30 }, obj.changed_properties)
  end

  def test_skips_unchanged_properties
    obj = @klass.new
    obj.name = 'a'
    obj.age = 30
    obj.changes_applied
    obj.name = 'a'
    obj.age = 31

    assert_equal({ age: 31 }, obj.changed_properties)
  end

  def test_is_empty_after_changes_applied
    obj = @klass.new
    obj.name = 'a'
    obj.changes_applied

    assert_empty obj.changed_properties
  end

  def test_skips_untracked_properties
    obj = @klass.new
    obj.city = 'Paris'

    assert_empty obj.changed_properties
  end

  def test_returns_the_default_when_reset_to_nil
    obj = @klass.new
    obj.age = 30
    obj.changes_applied
    obj.age = nil

    assert_equal({ age: 18 }, obj.changed_properties)
  end
end
