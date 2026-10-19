# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeAny < Minitest::Test
  def test_keep_any_value_unchanged
    value = Object.new
    foo = Person.new
    foo.any = value

    assert_same value, foo.any
  end

  def test_keep_string_unchanged
    foo = Person.new
    foo.any = 'foo'

    assert_equal 'foo', foo.any
  end

  def test_type_matches_everything
    assert_operator Philosophal::Types::AnyType::Instance, :===, nil
  end
end
