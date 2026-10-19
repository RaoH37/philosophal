# frozen_string_literal: true

require_relative 'test_helper'

class TestSchema < Minitest::Test
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
end
