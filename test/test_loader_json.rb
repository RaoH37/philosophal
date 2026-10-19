# frozen_string_literal: true

require_relative 'test_helper'
require 'tempfile'

class TestLoaderJson < Minitest::Test
  HASH = {
    first_name: 'Maxime',
    last_name: 'Désécot',
    email: 'Maxime.Desecot@GMAIL.com'
  }.freeze

  def assert_person(person)
    assert_equal 'Maxime', person.first_name
    assert_equal 'Désécot', person.last_name
    assert_equal 'maxime.desecot@gmail.com', person.email
  end

  def test_from_hash
    assert_person Person.json.load(HASH)
  end

  def test_from_hash_with_json_names
    person = Person.json.load({ FirstName: 'Maxime' })

    assert_equal 'Maxime', person.first_name
  end

  def test_from_hash_converts_values
    person = Person.json.load({ age: '40' })

    assert_equal 40, person.age
  end

  def test_from_hash_ignores_unknown_keys
    person = Person.json.load({ first_name: 'Maxime', unknown: 'value' })

    assert_equal 'Maxime', person.first_name
  end

  def test_from_hash_with_null_values
    person = Person.json.load({ age: nil, is_male: nil, job: nil })

    assert_nil person.age
    assert_nil person.is_male
    assert_equal 'developer', person.job
  end

  def test_from_array
    people = Person.json.load(Array.new(3) { HASH })

    assert_equal 3, people.length
    people.each { |person| assert_person person }
  end

  def test_from_str
    assert_person Person.json.load(HASH.to_json)
  end

  def test_from_array_str
    people = Person.json.load(Array.new(3) { HASH }.to_json)

    assert_equal 3, people.length
    people.each { |person| assert_person person }
  end

  def test_from_path
    Tempfile.create(['person', '.json']) do |file|
      file.write(HASH.to_json)
      file.flush

      assert_person Person.json.load(file.path)
    end
  end

  def test_raise_for_missing_file
    error = assert_raises(Philosophal::Loaders::LoadError) { Person.json.load('/no/such/file.json') }

    assert_includes error.message, '/no/such/file.json'
  end

  def test_raise_for_invalid_parameter
    assert_raises(Philosophal::Loaders::LoadError) { Person.json.load(42) }
  end

  def test_raise_for_array_with_non_hash
    assert_raises(Philosophal::Loaders::LoadError) { Person.json.load([HASH, 'Maxime']) }
  end

  def test_loader_is_memoized
    assert_same Person.json, Person.json
  end

  def test_input_hash_is_not_modified
    hash = HASH.dup
    Person.json.load(hash)

    assert_equal HASH, hash
  end

  def test_input_array_is_not_modified
    array = [HASH.dup]
    Person.json.load(array)

    assert_equal [HASH], array
  end
end
