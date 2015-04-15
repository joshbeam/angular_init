;(function(app) {

  'use strict';

  app.directive('myDirective',myDirective);

  myDirective.$inject = ['someService', 'anotherService'];

  function myDirective(someService, anotherService) {

    var d = {
      restrict: 'A',
      link: link
    };

    return d;

    function link(scope, element, attrs) {

    }


  }

})(angular.module('myModule'));