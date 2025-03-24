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
  cprop :is_male, _Boolean
  cprop :is_female, _Boolean
  cprop :eyes_color, String, immutable: true
  cprop :sports, _ArrayOf(String), transform: ->(x) { x.map(&:upcase) }
  cprop :priorities, _HashOf(Symbol, String)
  cprop :any, _Any
end
