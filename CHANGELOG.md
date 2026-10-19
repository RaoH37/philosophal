## [1.3.0] - 2026-10-19

- Breaking: minimum required Ruby version is now **3.3** (was 3.1)
- Fix: converting a Numeric to **DateTime** no longer requires ActiveSupport (`Time.zone`)

## [1.0.0] - 2025-03-24

- Add: new type **ArrayOf** to convert sub items of an array
- Add: new type **HashOf** to convert keys and values of a hash
- Add: Do not duplicate **ArrayOf** instance for same subtype
- Add: Do not duplicate **HashOf** instance for same **key type** and **value type**
- Add: new type **AnyType**
