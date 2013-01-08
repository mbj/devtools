devtools
========

[![Build Status](https://secure.travis-ci.org/datamapper/devtools.png?branch=master)](http://travis-ci.org/datamapper/devtools)
[![Dependency Status](https://gemnasium.com/datamapper/devtools.png)](https://gemnasium.com/datamapper/devtools)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/datamapper/devtools)

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

Create a ``Rakefile`` in project root with the following contents:

```ruby
require 'devtools'
Devtools.init
```

After ``bundle update`` run:

```
bundle exec rake devtools:prepare
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
Now you have access to the dm-2 metrics rake tasks.

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

Copyright (c) 2012 Markus Schirp

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
