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

  def test_type_matching_rejects_nil_and_false
    type = Philosophal::Types::ArrayOfType.instance(String)

    refute_operator type, :===, ['a', nil]
    refute_operator type, :===, ['a', false]
  end

  def test_convert_does_not_modify_given_array
    obj = build_class { cprop :ids, _ArrayOf(Integer) }.new
    source = %w[1 2]
    obj.ids = source

    assert_equal [1, 2], obj.ids
    assert_equal %w[1 2], source
  end

  def test_different_instances_for_different_subtypes
    refute_same Philosophal::Types::ArrayOfType.instance(String),
                Philosophal::Types::ArrayOfType.instance(Integer)
  end

  def test_instance_is_frozen
    assert_predicate Philosophal::Types::ArrayOfType.instance(String), :frozen?
  end

  def test_same_instance_for_same_subtype
    assert_same Philosophal::Types::ArrayOfType.instance(String),
                Philosophal::Types::ArrayOfType.instance(String)
  end
end
