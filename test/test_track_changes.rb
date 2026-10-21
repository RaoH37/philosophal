# frozen_string_literal: true

require_relative 'test_helper'

class TestTrackChanges < Minitest::Test
  include ClassBuilder

  def setup
    @klass = build_class do
      cprop :name, String, track_changes: true
      cprop :age, Integer, default: 18, track_changes: true
      cprop :code, String, immutable: true, track_changes: true
      cprop :city, String
    end
  end

  def test_methods_are_defined_only_with_the_option
    obj = @klass.new

    assert_respond_to obj, :name_was
    assert_respond_to obj, :name_changed?
    refute_respond_to obj, :city_was
    refute_respond_to obj, :city_changed?
  end

  def test_before_any_assignment
    obj = @klass.new

    assert_nil obj.name_was
    refute_predicate obj, :name_changed?
  end

  def test_first_assignment
    obj = @klass.new
    obj.name = 'a'

    assert_nil obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_was_is_the_value_before_the_last_assignment
    obj = @klass.new
    obj.name = 'a'
    obj.name = 'b'

    assert_equal 'a', obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_assigning_the_same_value_is_not_a_change
    obj = @klass.new
    obj.name = 'b'
    obj.name = 'b'

    assert_equal 'b', obj.name_was
    refute_predicate obj, :name_changed?
  end

  def test_values_are_compared_after_conversion
    obj = @klass.new
    obj.age = 30
    obj.age = '30'

    assert_equal 30, obj.age_was
    refute_predicate obj, :age_changed?
  end

  def test_was_ignores_the_default
    obj = @klass.new
    obj.age = 30

    assert_nil obj.age_was
  end

  def test_assigning_nil_is_a_change
    obj = @klass.new
    obj.name = 'a'
    obj.name = nil

    assert_equal 'a', obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_failed_conversion_keeps_the_tracking
    klass = build_class { cprop :flag, _Boolean, track_changes: true }
    obj = klass.new
    obj.flag = true
    obj.flag = false
    assert_raises(Philosophal::TypeError) { obj.flag = 'maybe' }

    assert_equal true, obj.flag_was # rubocop:disable Minitest/AssertTruthy
    assert_predicate obj, :flag_changed?
  end

  def test_immutable_property
    obj = @klass.new
    obj.code = 'X1'

    assert_nil obj.code_was
    assert_predicate obj, :code_changed?
  end

  def test_instances_are_tracked_separately
    first = @klass.new
    second = @klass.new
    first.name = 'a'
    first.name = 'b'

    assert_nil second.name_was
    refute_predicate second, :name_changed?
  end

  def test_inherited_by_subclasses
    obj = Class.new(@klass).new
    obj.name = 'a'
    obj.name = 'b'

    assert_equal 'a', obj.name_was
  end
end
