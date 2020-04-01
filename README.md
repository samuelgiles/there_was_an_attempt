![There was an attempt](https://user-images.githubusercontent.com/2643026/78128526-ff02ec80-740d-11ea-9226-40b15c437518.png)

# There was an attempt [![Gem Version](https://badge.fury.io/rb/there_was_an_attempt.svg)](https://badge.fury.io/rb/there_was_an_attempt) ![RSpec](https://github.com/samuelgiles/there_was_an_attempt/workflows/RSpec/badge.svg)

A small utility designed to be used alongside [Dry::Monads::Result](https://dry-rb.org/gems/dry-monads/) to repeatedly attempt an operation sleeping between failed attempts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'there_was_an_attempt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install there_was_an_attempt

## Usage

Without any arguments given to the constructor a basic exponential backoff interval (2, 4, 8, 16 to be precise) is used with `sleep` being used to wait, as a nicety this is available as `.attempt`:

```ruby
# Shortcut for: ThereWasAnAttempt.new.attempt
ThereWasAnAttempt.attempt do
    Dry::Monads::Success(true)
end
```

You can specify your backoff intervals manually:

```ruby
ThereWasAnAttempt.new([1,2,4,8]).attempt do
    Dry::Monads::Success(true)
end
```

And you can also optionally specify your own "wait" logic:

```ruby
ThereWasAnAttempt.new([1,2,4,8], ->(seconds) { puts seconds; sleep seconds }).attempt do
    Dry::Monads::Success(true)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/samuelgiles/there_was_an_attempt.
