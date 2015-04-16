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

# or

~/MyAwesomeApp $ ngi index # => an index page in HTML

# or

# use either --options or -o
~/MyAwesomeApp $ ngi --options # => choose your language to use (CoffeeScript or ECMAScript5)
```