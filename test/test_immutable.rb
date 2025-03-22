# frozen_string_literal: true

require_relative 'test_helper'

class TestImmutable < Minitest::Test
  def test_not_set
    foo = Person.new
    foo.eyes_color = 'blue'

    assert_predicate foo.eyes_color, :frozen?
  end

  def test_raise
    foo = Person.new
    foo.eyes_color = 'blue'

    assert_raises FrozenError do
      foo.eyes_color = 'green'
    end
  end
end
