# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeHashOf < Minitest::Test
  def test_accept_hash_of
    foo = Person.new
    foo.priorities = { p1: 'sleep' }

    assert_equal({ p1: 'sleep' }, foo.priorities)
  end

  def test_convert_hash_of
    foo = Person.new
    foo.priorities = { 'p1' => 'sleep', 'p2' => 'heat', 'p3' => 12_345 }

    assert_equal({ p1: 'sleep', p2: 'heat', p3: '12345' }, foo.priorities)
  end

  def test_convert_array_of_pairs
    foo = Person.new
    foo.priorities = [['p1', 1]]

    assert_equal({ p1: '1' }, foo.priorities)
  end

  def test_type_matching
    type = Philosophal::Types::HashOfType.instance(Symbol, String)

    assert_operator type, :===, { a: 'b' }
    refute_operator type, :===, { 'a' => 'b' }
    refute_operator type, :===, { a: 1 }
  end

  def test_different_instances_for_different_subtypes
    refute_same Philosophal::Types::HashOfType.instance(Symbol, String),
                Philosophal::Types::HashOfType.instance(String, Symbol)
  end

  def test_accept_anonymous_class
    klass = Class.new

    assert_operator Philosophal::Types::HashOfType.instance(Symbol, klass), :===, { a: klass.new }
  end

  def test_same_instance_for_same_subtypes
    assert_same Philosophal::Types::HashOfType.instance(Symbol, String),
                Philosophal::Types::HashOfType.instance(Symbol, String)
  end
end
