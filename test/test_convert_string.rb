# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertString < Minitest::Test
  def test_keep_string
    foo = Person.new
    foo.first_name = 'Maxime'

    assert_equal 'Maxime', foo.first_name
  end

  def test_convert_integer_as_string
    foo = Person.new
    foo.first_name = 12_345

    assert_equal '12345', foo.first_name
  end

  def test_convert_float_as_string
    foo = Person.new
    foo.first_name = 12.345

    assert_equal '12.345', foo.first_name
  end

  def test_convert_symbol_as_string
    foo = Person.new
    foo.first_name = :maxime

    assert_equal 'maxime', foo.first_name
  end

  def test_convert_time_as_string
    now = Time.now
    foo = Person.new
    foo.first_name = now

    assert_equal now.to_s, foo.first_name
  end
end
