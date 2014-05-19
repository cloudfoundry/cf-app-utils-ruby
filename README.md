# cf-app-utils

Helper methods for apps running on Cloud Foundry.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cf-app-utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cf-app-utils

## Usage

Require and use the gem in your application:

```ruby
require 'cf-app-utils'
```

### CF::App::Credentials.find\_by\_service\_*

Returns the credentials hash for a given service that you have bound to
your application.

```ruby
# Get credentials for the service with the given name
CF::App::Credentials.find_by_service_name('master-db')

# Get credentials for the first service with the given tag
CF::App::Credentials.find_by_service_tag('relational')

# Get credentials for the first service with the given label
CF::App::Credentials.find_by_service_label('cleardb')

# Get credentials for all services that match all of the given tags
CF::App::Credentials.find_all_by_all_service_tags(['cleardb', 'relational'])
```
