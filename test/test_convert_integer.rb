# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertInteger < Minitest::Test
  def test_convert_string_as_integer
    foo = Person.new
    foo.age = '12345'

    assert_equal 12_345, foo.age
  end

  def test_convert_float_as_integer
    foo = Person.new
    foo.age = 12.345

    assert_equal 12, foo.age
  end
end
