# frozen_string_literal: true

require_relative 'test_helper'

class TestTransformArray < Minitest::Test
  def test_transform_array_to_upcase
    arr = %w[aaa bbb ccc]
    foo = Person.new
    foo.refs = arr

    assert_equal arr.map(&:upcase), foo.refs
  end
end
