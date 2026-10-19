# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertDate < Minitest::Test
  DATE = Date.new(1985, 4, 12)

  def test_keep_date
    foo = Person.new
    foo.birthday = DATE

    assert_equal DATE, foo.birthday
  end

  def test_convert_string_as_date
    foo = Person.new
    foo.birthday = '1985-04-12'

    assert_equal DATE, foo.birthday
  end

  def test_convert_array_as_date
    foo = Person.new
    foo.birthday = [1985, 4, 12]

    assert_equal DATE, foo.birthday
  end

  def test_convert_integer_as_date
    foo = Person.new
    foo.birthday = DATE.to_time.to_i

    assert_equal DATE, foo.birthday
  end

  def test_convert_time_as_date
    foo = Person.new
    foo.birthday = Time.new(1985, 4, 12, 15, 30)

    assert_equal DATE, foo.birthday
  end

  def test_raise_when_not_convertible
    foo = Person.new

    assert_raises(Philosophal::TypeError) { foo.birthday = Object.new }
  end
end
