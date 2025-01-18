# frozen_string_literal: true

lib = File.expand_path('../lib/', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'philosophal'

require 'minitest/autorun'

require 'date'
require 'time'

class Person
  extend Philosophal::Properties

  cprop :first_name, String
  cprop :last_name, String
  cprop :age, Integer
  cprop :size, Float
  cprop :birthday, Date
  cprop :job, String, default: 'developer'
  cprop :what_time_is_it, Time, default: -> { Time.now }
  cprop :email, String, transform: :downcase
  cprop :refs, Array, transform: ->(x) { x.map(&:upcase) }
end
