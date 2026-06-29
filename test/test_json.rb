# frozen_string_literal: true

require_relative 'test_helper'

class TestJson < Minitest::Test
  def test_generated_json_with_converted_key
    person = Person.new
    person.first_name = 'Maxime'
    person.last_name = 'Désécot'
    person.email = 'Maxime.Desecot@GMAIL.com'

    json = person.to_json
    hash = JSON.parse(json, symbolize_names: true)

    assert hash[:FirstName]
    assert hash[:LastName]
  end

  def test_load_json_with_key_conversion
    hash = {
      FirstName: 'Maxime',
      LastName: 'Désécot',
      email: 'Maxime.Desecot@GMAIL.com'
    }

    json = hash.to_json

    person = Person.json.load(json)

    assert_equal hash[:FirstName], person.first_name
    assert_equal hash[:LastName], person.last_name
  end
end
