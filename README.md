# New Relic

## Usage
Include either or both recipes, `infrastructure` or `application`, to the run_list for a
given node. You can disable installation by setting either install attribute to
`false`.

## Attributes
* `node['newrelic']['license']` = Your license key, not set by default
* `node['newrelic']['infrastructure']['install']` = `true` by default. Allows system
  monitoring to be installed.
* `node['newrelic']['php']['install']` = `true` by default. Allows application
  monitoring to be installed.
* `node['newrelic']['php']['enabled']` = `true` by default. Enables the application
  daemon to run.
* `node['newrelic']['php']['appname']` = The name of the New Relic application.
  Not set by default.

## Tests
There are kitchen tests.

```sh
$ kitchen list

$ kitchen test
```
