Command line tool that creates one-off "boilerplate code" for AngularJS controllers, directives, configs, runs, filters, factories...

Type less, write more AngularJS!

# Sample Usage

After you [do the 2-step install][install] for `ngi` (the short-name for the shell script of `angular_init`), go to where your site is at (in this case, `~/MyAwesomeApp`):

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

# Installation (in 2 steps)

## Before you start

1. Open up your command line
2. Switch to your top-most directory (Linux/Mac: `cd /`)

## And go!

### Step 1

```shell
/ $ git clone https://github.com/joshbeam/angular_init.git usr/local/ngi
```

### Step 2

We need to make sure your terminal knows where to look. We'll set your `PATH` variable.

Open `~/.bash_profile` (or wherever you set your environment variables on your machine) and type:

```shell
export PATH="/usr/local/ngi/bin:$PATH"
```

Save, and re-start your terminal (if the above doesn't work, you can just type the line into your terminal and hit enter, but that'll just set the variable temporarily, and you'll have to type it again every time you start your terminal).

**Getting a permission error?**

The permissions to run `ngi` should already be set. However, if you're getting an error running `ngi` in your terminal, do this:

```shell
/ $ cd usr/local/ngi/bin
/usr/local/ngi/bin $ chmod 755 ngi
```

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

[install]: #installation-in-2-steps