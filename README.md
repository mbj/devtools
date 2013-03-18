devtools
========

[![Build Status](https://secure.travis-ci.org/datamapper/devtools.png?branch=master)](http://travis-ci.org/datamapper/devtools)
[![Dependency Status](https://gemnasium.com/datamapper/devtools.png)](https://gemnasium.com/datamapper/devtools)
[![Code Climate](https://codeclimate.com/github/datamapper/devtools.png)](https://codeclimate.com/github/datamapper/devtools)

Metagem to assist dm-2 style development.
Used to centralize metric setup and development gem dependencies.

Installation
------------

The installation looks stupid, but Gemfiles are not nestable. A Gemfile cannot include another Gemfile from
a remote repository. Because auf this we use a updatable local copy of the shared parts.

Add git source to your Gemfile like this:

```ruby
gem 'devtools', :git => 'https://github.com/datamapper/devtools.git'
```

Run:
```
bundle install
```

Create a `Rakefile` in project root with the following contents:

```ruby
require 'devtools'
Devtools.init_rake_tasks
```

After `bundle update` run:

```
bundle exec rake devtools:sync
```

And append the following line to Gemfile that pulls the devtools shared Gemfile
that is maintained in this repo

```ruby
eval File.read('Gemfile.devtools')
```

And run (again):
```
bundle install
```

Adjust `spec/spec_helper.rb` to include

```ruby
require 'devtools/spec_helper'
```

Now you have access to the dm-2 rake tasks, metrics, and spec helpers.

Credits
-------

The whole dm-2 team that created and maintained all these tasks before they were centralized here.

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
