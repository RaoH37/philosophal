# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeArrayOf < Minitest::Test
  def test_accept_array_of
    foo = Person.new
    foo.sports = %w[football karaté tv]

    assert_kind_of Array, foo.sports
  end

  def test_transform_array_of
    foo = Person.new
    foo.sports = %w[football karaté tv]

    assert_equal %w[FOOTBALL KARATÉ TV], foo.sports
  end

  def test_convert_array_of
    foo = Person.new
    foo.sports = ['football', 'karaté', 'tv', 12_345]

    assert_equal %w[FOOTBALL KARATÉ TV 12345], foo.sports
  end
end
