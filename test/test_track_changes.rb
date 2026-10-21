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

  def test_assignment_before_changes_applied_is_a_change
    obj = @klass.new
    obj.name = 'a'

    assert_nil obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_values_are_compared_after_conversion
    obj = @klass.new
    obj.age = 30
    obj.changes_applied
    obj.age = '30'

    refute_predicate obj, :age_changed?
  end

  def test_was_ignores_the_default
    obj = @klass.new
    obj.changes_applied

    assert_nil obj.age_was
    assert_equal 18, obj.age
  end

  def test_assigning_nil_is_a_change
    obj = @klass.new
    obj.name = 'a'
    obj.changes_applied
    obj.name = nil

    assert_equal 'a', obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_failed_conversion_keeps_the_value
    klass = build_class { cprop :flag, _Boolean, track_changes: true }
    obj = klass.new
    obj.flag = true
    obj.changes_applied
    assert_raises(Philosophal::TypeError) { obj.flag = 'maybe' }

    refute_predicate obj, :flag_changed?
  end

  def test_immutable_property
    obj = @klass.new
    obj.code = 'X1'

    assert_predicate obj, :code_changed?
    obj.changes_applied

    assert_equal 'X1', obj.code_was
    refute_predicate obj, :code_changed?
  end

  def test_instances_are_tracked_separately
    first = @klass.new
    second = @klass.new
    first.name = 'a'
    first.changes_applied
    second.name = 'b'

    assert_equal 'a', first.name_was
    assert_nil second.name_was
  end

  def test_inherited_by_subclasses
    obj = Class.new(@klass).new
    obj.name = 'a'
    obj.changes_applied
    obj.name = 'b'

    assert_equal 'a', obj.name_was
  end
end
