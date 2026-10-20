# frozen_string_literal: true

require_relative 'test_helper'

class TestSchema < Minitest::Test
  include ClassBuilder

  def setup
    @schema = Person.philosophal_properties
  end

  def test_access_property_by_name
    property = @schema[:first_name]

    assert_kind_of Philosophal::Property, property
    assert_equal String, property.type
  end

  def test_unknown_property
    assert_nil @schema[:unknown]
  end

  def test_immutables
    assert_equal %i[eyes_color], @schema.immutables.keys
  end

  def test_mutables
    assert_includes @schema.mutables.keys, :first_name
    refute_includes @schema.mutables.keys, :eyes_color
  end

  def test_json_names
    assert_equal :first_name, @schema.json_names_h[:FirstName]
    assert_equal :email, @schema.json_names_h[:email]
  end

  def test_each_yields_properties_in_declaration_order
    assert_equal @schema.properties_index.values, @schema.to_a
  end

  def test_each_returns_the_schema
    assert_same(@schema, @schema.each { nil })
  end

  def test_each_without_block_returns_a_sized_enumerator
    enumerator = @schema.each

    assert_kind_of Enumerator, enumerator
    assert_equal @schema.keys.size, enumerator.size
  end

  def test_enumerable_methods
    assert_equal @schema.keys, @schema.map(&:name)
    assert_equal %i[eyes_color], @schema.select(&:immutable).map(&:name)
    assert_equal(@schema[:age], @schema.find { |property| property.type == Integer })
  end

  def test_dup_has_its_own_index
    copy = @schema.dup
    copy << Philosophal::Property.new(name: :extra, type: String, default: nil, transform: nil,
                                      immutable: false, description: nil, json: false, override: true)

    assert_includes copy.keys, :extra
    refute_includes @schema.keys, :extra
  end

  def test_caches_are_refreshed_when_a_property_is_added
    klass = build_class { cprop :name, String, json: 'Name' }
    klass.philosophal_properties.json_names_h
    klass.cprop :nick, String, json: 'Nick'

    assert_equal :nick, klass.philosophal_properties.json_names_h[:Nick]
  end

  def test_subclass_caches_include_its_own_properties
    parent = build_class { cprop :name, String, immutable: true }
    parent.philosophal_properties.immutables
    child = Class.new(parent) { cprop :code, String, immutable: true }

    assert_equal %i[name code], child.philosophal_properties.immutables.keys
    assert_equal %i[name], parent.philosophal_properties.immutables.keys
  end
end
