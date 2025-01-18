# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertFloat < Minitest::Test
  def test_convert_string_as_float
    foo = Person.new
    foo.size = '12345'

    assert_in_delta(12_345.0, foo.size)
  end

  def test_convert_integer_as_float
    foo = Person.new
    foo.size = 12_345

    assert_in_delta(12_345.0, foo.size)
  end
end
