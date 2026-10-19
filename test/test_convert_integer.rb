# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertInteger < Minitest::Test
  def test_keep_integer
    foo = Person.new
    foo.age = 40

    assert_equal 40, foo.age
  end

  def test_convert_string_as_integer
    foo = Person.new
    foo.age = '12345'

    assert_equal 12_345, foo.age
  end

  def test_convert_float_as_integer_truncates
    foo = Person.new
    foo.age = 12.945

    assert_equal 12, foo.age
  end

  def test_convert_non_numeric_string_as_zero
    foo = Person.new
    foo.age = 'abc'

    assert_equal 0, foo.age
  end
end
