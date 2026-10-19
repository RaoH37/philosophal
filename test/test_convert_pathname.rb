# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertPathname < Minitest::Test
  include ClassBuilder

  def test_convert_string_as_pathname
    obj = build_class { cprop :path, Pathname }.new
    obj.path = '/tmp/philosophal'

    assert_equal Pathname.new('/tmp/philosophal'), obj.path
  end
end
