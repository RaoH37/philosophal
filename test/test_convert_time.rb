# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertTime < Minitest::Test
  TIME = Time.new(2025, 3, 24, 10, 20, 30)

  def test_keep_time
    foo = Person.new
    foo.what_time_is_it = TIME

    assert_equal TIME, foo.what_time_is_it
  end

  def test_convert_string_as_time
    foo = Person.new
    foo.what_time_is_it = '2025-03-24 10:20:30'

    assert_equal TIME, foo.what_time_is_it
  end

  def test_convert_array_as_time
    foo = Person.new
    foo.what_time_is_it = [2025, 3, 24, 10, 20, 30]

    assert_equal TIME, foo.what_time_is_it
  end

  def test_convert_integer_as_time
    foo = Person.new
    foo.what_time_is_it = TIME.to_i

    assert_equal TIME, foo.what_time_is_it
  end

  def test_raise_when_not_convertible
    foo = Person.new

    assert_raises(Philosophal::TypeError) { foo.what_time_is_it = Object.new }
  end
end
