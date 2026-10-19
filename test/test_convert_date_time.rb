# frozen_string_literal: true

require_relative 'test_helper'

class TestConvertDateTime < Minitest::Test
  include ClassBuilder

  def setup
    @obj = build_class { cprop :happened_at, DateTime }.new
  end

  def test_convert_string_as_date_time
    @obj.happened_at = '2025-03-24T10:20:30+01:00'

    assert_equal DateTime.new(2025, 3, 24, 10, 20, 30, '+01:00'), @obj.happened_at
  end

  def test_convert_array_as_date_time
    @obj.happened_at = [2025, 3, 24, 10, 20, 30]

    assert_equal DateTime.new(2025, 3, 24, 10, 20, 30), @obj.happened_at
  end

  def test_convert_time_as_date_time
    time = Time.at(1_742_808_030)
    @obj.happened_at = time

    assert_equal time.to_datetime, @obj.happened_at
  end

  # Used to call Time.zone, which only exists with ActiveSupport.
  def test_convert_integer_as_date_time
    @obj.happened_at = 1_742_808_030

    assert_kind_of DateTime, @obj.happened_at
    assert_equal 1_742_808_030, @obj.happened_at.to_time.to_i
  end
end
