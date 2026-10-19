# frozen_string_literal: true

require_relative 'test_helper'

class TestJson < Minitest::Test
  def setup
    @person = Person.new
    @person.first_name = 'Maxime'
    @person.last_name = 'Désécot'
    @person.email = 'Maxime.Desecot@GMAIL.com'
  end

  def test_generated_json_with_converted_key
    hash = JSON.parse(@person.to_json, symbolize_names: true)

    assert_equal 'Maxime', hash[:FirstName]
    assert_equal 'Désécot', hash[:LastName]
  end

  def test_generated_json_with_property_name
    hash = JSON.parse(@person.to_json, symbolize_names: true)

    assert_equal 'maxime.desecot@gmail.com', hash[:email]
  end

  def test_json_hash_only_contains_json_properties
    keys = @person.to_json_hash.keys

    assert_includes keys, :age
    refute_includes keys, :birthday
    refute_includes keys, :first_name
  end

  def test_json_hash_contains_default_values
    assert_equal 'developer', @person.to_json_hash[:job]
  end

  def test_json_from_array
    array = JSON.parse([@person].to_json)

    assert_equal 'Maxime', array.first['FirstName']
  end

  def test_load_json_with_key_conversion
    json = { FirstName: 'Maxime', LastName: 'Désécot' }.to_json
    person = Person.json.load(json)

    assert_equal 'Maxime', person.first_name
    assert_equal 'Désécot', person.last_name
  end

  def test_round_trip
    @person.age = 40
    @person.size = 1.82
    @person.is_male = true
    @person.is_female = true
    @person.eyes_color = 'blue'
    person = Person.json.load(@person.to_json)

    assert_equal @person.to_json_hash, person.to_json_hash
  end

  def test_round_trip_with_unset_values
    skip 'bug: unset values are exported as null, and null cannot be converted back (e.g. to a boolean)'
    person = Person.json.load(@person.to_json)

    assert_equal @person.to_json_hash, person.to_json_hash
  end
end
