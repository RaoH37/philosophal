# frozen_string_literal: true

require_relative 'test_helper'

class TestProperties < Minitest::Test
  def test_respond_to_cprop
    assert_respond_to Person, :cprop
  end

  def test_respond_to_name_writer
    assert_respond_to Person.new, :'first_name='
  end

  def test_respond_to_name_reader
    assert_respond_to Person.new, :first_name
  end
end
