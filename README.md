devtools
========

[![Build Status](https://secure.travis-ci.org/rom-rb/devtools.png?branch=master)](http://travis-ci.org/rom-rb/devtools)
[![Dependency Status](https://gemnasium.com/rom-rb/devtools.png)](https://gemnasium.com/rom-rb/devtools)
[![Code Climate](https://codeclimate.com/github/datamapper/devtools.png)](https://codeclimate.com/github/datamapper/devtools)
<!-- [![Code Climate](https://codeclimate.com/github/rom-rb/devtools.png)](https://codeclimate.com/github/rom-rb/devtools) -->

Metagem to assist [ROM](https://github.com/rom-rb) style development.
Used to centralize metric setup and development gem dependencies.

Installation
------------

The installation looks stupid because Gemfiles are not nestable (Gemfile cannot
include another Gemfile from a remote repository). Because of this we use an
updatable local copy of the shared parts.

Add the git source to your Gemfile's development section:

```ruby
group :development do
  gem 'devtools', :github => 'rom-rb/devtools'
end
```

Run:
```
bundle install
```

Create a `Rakefile` in the project root with the following contents:

```ruby
require 'devtools'
Devtools.init_rake_tasks
```

To copy `Gemfile.devtools` to your project, run the following commands:

```
bundle update
bundle exec rake devtools:sync
```

To allow bundler to pick up the dependencies, append the following
line to your Gemfile's development section:

```ruby
group :development do
  # ...
  eval File.read('Gemfile.devtools')
end
```

To make the devtools dependencies available to your project, run:

```
bundle install
```

Finally, adjust `spec/spec_helper.rb` to include

```ruby
require 'devtools/spec_helper'
```

Now you have access to the [ROM](https://github.com/rom-rb) rake tasks, metrics
and spec helpers.

Credits
-------

The whole [ROM](https://github.com/rom-rb) team that created and maintained all
these tasks before they were centralized here.

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

See `LICENSE` file.
