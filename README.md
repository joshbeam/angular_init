Command line tool that creates "boilerplate code" for AngularJS controllers, directives, configs, runs, filters, factories...

Basically, limit the amount of typing you have to do to make a new controller, or whatever.

# Sample Usage

## Command line

```shell
~/MyAwesomeApp $ ngi controller # run the tool!

# you'll be prompted for some quick info
New file name: myAwesome.controller.js
Module name: myModule
Controller name: MyAwesomeController
Inject (already injected $scope): $route

# all done!
```

## Output (your new boilerplate code)

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

# Installation (in 5 lines)

All from the command line (Linux/Mac):

```shell
~ $ mkdir .angular_init
~ $ cd .angular_init
~/.angular_init $ git clone https://github.com/joshbeam/angular_init.git
~ $ chmod 755 ngi
~ $ export PATH=$PATH:~/.angular_init/bin
```

1. From your `~` (user directory, something like `/Users/yourname`), make the hidden directory `.angular_init` (this is where the command line tool `ngi` will live)
2. Go to that directory
3. Clone this repository
4. Make sure to `chmod`! This lets the script actually run
5. Finally, add the new script to your `$PATH`

*Consult an IT professional if you are unsure of any of the above steps*

# Commands

```shell
~/MyAwesomeApp $ ngi controller # => controller
~/MyAwesomeApp $ ngi directive # => directive
~/MyAwesomeApp $ ngi factory # => factory
~/MyAwesomeApp $ ngi service # => service (same as factory)
~/MyAwesomeApp $ ngi constant # => constant
~/MyAwesomeApp $ ngi run # => a run block
~/MyAwesomeApp $ ngi config # => a config block
~/MyAwesomeApp $ ngi routes # => a config block with $routeProvider injected
~/MyAwesomeApp $ ngi module # => module (you can inject dependencies too)
~/MyAwesomeApp $ ngi filter # => filter
```

# Information

**Version** 0.1.0
**Language** Ruby

<hr>

&copy; 2015 Joshua Beam (MIT License) &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a>