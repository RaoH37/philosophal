## [2.0.0] - 2026-11-03

- Add: new `track_changes:` option for `cprop`, which defines `prop_was` (the value at the last `changes_applied`) and `prop_changed?` (the value differs from it)
- Add: `changes_applied` records the current values of the tracked properties as the reference
- Add: `changed_properties` returns a hash of the tracked properties changed since the last `changes_applied`, with their new value
- Add: RBS type signatures (`sig/`), shipped with the gem
- Fix: **ArrayOf** and **HashOf** no longer accept `nil` or `false` entries of the wrong type without converting them
- Fix: converting to **ArrayOf** or **HashOf** no longer modifies the given array or hash
- Perf: the reader of a property without default is now a plain `attr_reader`
- Perf: writers, and readers falling back to their default, no longer look up their property in the schema
- Breaking: redeclaring in a subclass, with a default and `override: false`, a property no longer applies the subclass default or type (the parent methods are kept)
- Perf: fewer lookups and allocations when converting, loading JSON, `to_json_hash`, `changes_applied` and `changed_properties`
- Fix: `Properties::Schema` now defines `each`, so its Enumerable methods (`map`, `select`, `find`...) work and yield the properties

## [1.3.0] - 2026-10-19

- Breaking: minimum required Ruby version is now **3.3** (was 3.1)
- Breaking: assigning `nil` no longer converts it (e.g. to `0` or `""`); the property is reset and its reader returns the default value
- Fix: converting a Numeric to **DateTime** no longer requires ActiveSupport (`Time.zone`)
- Fix: properties declared in a subclass no longer leak into the parent class
- Fix: a property set to `false` is no longer replaced by its default value, and predicate methods (`prop?`) take the default into account
- Fix: **ArrayOf** and **HashOf** instances are now really shared for the same subtypes, and **HashOf** accepts anonymous classes
- Fix: descriptions are no longer evaluated as Ruby code (parentheses or `#{...}` in a description broke or ran code)
- Fix: `json.load` no longer modifies the given hash or array, and accepts frozen hashes
- Fix: `override: true` now also replaces a method defined in the class itself before `cprop`

## [1.0.0] - 2025-03-24

- Add: new type **ArrayOf** to convert sub items of an array
- Add: new type **HashOf** to convert keys and values of a hash
- Add: Do not duplicate **ArrayOf** instance for same subtype
- Add: Do not duplicate **HashOf** instance for same **key type** and **value type**
- Add: new type **AnyType**
