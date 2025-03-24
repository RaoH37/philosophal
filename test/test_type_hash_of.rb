# frozen_string_literal: true

require_relative 'test_helper'

class TestTypeHashOf < Minitest::Test
  def test_accept_hash_of
    foo = Person.new
    foo.priorities = { 'p1' => 'sleep', 'p2' => 'heat', 'p3' => 12_345 }

    assert_kind_of Hash, foo.priorities
  end

  def test_convert_hash_of
    foo = Person.new
    foo.priorities = { 'p1' => 'sleep', 'p2' => 'heat', 'p3' => 12_345 }

    h_test = { p1: 'sleep', p2: 'heat', p3: '12345' }

    assert_equal h_test, foo.priorities
  end
end
