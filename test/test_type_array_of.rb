# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeArrayOf < Minitest::Test
  include ClassBuilder

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

  def test_wrap_single_value
    obj = build_class { cprop :ids, _ArrayOf(Integer) }.new
    obj.ids = '42'

    assert_equal [42], obj.ids
  end

  def test_type_matching
    type = Philosophal::Types::ArrayOfType.instance(String)

    assert_operator type, :===, %w[a b]
    refute_operator type, :===, ['a', 1]
    refute_operator type, :===, 'a'
  end

  def test_same_instance_for_same_subtype
    skip 'bug: Hash#fetch evaluates its default eagerly, so a new instance is always built'

    assert_same Philosophal::Types::ArrayOfType.instance(String),
                Philosophal::Types::ArrayOfType.instance(String)
  end
end
