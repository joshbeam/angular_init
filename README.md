# angular_init

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ngi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

<a href="http://joshbeam.github.io/angular_init">Website</a>

**Version 0.2.0** (not backwards compatible with previous versions)

**What's different?**
- New syntax, example: `ngi --make controller`
- No more `ngi -options` (use `ngi --config` instead)
- ability to make an `index` HTML page (`ngi -m index`)

## In simple terms:

This tool (`ngi`) can make (for example) an AngularJS controller template file for you (`.js`), so that **whenever you want to make a new controller for your app, you don't have to type the same starting code over and over again** (by the way, this tool doesn't only create controllers. It does directives, filters... almost anything).

## Why use `ngi` (and not something else)?

**`ngi` has one task, and one task only, which makes it lightweight and specialized**. Most AngularJS developers are probably using the command line already (Gulp, Bower, npm, Git, etc.), so why not use the command line to streamline your code-writing too?

Type less, write more AngularJS! Use `ngi`, the simple template generator.

![Example](https://github.com/joshbeam/angular_init/blob/master/ngi_example.gif "Example")

# Table of Contents

- [Sample Usage][sample-usage]
- [Features][features]
- [Install in 1 step][install]
- [How to use it (docs)][commands]
- [FAQ][faq]
- [Technical Info][tech-info]

# Sample Usage

After you [do the 1-step installation][install] of `ngi` (the short-name for the shell script of `angular_init`), go to where your site is at (in this case, `~/MyAwesomeApp`). When you're in your site's project directory, just type `ngi --make (or -m) <type>` to create a new JavaScript file for you!

## Command line

```shell
~/MyAwesomeApp $ ngi --make controller # this will create a controller!

# you'll be prompted for some quick info
[?] New file name: myAwesome.controller.js
[?] Module name: myModule
[?] Controller name: MyAwesomeController
[?] Inject (already injected $scope): $route

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

# Features

## Current features

- Create a module, directive, controller, filter, run, config, "routes" config, constant, service, factory, or index HTML page by saying `ngi --make <type>`, where `<type>` is any of the above types (module, directive, etc.)
- Current languages that have default templates: CoffeeScript, ECMAScript5 (choose your language with `ngi --config (or -c)`)

## Coming soon

- Add custom templates and languages

Feel free to fork the project or get <a href="http://frontendcollisionblog.com/about">in touch with Josh (me)</a> with any feature requests!

# Installation (in 1 step)

Add this line to your application's Gemfile:

    gem 'ngi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ngi

# Commands

```shell
# use either --make or -m
~/MyAwesomeApp $ ngi --make controller # => controller
~/MyAwesomeApp $ ngi --make directive # => directive
~/MyAwesomeApp $ ngi --make factory # => factory
~/MyAwesomeApp $ ngi --make service # => service (same as factory)
~/MyAwesomeApp $ ngi --make constant # => constant
~/MyAwesomeApp $ ngi --make run # => a run block
~/MyAwesomeApp $ ngi --make config # => a config block
~/MyAwesomeApp $ ngi --make routes # => a config block with $routeProvider injected
~/MyAwesomeApp $ ngi --make module # => module (you can inject dependencies too)
~/MyAwesomeApp $ ngi --make filter # => filter

# or

~/MyAwesomeApp $ ngi --make index # => an index page in HTML

# or

# use either --config or -c
~/MyAwesomeApp $ ngi --config # => choose your language to use (CoffeeScript or ECMAScript5)

# or

~/MyAwesomeApp $ ngi --help
# => Usage: ngi <command> <options>
# => -m, --make TYPE                  Create a new AngularJS component
# => -c, --config                     Configure ngi settings

# or

~/MyAwesomeApp $ ngi --version
# => ngi 0.2.0
```

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

**4. Why are you following the snake-case convention (`angular_init`) and not camelCase (`angularInit`) if this is a JavaScript project?**

The command line tool itself is written in <a href="https://www.ruby-lang.org/en/">Ruby</a>, and the <a href="https://github.com/bbatsov/ruby-style-guide#snake-case-files">convention</a> is to use snake-case for class file naming.

*For other questions and comments, check out this <a href="http://www.reddit.com/r/angularjs/comments/30ydha/command_line_tool_to_create_angularjs_controllers/">Reddit discussion</a> about `ngi` (feel free to post your own question too). Or, open a new issue on GitHub.*

# Technical Information

**Version** 0.2.0

**Language** Ruby

**Requirements** Only tested with `ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-darwin13.0]`. Compatibility with previous versions of Ruby cannot be guaranteed.

<hr>

&copy; 2015 Joshua Beam (MIT License) &mdash; <a href="http://frontendcollisionblog.com">Front End Collision</a>

[install]: #installation-in-1-step
[sample-usage]: #sample-usage
[features]: #features
[commands]: #commands
[faq]: #faq
[tech-info]: #technical-information
[style-guide]: https://github.com/johnpapa/angular-styleguide