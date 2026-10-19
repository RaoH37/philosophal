# frozen_string_literal: true

require_relative 'test_helper'

class TestImmutable < Minitest::Test
  def test_value_is_frozen
    foo = Person.new
    foo.eyes_color = 'blue'

    assert_predicate foo.eyes_color, :frozen?
  end

  def test_value_is_converted
    foo = Person.new
    foo.eyes_color = :blue

    assert_equal 'blue', foo.eyes_color
  end

  def test_raise_on_second_assignment
    foo = Person.new
    foo.eyes_color = 'blue'

    error = assert_raises(FrozenError) { foo.eyes_color = 'green' }
    assert_includes error.message, '@eyes_color'
  end

  def test_value_kept_after_failed_assignment
    foo = Person.new
    foo.eyes_color = 'blue'
    assert_raises(FrozenError) { foo.eyes_color = 'green' }

    assert_equal 'blue', foo.eyes_color
  end

  def test_each_instance_can_be_assigned_once
    Person.new.eyes_color = 'blue'
    foo = Person.new
    foo.eyes_color = 'green'

    assert_equal 'green', foo.eyes_color
  end

  def test_other_properties_stay_mutable
    foo = Person.new
    foo.first_name = 'Maxime'
    foo.first_name = 'Max'

    assert_equal 'Max', foo.first_name
  end
end
