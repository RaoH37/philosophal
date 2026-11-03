# frozen_string_literal: true

require_relative 'test_helper'

class TestProperties < Minitest::Test
  include ClassBuilder

  def test_respond_to_cprop
    assert_respond_to Person, :cprop
  end

  def test_respond_to_writer
    assert_respond_to Person.new, :first_name=
  end

  def test_respond_to_reader
    assert_respond_to Person.new, :first_name
  end

  def test_properties_are_listed_in_declaration_order
    assert_equal %i[first_name last_name age], Person.philosophal_properties.keys.first(3)
  end

  def test_inheritance
    assert_respond_to SuperHero.new, :first_name
    assert_respond_to SuperHero.new, :civil_name
  end

  def test_subclass_inherits_parent_properties
    assert_includes SuperHero.philosophal_properties.keys, :first_name
  end

  def test_subclass_properties_do_not_leak_into_parent
    refute_includes Person.philosophal_properties.keys, :civil_name
  end

  def test_parent_inspect_after_subclass_declares_property
    parent = build_class { cprop :name, String }
    Class.new(parent) { cprop :power, String }

    assert_equal({ name: nil }, parent.new.cprop_inspect_map)
  end

  def test_method_not_override
    assert_equal 'Clark Kent', SuperHero.new.civil_name
  end

  def test_inherited_method_overridden_by_default
    parent = Class.new { def name = 'inherited' }
    klass = build_class(parent) { cprop :name, String, default: 'property' }

    assert_equal 'property', klass.new.name
  end

  def test_inherited_method_kept_without_override
    parent = Class.new { def name = 'inherited' }
    klass = build_class(parent) { cprop :name, String, default: 'property', override: false }

    assert_equal 'inherited', klass.new.name
  end

  def test_method_of_same_class_overridden_by_default
    klass = build_class do
      define_method(:name) { 'original' }
      cprop :name, String, default: 'property'
    end

    assert_equal 'property', klass.new.name
  end

  def test_writer_of_same_class_overridden_by_default
    klass = build_class do
      attr_writer :age

      cprop :age, Integer
    end
    obj = klass.new
    obj.age = '40'

    assert_equal 40, obj.age
  end

  def test_private_method_of_same_class_overridden_by_default
    klass = build_class do
      private define_method(:name) { 'original' }
      cprop :name, String, default: 'property'
    end

    assert_equal 'property', klass.new.name
  end

  def test_method_of_same_class_kept_without_override
    klass = build_class do
      define_method(:name) { 'original' }
      cprop :name, String, default: 'property', override: false
    end

    assert_equal 'original', klass.new.name
  end

  def test_method_defined_after_cprop_wins
    klass = build_class do
      cprop :name, String
      define_method(:name) { 'custom' }
    end

    assert_equal 'custom', klass.new.name
  end
end
