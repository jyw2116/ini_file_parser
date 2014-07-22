## Parser Exercise

### Usage

``$ rspec --format doc --color``

```
2147483648
"hello there, ftp uploading"
["array", "of", "values"]
nil
false
"/etc/var/uploads"
{:name=>"hello there, ftp uploading",
 :path=>"/etc/var/uploads",
 :enabled=>false}

StructHash
  returns nil if the key does not exist

Parser
  parses integers
  parses strings in quotes
  parses arrays
  parses booleans
  returns the path for a given hash[:key]
  returns a symbolized hash for a section with overrides
  returns the path for the last section defined with overrides
  should not return the non-existing values

Finished in 0.00641 seconds
9 examples, 0 failures
```
