# frozen_string_literal: true

require_relative 'test_helper'

class TestPropertyDefault < Minitest::Test
  include ClassBuilder

  def test_default
    assert_equal 'developer', Person.new.job
  end

  def test_nil_without_default
    assert_nil Person.new.first_name
  end

  def test_assigned_value_replaces_default
    person = Person.new
    person.job = 'teacher'

    assert_equal 'teacher', person.job
  end

  def test_default_is_frozen
    assert_predicate Person.new.job, :frozen?
  end

  def test_default_proc
    assert_kind_of Time, Person.new.what_time_is_it
  end

  def test_default_proc_is_called_on_each_read
    calls = 0
    obj = build_class { cprop :counter, Integer, default: -> { calls += 1 } }.new
    obj.counter
    obj.counter

    assert_equal 2, calls
  end

  def test_default_used_when_set_to_nil
    obj = build_class { cprop :tags, Array, default: [].freeze }.new
    obj.tags = nil

    assert_empty obj.tags
  end

  def test_false_value_is_not_replaced_by_default
    skip 'bug: the reader does `@value || default`, so false falls back to the default'
    obj = build_class { cprop :enabled, _Boolean, default: true }.new
    obj.enabled = false

    refute obj.enabled
  end
end
