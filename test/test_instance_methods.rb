# frozen_string_literal: true

require_relative 'test_helper'

class TestInstanceMethods < Minitest::Test
  def setup
    @person = Person.new
    @person.first_name = 'Maxime'
  end

  def test_cprop_with_class
    assert @person.cprop?(:first_name, String)
    refute @person.cprop?(:first_name, Integer)
  end

  def test_cprop_with_instance
    assert @person.cprop?('age', 40)
  end

  def test_cprop_unknown_property
    refute @person.cprop?(:unknown, String)
  end

  def test_cprop_inspect_map
    map = @person.cprop_inspect_map

    assert_equal 'Maxime', map[:first_name]
    assert_equal 'developer', map[:job]
  end

  def test_cprop_inspect
    inspect = @person.cprop_inspect

    assert inspect.start_with?('Person:0x')
    assert_includes inspect, 'first_name: "Maxime"'
    assert_includes inspect, 'last_name: nil'
  end

  def test_cprop_inspect_light_hides_empty_values
    @person.refs = []
    inspect = @person.cprop_inspect(true)

    assert_includes inspect, 'first_name: "Maxime"'
    refute_includes inspect, 'last_name'
    refute_includes inspect, 'refs'
  end
end
