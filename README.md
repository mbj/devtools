# develry

[![Build Status](https://secure.travis-ci.org/rom-rb/develry.png?branch=master)](http://travis-ci.org/rom-rb/develry)
[![Dependency Status](https://gemnasium.com/rom-rb/develry.png)](https://gemnasium.com/rom-rb/develry)
[![Code Climate](https://codeclimate.com/github/datamapper/develry.png)](https://codeclimate.com/github/datamapper/develry)
<!-- [![Code Climate](https://codeclimate.com/github/rom-rb/develry.png)](https://codeclimate.com/github/rom-rb/develry) -->

Metagem to assist [ROM](https://github.com/rom-rb)-style development.
Used to centralize metric setup and development gem dependencies.

## Installation

The installation looks stupid because Gemfiles are not nestable (A Gemfile cannot
include another Gemfile from a remote repository). Because of this we use an
updatable local copy of the shared parts.

Add the git source to your Gemfile's development section:

```ruby
group :development, :test do
  gem 'develry', git: 'https://github.com/rom-rb/develry.git'
end
```

To initialize develry in a project run the following command:

```ruby
bundle install
bundle exec develry init
```

This will *change your Gemfile and Rakefile* and add config files. Make sure to
review the diff and don't freak out :wink:

## Updating

Later on if you want to update to the latest develry just run:

```
bundle update develry
bundle exec develry sync
bundle install
```

## RSpec support

If you're using RSpec and want to have access to our common setup just adjust
`spec/spec_helper.rb` to include

```ruby
require 'develry/spec_helper'
```

## Credits

The whole [ROM](https://github.com/rom-rb) team that created and maintained all
these tasks before they were centralized here.

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## License

See `LICENSE` file.
