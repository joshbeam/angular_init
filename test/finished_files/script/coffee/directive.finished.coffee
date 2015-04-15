((app) ->

  'use strict'
  
  myDirective.$inject = ['someService', 'anotherService']
  
  app.directive 'myDirective', myDirective
  
  myDirective = (someService, anotherService) ->
    
    d = 
      restrict: 'A'
      link: link

    link = (scope, element, attrs) ->

    d
    
   
) angular.module('myModule')