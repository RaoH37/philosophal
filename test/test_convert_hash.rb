# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertHash < Minitest::Test
  include ClassBuilder

  def setup
    @obj = build_class { cprop :options, Hash }.new
  end

  def test_keep_hash
    @obj.options = { a: 1 }

    assert_equal({ a: 1 }, @obj.options)
  end

  def test_convert_array_of_pairs_as_hash
    @obj.options = [[:a, 1], [:b, 2]]

    assert_equal({ a: 1, b: 2 }, @obj.options)
  end

  def test_raise_when_not_convertible
    assert_raises(Philosophal::TypeError) { @obj.options = 12 }
  end
end
