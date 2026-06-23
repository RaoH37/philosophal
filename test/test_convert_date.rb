# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertDate < Minitest::Test
  def test_convert_string_as_date
    today = Date.today
    today_str = today.strftime('%Y-%m-%d')

    foo = Person.new
    foo.birthday = today_str

    assert_equal today, foo.birthday
  end

  def test_convert_array_as_date
    today = Date.today
    array = [today.year, today.month, today.day]

    foo = Person.new
    foo.birthday = array

    assert_equal today, foo.birthday
  end

  def test_convert_integer_as_date
    today = Date.today
    int = today.to_time.to_i

    foo = Person.new
    foo.birthday = int

    assert_equal today, foo.birthday
  end
end
