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
maxime.first_name = 'Maxime'
maxime.last_name = 'Désécot'
maxime.age = '40'
puts maxime.inspect
#<Person:0x00007da7088eed88 @first_name="maxime", @last_name="DÉSÉCOT", @age=40>
````

### Tracking changes

With `track_changes: true`, a property also gets `<name>_was`, the value before the last assignment,
and `<name>_changed?`, true when the last assignment changed the value.

```ruby
class Article
  extend Philosophal::Properties

  cprop :title, String, track_changes: true
end

article = Article.new
article.title_changed? # => false
article.title = 'Draft'
article.title_was      # => nil
article.title_changed? # => true
article.title = 'Final'
article.title_was      # => "Draft"
article.title = 'Final'
article.title_changed? # => false
```

`<name>_was` returns the stored value, without falling back to the default.
