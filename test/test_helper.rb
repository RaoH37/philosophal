# frozen_string_literal: true

lib = File.expand_path('../lib/', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'philosophal'

require 'minitest/autorun'

require 'date'
require 'time'

class Person
  extend Philosophal::Properties

  cprop :first_name, String, description: 'description of my first name property', json: 'FirstName'
  cprop :last_name, String, json: 'LastName'
  cprop :age, Integer, json: true
  cprop :size, Float, json: true
  cprop :birthday, Date
  cprop :job, String, default: 'developer', json: true
  cprop :what_time_is_it, Time, default: -> { Time.now }
  cprop :email, String, transform: :downcase, json: true
  cprop :refs, Array, transform: ->(x) { x.map(&:upcase) }
  cprop :is_male, _Boolean, json: true
  cprop :is_female, _Boolean, json: true
  cprop :eyes_color, String, immutable: true, json: true
  cprop :sports, _ArrayOf(String), transform: ->(x) { x.map(&:upcase) }
  cprop :priorities, _HashOf(Symbol, String)
  cprop :any, _Any
end
