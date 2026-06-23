# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertTime < Minitest::Test
  def test_convert_string_as_date
    format = '%Y-%m-%d %H:%M:%S'
    now = Time.now
    now_str = now.strftime(format)

    foo = Person.new
    foo.what_time_is_it = now_str

    assert_equal now.strftime(format), foo.what_time_is_it.strftime(format)
  end

  def test_convert_array_as_time
    format = '%Y-%m-%d %H:%M:%S'
    now = Time.now
    array = [now.year, now.month, now.day, now.hour, now.min, now.sec]

    foo = Person.new
    foo.what_time_is_it = array

    assert_equal now.strftime(format), foo.what_time_is_it.strftime(format)
  end

  def test_convert_integer_as_date
    format = '%Y-%m-%d %H:%M:%S'
    now = Time.now
    int = now.to_i

    foo = Person.new
    foo.what_time_is_it = int

    assert_equal now.strftime(format), foo.what_time_is_it.strftime(format)
  end
end
