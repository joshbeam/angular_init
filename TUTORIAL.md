# Create your own ngi template

Hello!

Here you'll learn the basics of creating your own custom template to use with ngi.

## Quick Start

- Create a new template file (call it, say, `my.directive.template.js`)
- Run `$ ngi -o`
- Choose `templates`, then `directive`
- When prompted to select the file to use, type `my.directive.template.js`
- You'll then be prompted to choose the JavaScript syntax (current options are `es5` and `coffee`)
- All done!

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

[liquid]: http://liquidmarkup.org/