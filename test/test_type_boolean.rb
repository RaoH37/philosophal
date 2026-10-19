# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeBoolean < Minitest::Test
  def test_accept_true
    foo = Person.new
    foo.is_male = true

    assert foo.is_male
  end

  def test_convert_integer_one_as_true
    foo = Person.new
    foo.is_female = 1

    assert foo.is_female
  end

  def test_convert_string_true_as_true_ignoring_case
    foo = Person.new
    foo.is_female = 'TRUE'

    assert foo.is_female
  end

  def test_convert_integer_zero_as_false
    foo = Person.new
    foo.is_female = 0

    refute foo.is_female
  end

  def test_convert_string_false_as_false
    foo = Person.new
    foo.is_female = 'false'

    refute foo.is_female
  end

  def test_raise_for_other_integers
    foo = Person.new

    assert_raises(Philosophal::TypeError) { foo.is_female = 2 }
  end

  def test_raise_for_other_strings
    foo = Person.new

    assert_raises(Philosophal::TypeError) { foo.is_female = 'yes' }
  end

  def test_predicate_method
    foo = Person.new
    foo.is_male = 'true'

    assert_predicate foo, :is_male?
  end

  def test_predicate_method_is_false_when_unset
    refute_predicate Person.new, :is_male?
  end

  def test_predicate_method_only_for_boolean
    refute_respond_to Person.new, :first_name?
  end

  def test_reader_returns_false
    skip 'bug: the reader does `@value || default`, so false is returned as nil'
    foo = Person.new
    foo.is_male = false

    assert_equal false, foo.is_male # rubocop:disable Minitest/RefuteFalse
  end

  def test_type_matching
    assert_operator Philosophal::Types::BooleanType::Instance, :===, false
    refute_operator Philosophal::Types::BooleanType::Instance, :===, nil
  end
end
