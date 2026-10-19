# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertArray < Minitest::Test
  include ClassBuilder

  def setup
    @obj = build_class { cprop :items, Array }.new
  end

  def test_keep_array
    @obj.items = [1, 2]

    assert_equal [1, 2], @obj.items
  end

  def test_convert_hash_as_array
    @obj.items = { a: 1 }

    assert_equal [[:a, 1]], @obj.items
  end

  def test_wrap_object_without_to_a
    @obj.items = 42

    assert_equal [42], @obj.items
  end
end
