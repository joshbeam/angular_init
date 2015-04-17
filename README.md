
# ngi 0.3.1

Check out the [website][website].

## Table of Contents

- [Quick Start][quick-start]
- [Example][example]
- [Features][features]
- [Installation][install]
- [Tutorials][tutorials]
- [Contributing][contributing]
- [Info][info]

## Quick Start

angular_init (called `ngi`) creates AngularJS templates for you from the command line **so you don't have to type the same starting code over and over again**. It's a tool with just one purpose, so it's small and fast.

### Get up and running in seconds

[![Gem Version](https://badge.fury.io/rb/ngi.svg)](http://badge.fury.io/rb/ngi)

```shell
$ gem install ngi
$ cd ~/MyAwesomeApp # => go to your app
$ ngi controller # => create a new AngularJS controller
```

## Example

### In your shell

![Example](https://github.com/joshbeam/angular_init/blob/master/ngi_example.gif "Example")

### Output (new boilerplate code)

```javascript
// ~/MyAwesomeApp/myAwesome.controller.js

;(function(app) {

  'use strict';

  app.controller('MyAwesomeController',MyAwesomeController);

  MyAwesomeController.$inject = ['$route', '$scope'];

  function MyAwesomeController($route, $scope) {
  
  }

})(angular.module('myModule'));
```

By the way, the output of this little tool is meant to follow [John Papa's AngularJS Style Guide][style-guide].

## Features

### What's new in 0.3.x?

- You can now use **custom templates** ([tutorial][tutorial])

*Have an idea for a feature? Email frontendcollisionblog@gmail.com! Just write: "Hey, I think it would be awesome if you included ____ in ngi because ____."*

- Has **default templates** to create components for you (directives, controllers, etc.) in ECMAScript5 and CoffeeScript (type `ngi -h` to see all the available components). By the way, the default templates follow [John Papa's AngularJS Style Guide][style-guide].
- Supports **custom templates** (see the [tutorial][tutorial] for that)

## Installation

You need [Ruby 2.1.0][ruby] and [RubyGems][rubygems] (optional [Bundler][bundler])

Add this line to your application's Gemfile:

    gem 'ngi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ngi

## Tutorials

- [See all available commands/components][commands]
- [How to use custom templates instead of the default ones][tutorial]

## Contributing

- Contribute just like you would any other GitHub project (fork and submit a pull request; check out [GitHub's guide for that][contributing-guide])
- Or, email frontendcollisionblog@gmail.com if you have an awesome idea for a feature!

## Info

### Requirements

Only tested with Ruby 2.1 on Mac OSX Mavericks. Compatibility with previous versions of Ruby cannot be guaranteed.

### Disclaimer

`angular_init` and `ngi` and the author (Joshua Beam) are not directly associated with <a href="http://angularjs.org">AngularJS</a>.

**Copyright &copy; 2015 Joshua Beam** &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a>

[MIT License][mit]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[website]: http://frontendcollisionblog.com/angular_init
[install]: #installation
[quick-start]: #quick-start
[example]: #example
[features]: #features
[tutorials]: #tutorials
[contributing]: #contributing
[contributing-guide]: https://guides.github.com/activities/contributing-to-open-source/#contributing
[info]: #info
[style-guide]: https://github.com/johnpapa/angular-styleguide
[rubygems]: https://rubygems.org/pages/download
[ruby]: https://www.ruby-lang.org/en/downloads/
[bundler]: http://bundler.io/
[tutorial]: https://github.com/joshbeam/angular_init/blob/master/TUTORIAL.md
[commands]: https://github.com/joshbeam/angular_init/blob/master/COMMANDS.md
[mit]: http://opensource.org/licenses/MIT