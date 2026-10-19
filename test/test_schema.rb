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
