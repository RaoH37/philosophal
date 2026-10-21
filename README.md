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

With `track_changes: true`, a property also gets `<name>_was` and `<name>_changed?`.
Call `changes_applied` once the object is in a known state (built, loaded, saved...):
`<name>_was` returns the value at that moment, and `<name>_changed?` tells whether the value differs from it.

```ruby
class Article
  extend Philosophal::Properties

  cprop :title, String, track_changes: true
end

article = Article.new
article.title = 'Draft'
article.title_changed? # => true (no reference yet)
article.changes_applied
article.title_changed? # => false
article.title = 'Review'
article.title = 'Final'
article.title_was      # => "Draft"
article.title_changed? # => true
article.title = 'Draft'
article.title_changed? # => false
```

`changed_properties` returns the tracked properties that changed, with their new value:

```ruby
article.title = 'Final'
article.changed_properties # => { title: "Final" }
article.changes_applied
article.changed_properties # => {}
```

Before the first `changes_applied`, the reference is "never assigned": every assigned property is changed.
`<name>_was` returns the stored value, without falling back to the default.
`json.load` does not call `changes_applied`: call it on the loaded objects if they must start unchanged.
