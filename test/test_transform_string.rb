# frozen_string_literal: true

require_relative 'test_helper'

class TestTransformString < Minitest::Test
  def test_transform_string_to_downcase
    str = 'Maxime.DESECOT@Gmail.Com'
    foo = Person.new
    foo.email = str

    assert_equal str.downcase, foo.email
  end
end
