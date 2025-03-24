# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeAny < Minitest::Test
  def test_accept_any_string
    foo = Person.new
    foo.any = 'foo'

    assert_kind_of String, foo.any
  end
end
