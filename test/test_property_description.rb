# frozen_string_literal: true

require_relative 'test_helper'

class TestPropertyDescription < Minitest::Test
  def test_description_method_present
    person = Person.new

    assert_respond_to person, :first_name_description
  end

  def test_description_method_not_present
    person = Person.new

    refute_respond_to person, :last_name_description
  end

  def test_description_equal
    person = Person.new

    assert_equal 'description of my first name property', person.first_name_description
  end

  def test_cprop_descriptions
    assert_kind_of Hash, Person.cprop_descriptions
    refute_nil Person.cprop_descriptions[:first_name]
  end
end
