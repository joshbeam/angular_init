;(function(app) {

  'use strict';

  app.controller('MyController',MyController);

  MyController.$inject = ['someService', 'anotherService', '$scope'];

  function MyController(someService, anotherService, $scope) {
  
  }

})(angular.module('myModule'));