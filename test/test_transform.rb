# frozen_string_literal: true

require_relative 'test_helper'

class TestTransform < Minitest::Test
  include ClassBuilder

  def test_transform_with_symbol
    obj = build_class { cprop :code, String, transform: :upcase }.new
    obj.code = 'abc'

    assert_equal 'ABC', obj.code
  end

  def test_transform_with_proc
    obj = build_class { cprop :code, String, transform: ->(value) { "#{value}!" } }.new
    obj.code = 'abc'

    assert_equal 'abc!', obj.code
  end

  def test_transform_after_conversion
    obj = build_class { cprop :code, String, transform: :upcase }.new
    obj.code = :abc

    assert_equal 'ABC', obj.code
  end

  # strip! returns nil when nothing changes: the value itself must be kept.
  def test_bang_method_keeps_value_when_unchanged
    obj = build_class { cprop :code, String, transform: :strip! }.new
    obj.code = +'abc'

    assert_equal 'abc', obj.code
  end

  def test_bang_method_modifies_value
    obj = build_class { cprop :code, String, transform: :strip! }.new
    obj.code = +'  abc  '

    assert_equal 'abc', obj.code
  end

  def test_no_transform_on_default
    obj = build_class { cprop :code, String, default: 'abc', transform: :upcase }.new

    assert_equal 'abc', obj.code
  end
end
