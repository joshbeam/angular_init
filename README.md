
# ngi 0.3.0

## Quick Start

angular_init (short-name: ngi) creates AngularJS templates for you from the command line.

### Get up and running in seconds

[![Gem Version](https://badge.fury.io/rb/ngi.svg)](http://badge.fury.io/rb/ngi)

```shell
$ gem install ngi
$ cd ~/MyAwesomeApp # => go to your app
$ ngi controller # => creates a new AngularJS controller
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

- Has default templates to create components for you (directives, controllers, etc.) in ECMAScript5 and CoffeeScript (type `ngi -h` to see all the available components)
- Supports custom templates

## Tutorials

- Type `ngi -h` to see a list of all available components that can be created (directives, controllers, etc.)
- [How to use custom templates instead of the default ones][tutorial]

## Technical Information

**Language** Ruby

**Requirements** Only tested with `ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-darwin13.0]`. Compatibility with previous versions of Ruby cannot be guaranteed.

### Disclaimer

`angular_init` and `ngi` and the author (Joshua Beam) are not directly associated with <a href="http://angularjs.org">AngularJS</a>.

**Copyright (c) 2015 Joshua Beam** &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a> (MIT License)

[install]: #installation-in-1-step
[sample-usage]: #sample-usage
[features]: #features
[commands]: #commands
[faq]: #faq
[tech-info]: #technical-information
[style-guide]: https://github.com/johnpapa/angular-styleguide
[rubygems]: https://rubygems.org/pages/download
[ruby]: https://www.ruby-lang.org/en/downloads/
[bundler]: http://bundler.io/
[tutorial]: https://github.com/joshbeam/angular_init/blob/master/TUTORIAL.md