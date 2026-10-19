# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertErrors < Minitest::Test
  include ClassBuilder

  def test_raise_when_value_has_no_conversion_method
    obj = build_class { cprop :age, Integer }.new

    assert_raises(Philosophal::TypeError) { obj.age = Object.new }
  end

  def test_raise_for_unsupported_type
    obj = build_class { cprop :pattern, Regexp }.new

    assert_raises(Philosophal::TypeError) { obj.pattern = 'a+' }
  end

  def test_accept_value_of_unsupported_type
    obj = build_class { cprop :pattern, Regexp }.new
    obj.pattern = /a+/

    assert_equal(/a+/, obj.pattern)
  end

  def test_type_error_is_a_ruby_type_error
    assert_operator Philosophal::TypeError, :<, ::TypeError
  end

  def test_backtrace_starts_at_the_setter_call
    obj = build_class { cprop :age, Integer }.new
    error = assert_raises(Philosophal::TypeError) { obj.age = Object.new }

    refute(error.backtrace.any? { |line| line.include?('lib/philosophal/convertor.rb') })
    assert(error.backtrace.any? { |line| line.start_with?("#{__FILE__}:") })
  end
end
