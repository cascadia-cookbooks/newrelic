# NewRelic

## Usage
Include either or both recipes, system or application, to the run_list for a given node.

## Attributes
* node['newrelic']['license'] = Your license key, not set by default
* node['newrelic']['system']['install'] = true by default. Allows system
  monitoring to be installed.
* node['newrelic']['php']['install'] = true by default. Allows application
  monitoring to be installed.
* node['newrelic']['php']['enabled'] = true by default. Enables the application
  daemon to run.

## Tests
There are kitchen tests.
