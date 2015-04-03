((app) ->

  'use strict'
  
  {{name}}.$inject = {{inject | array_string}}
  
  app.{{type}} '{{name}}', {{name}}
  
  {{name}} = ({{inject | comma_delimited_variables}}) ->
  	{% if directive %}
    d = 
      restrict: 'A'
      link: link

    link = (scope, element, attrs) ->

    d
    {% endif directive %}
    {% if filter %}
    (input) ->
      input
	{% endif filter %}
) {{module}}