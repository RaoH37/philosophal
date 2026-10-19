# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertSymbol < Minitest::Test
  include ClassBuilder

  def setup
    @obj = build_class { cprop :status, Symbol }.new
  end

  def test_convert_string_as_symbol
    @obj.status = 'active'

    assert_equal :active, @obj.status
  end

  def test_keep_symbol
    @obj.status = :active

    assert_equal :active, @obj.status
  end

  def test_raise_when_not_convertible
    assert_raises(Philosophal::TypeError) { @obj.status = 12 }
  end
end
