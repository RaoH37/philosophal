# frozen_string_literal: true

require_relative 'test_helper'

class TestGeneratedMethods < Minitest::Test
  include ClassBuilder

  def test_writer_uses_redeclared_property
    klass = build_class do
      cprop :count, String
      cprop :count, Integer
    end
    obj = klass.new
    obj.count = '42'

    assert_equal 42, obj.count
  end

  def test_writer_uses_subclass_property
    parent = build_class { cprop :count, String }
    klass = build_class(parent) { cprop :count, Integer }
    obj = klass.new
    obj.count = '42'

    assert_equal 42, obj.count
    assert_equal '42', parent.new.tap { |p| p.count = 42 }.count
  end

  def test_property_constant_is_private
    klass = build_class { cprop :name, String }

    assert_raises(NameError) { klass::PHILOSOPHAL_PROPERTY_name }
  end

  def test_reader_without_default_returns_nil
    obj = build_class { cprop :name, String }.new

    assert_nil obj.name
    obj.name = 'set'

    assert_equal 'set', obj.name
  end

  def test_reader_without_default_is_replaced_by_subclass_default
    parent = build_class { cprop :name, String }
    klass = build_class(parent) { cprop :name, String, default: 'child' }

    assert_equal 'child', klass.new.name
    assert_nil parent.new.name
  end
end
