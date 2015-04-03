<a href="http://joshbeam.github.io/angular_init">Website</a>

**In simple terms:** This tool, also called by its short-name `ngi`, can make (for example) an AngularJS controller template file for you (`.js`), so that **whenever you want to make a new controller for your app, you don't have to type the same starting code over and over again** (by the way, this tool doesn't only create controllers. It does directives, filters... almost anything).

**Why use this and not something else?** Good question. You *could* create your own templates and just copy and paste (but this is cumbersome). You could use a scaffolding tool, but that's like going to a general practice doctor (a huge scaffolding tool), when you know you just need to see the <a href="http://en.wikipedia.org/wiki/Otorhinolaryngology">otolaryngologist</a> (angular_init).

**`ngi` has one task, and one task only, which makes it lightweight and specialized**. Most AngularJS developers are probably using the command line already (Gulp, Bower, npm, Git, etc.), so why not use the command line to streamline your code-writing too?

Type less, write more AngularJS! Use `ngi`, the simple template generator.

![Example](https://github.com/joshbeam/angular_init/blob/master/ngi_example.gif "Example")

# Table of Contents

- [Sample Usage][sample-usage]
- [Installation][install]
- [Commands][commands]
- [Coming Soon][coming-soon]
- [FAQ][faq]
- [Technical Information][tech-info]

# Sample Usage

After you [do the 2-step install][install] for `ngi` (the short-name for the shell script of `angular_init`), go to where your site is at (in this case, `~/MyAwesomeApp`). When you're in your site's project directory, just type `ngi <type>` to create a new JavaScript file for you!

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

By the way, the output of this little tool is meant to follow [John Papa's AngularJS Style Guide][style-guide].

# Installation (in 2 steps)

## Before you start

1. Open up your command line
2. Switch to your top-most directory (Linux/Mac: `/`, Windows: `C:` )

## And go!

### Step 1

**Linux/Mac**

```shell
/ $ git clone https://github.com/joshbeam/angular_init.git usr/local/ngi
```

**Windows**

Clone into your executable directory (for example, `C:/Program Files`)

### Step 2

We need to make sure your terminal knows where to look. We'll set your `PATH` variable.

**Mac/Linux**

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

**Windows**

Depending on your version of Windows, follow <a href="http://www.computerhope.com/issues/ch000549.htm">these instructions</a> to set your environment variable.

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

# Coming Soon

- Tutorial for customizing templates used to generate components (in order to fit specific individual or organizational needs, patterns, workflows, styles, etc.)

- Flag to generate templates based on alternate syntax (CoffeeScript or ES6)?

Feel free to fork the project or get <a href="http://frontendcollisionblog.com/about">in touch with Josh (me)</a> with any feature requests!

# FAQ

**1. Can you explain why the module name is passed as the argument to the IIFE (in the default template)?**

- If you're using a JSHint plug-in, it will only say 'angular is not defined' in one place
- Eliminates the clutter of declaring something like `var app = angular.module('myModule')`
- Something like `angular.module('myModule')` cannot be minified, but the argument `app` can (only an issue if the full module getter happens multiple time)
- Streamlines the pattern across all of the templates

**2. Is there a way to modify the template to incorporate things like CoffeeScript or ES6?**

This feature is coming soon!

**3. Why are you using `$inject`?**

Check out [John Papa's Style Guide][style-guide].

*For other questions and comments, check out this <a href="http://www.reddit.com/r/angularjs/comments/30ydha/command_line_tool_to_create_angularjs_controllers/">Reddit discussion</a> about `ngi` (feel free to post your own question too). Or, open a new issue on GitHub.*

# Technical Information

**Version** 0.1.0

**Language** Ruby

**Requirements** Only tested with `ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-darwin13.0]`. Compatibility with previous versions of Ruby cannot be guaranteed.

<hr>

&copy; 2015 Joshua Beam (MIT License) &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a>

[install]: #installation-in-2-steps
[sample-usage]: #sample-usage
[commands]: #commands
[coming-soon]: #coming-soon
[faq]: #faq
[tech-info]: #technical-information
[style-guide]: https://github.com/johnpapa/angular-styleguide
