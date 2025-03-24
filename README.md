# Philosophal

If you don't want to manage your parameters' conversation before valuing your objects' instance variables, **Philosophal** is the gem for you ;-)

## Installation

```bash
gem install philosophal
```

## Usage

````ruby
require 'philosophal'

class Person
  extend Philosophal::Properties

  cprop :first_name, String, transform: :downcase
  cprop :last_name, String, transform: :upcase
  cprop :age, Integer
end

maxime = Person.new
maxime.first_name = "Maxime"
maxime.last_name = "Désécot"
maxime.age = "40" 
puts maxime.inspect
#<Person:0x00007da7088eed88 @first_name="maxime", @last_name="DÉSÉCOT", @age=40>
````
