((app) ->

  {{type}} = ({{inject | comma_delimited_variables}}) ->

  'use strict'

  app.{{type}} {{type}}

  config.$inject = {{inject | array_string}}
  return

) angular.module('{{module}}')