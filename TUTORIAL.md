Hello!

Here you'll learn the basics of creating your own custom template to use with ngi.

# Example (basic.js)

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

Use normal JavaScript or CoffeeScript syntax.

## 1. Placeholders

Use the following *placeholders* in your template:

  {{type}}
    The type of component (directive, controller, etc. Type ngi -h to see the available components)

  {{name}}
    [?] <component> name: <user input>
    The user will inject the name of the component here (e.g. MyAwesomeController)

  {{inject | array_string}}
    [?] Inject: <user input>
    This will turn the user's input for the injectable components into an array

    For example:
    [?] Inject: someService, anotherService
    => ['someService', 'anotherService']

  {{inject | comma_delimited_variables}}
    [?] Inject: <user input>
    This will turn the user's input for the injectable components into a
    comma-delimited string of arguments

    For example:
    [?] Inject: someService, anotherService
    => 'someService', 'anotherService'

## 2. Tags
    
Tags allow you to use the same template for multiple types of components.
For example, the above example template for "basic.js" allows you
to use the same template for multiple components, including controllers,
directives, and filters.

Use the following *tags* in your template:

  {% if <component> %}
    // conditional code here
  {% endif <component> %}