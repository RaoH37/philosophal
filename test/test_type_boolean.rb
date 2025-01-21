# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeBoolean < Minitest::Test
  def test_accept_boolean
    foo = Person.new
    foo.is_male = true

    assert foo.is_male
  end

  def test_convert_boolean_from_integer_true
    foo = Person.new
    foo.is_female = 1

    assert foo.is_female
  end
end
