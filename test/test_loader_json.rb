# frozen_string_literal: true

require_relative 'test_helper'

class TestLoaderJson < Minitest::Test
  def test_from_hash
    hash = {
      first_name: 'Maxime',
      last_name: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    foo = Person.json.load(hash.dup)

    assert_equal foo.first_name, hash[:first_name]
    assert_equal foo.last_name, hash[:last_name]
    assert_equal foo.email, hash[:email].downcase
  end

  def test_from_array
    hash = {
      first_name: 'Maxime',
      last_name: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    array = []

    10.times { array << hash.dup }

    foo = Person.json.load(array.dup)

    assert_kind_of Array, foo
    assert_equal 10, foo.length
  end

  def test_from_str
    hash = {
      first_name: 'Maxime',
      last_name: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    str = hash.to_json

    foo = Person.json.load(str)

    assert_equal hash[:first_name], foo.first_name
    assert_equal hash[:last_name], foo.last_name
    assert_equal hash[:email].downcase, foo.email
  end

  def test_from_array_str
    hash = {
      first_name: 'Maxime',
      last_name: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    array = []

    10.times { array << hash.dup }

    foo = Person.json.load(array.to_json)

    assert_kind_of Array, foo
    assert_equal 10, foo.length
  end
end
