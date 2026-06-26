# frozen_string_literal: true

require_relative 'test_helper'

class TestLoaderJson < Minitest::Test
  def test_from_hash
    hash = {
      first_name: 'Maxime',
      last_name: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    foo = Person.json.load(hash)

    assert_equal hash[:first_name], foo.first_name
    assert_equal hash[:last_name], foo.last_name
    assert_equal hash[:email].downcase, foo.email
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
end
