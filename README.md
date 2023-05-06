# Restiny

This is a very early version of what will hopefully be a somewhat comprehensive and useful gem to interact with Bungie's Destiny 2 API. It's currently somewhat useable! Contributions are very welcome!

Eyes up, Ruby developer!

## Installation

Install the gem by either adding it to your Gemfile...

```ruby
gem 'restiny'
```

...and installing it via Bundler:

```ruby
bundle install
````

Or, just install it directly via Rubygems:

```ruby
gem install restiny
```

## Usage

You'll first want to include the gem in your code:

```ruby
require 'restiny'
```

Next, you'll need to tell Restiny your Bungie API key - you can [create and manage your own here](https://www.bungie.net/en/Application "The Bungie developer app portal."). Once you've got your key, pass it to the gem:

```ruby
Restiny.api_key = 'MY-API-KEY'
```

And away you go! I'll add more details soon, but the code is hopefully obvious enough to muddle through things yourself for now.






