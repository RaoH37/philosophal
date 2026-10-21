# frozen_string_literal: true

require_relative 'test_helper'

class TestChangesApplied < Minitest::Test
  include ClassBuilder

  def setup
    @klass = build_class { cprop :name, String, track_changes: true }
  end

  def test_sets_the_reference
    obj = @klass.new
    obj.name = 'a'
    obj.changes_applied

    assert_equal 'a', obj.name_was
    refute_predicate obj, :name_changed?
  end

  def test_was_is_the_value_at_changes_applied
    obj = @klass.new
    obj.name = 'a'
    obj.changes_applied
    obj.name = 'b'
    obj.name = 'c'

    assert_equal 'a', obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_back_to_the_reference_is_not_a_change
    obj = @klass.new
    obj.name = 'a'
    obj.changes_applied
    obj.name = 'b'
    obj.name = 'a'

    refute_predicate obj, :name_changed?
  end

  def test_in_place_modification_is_a_change
    obj = @klass.new
    obj.name = +'a'
    obj.changes_applied
    obj.name << 'b'

    assert_equal 'a', obj.name_was
    assert_predicate obj, :name_changed?
  end

  def test_returns_the_object
    obj = @klass.new

    assert_same obj, obj.changes_applied
  end
end
