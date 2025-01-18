# frozen_string_literal: true

require_relative 'test_helper'

class TestPropertyDefault < Minitest::Test
  def test_default
    person = Person.new

    assert_equal 'developer', person.job
  end

  def test_default_proc
    person = Person.new

    assert_kind_of Time, person.what_time_is_it
  end

  def test_default_proc_time
    now = Time.now
    sleep 0.1
    person = Person.new

    assert_operator person.what_time_is_it, :>, now
  end
end
