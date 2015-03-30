Command line tool that creates "boilerplate code" for AngularJS controllers, directives, configs, runs, filters, factories...

Type less, write more AngularJS!

# Sample Usage

After you [install][install] `ngi` (the short-name for the shell script of `angular_init`), go to where your site is at (in this case, `~/MyAwesomeApp`):

## Command line

```shell
~/MyAwesomeApp $ ngi controller # this will create a controller!

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

By the way, the output of this little tool is meant to follow <a href="https://github.com/johnpapa/angular-styleguide">John Papa's AngularJS Style Guide</a>.

# Installation (in 6 lines)

## Before you start

1. Open up your command line
2. Switch to your user directory (Linux/Mac: `cd ~`)

## And go!

All from the command line (Linux/Mac):

```shell
~ $ mkdir .angular_init
~ $ cd .angular_init
~/.angular_init $ git clone https://github.com/joshbeam/angular_init.git
~/.angular_init $ cd angular_init/bin
~/.angular_init/angular_init/bin $ chmod 755 ngi
~/.angular_init/angular_init/bin $ export PATH=$PATH:~/.angular_init/angular_init/bin
```

**Just copy & paste each of the lines above.**

1. From your `~` (user directory, something like `/Users/yourname`), make the hidden directory `.angular_init` (this is where the command line tool `ngi` will live)
2. Go to that directory
3. Clone this repository
4. Go to the `bin`
4. Make sure to `chmod` the script! This lets it actually run
5. Finally, add the new script directory to your `$PATH` (so your shell knows where to look)

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

[install]: #installation-in-6-lines