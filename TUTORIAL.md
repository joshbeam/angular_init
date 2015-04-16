# Create your own ngi template

Hello!

Here you'll learn the basics of creating your own custom template to use with ngi.

## Quick Start

**Step 1** First, create a template following the [syntax below][syntax]. You can use your own styling to make the template fit your own workflow. Then you want to give the template a name. For this example, we'll use `my.directive.template.js`

**Step 2** Execute `$ ngi -o` so that you can configure ngi. This is where we're going to tell ngi to use the new template file you just created.

**Step 3** You'll see something like this:

```shell
Current settings
================
1) Language: {'script': 'es5', 'markup': 'html'}
2) Templates: Currently using default settings

Choose from: ['language', 'templates']
templates # type this to select templates

Choose from: ['directive', 'controller', 'factory', 'service', 'config', 'run', 'routes', 'filter', 'module', 'constant', 'index']
directive # here, we're creating a directive
[?] Use the following template file: my.directive.template.js # this is where you choose the new custom template to use
```

*Pro Tip: Make sure that if you are not currently in the same directory as your custom template file, that you use the absolute path to the template file (like `User/yourname/Sites/MyAwesomeApp/my.directive.template.js`), or else ngi will tell you that it can't find the file!*

**Step 4** Follow the rest of the prompts (you'll choose the syntax that the template is in, which is either `es5` for ECMAScript5 or `coffee` for CoffeeScript). In this example, we'll say we set the language to `es5`.

Now, whenever your current language is set to `es5` and you execute `ngi directive`, ngi will **now use your custom template file when generating a directive**.

*If you want to revert back to using default templates at any time: when you're prompted to type the file name of the template you want to use, just type the keyword `default` instead, and you'll be good to go!*

# Example (basic.js)

This example template is actually the default template used for the following components:
- Factory
- Controller
- Directive
- Service
- Filter

```javascript
;(function(app) {

'use strict';

app.{{type}}('{{name}}',{{name}});

{{name}}.$inject = {{inject | array_string}};

function {{name}}({{inject | comma_delimited_variables}}) {
  {% if directive %}
  var d = {
    restrict: 'A',
    link: link
  };

  return d;

  function link(scope, element, attrs) {

  }
  {% endif directive %}
  {% if filter %}
  return function(input) {
    return;
  }
  {% endif filter %}
}

})(angular.module('{{module}}'));
```

# Syntax

Use normal JavaScript or CoffeeScript syntax. You'll notice that the custom syntax below is somewhat similar to the style of [Liquid][liquid], but don't be fooled! You cannot use Liquid here.

## 1. Placeholders

Use the following **placeholders** in your template:

- `{{module}}`
  - The name of the module (e.g. `myModule`)

- `{{type}}`
  - The type of component (directive, controller, etc. Type `ngi -h` to see the available components)

- `{{name}}`
  - `[?] <component> name: <user input>`
  - This will be replaced with the name of the component (e.g. `MyAwesomeController`)

- `{{inject | array_string}}`
  - `[?] Inject: <user input>`
  - This will turn the user's input for the injectable components into an array
  - For example:
    - `[?] Inject: someService, anotherService`
    - `=> ['someService', 'anotherService']`

- `{{inject | comma_delimited_variables}}`
  - `[?] Inject: <user input>`
  - This will turn the user's input for the injectable components into a comma-delimited string of arguments
  - For example:
    - `[?] Inject: someService, anotherService`
    - `=> 'someService', 'anotherService'`

## 2. Tags
    
Tags allow you to use the same template for multiple types of components.
For example, the above example template for "basic.js" allows you
to use the same template for multiple components, including controllers,
directives, and filters.

Use the following **tags** in your template:

```javascript
{% if <component> %}
  // conditional code here
{% endif <component> %}
```

[syntax]: #syntax
[liquid]: http://liquidmarkup.org/