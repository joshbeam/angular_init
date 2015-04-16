
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

![Example](https://github.com/joshbeam/angular_init/blob/master/ngi_example.gif "Example")

```shell
~/MyAwesomeApp $ ngi controller # this will create a controller!

# you'll be prompted for some quick info
[?] New file name: myAwesome.controller.js
[?] Module name: myModule
[?] Controller name: MyAwesomeController
[?] Inject (already injected $scope): $route

# all done!
```

## Output (new boilerplate code)

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

Uses <a href="http://semver.org/">Semantic Versioning</a>

**Language** Ruby

**Requirements** Only tested with `ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-darwin13.0]`. Compatibility with previous versions of Ruby cannot be guaranteed.

<hr>

**Disclaimer**

`angular_init` and `ngi` and the author (Joshua Beam) are not directly associated with <a href="http://angularjs.org">AngularJS</a>.

**Copyright (c) 2015 Joshua Beam** &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a>

MIT License

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