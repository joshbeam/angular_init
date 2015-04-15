;(function(app) {

  'use strict';

  app.filter('someFilter',someFilter);

  someFilter.$inject = ['aService', 'andAnotherOne'];

  function someFilter(aService, andAnotherOne) {
  
    
    return function(input) {
      return;
    }
    
  }

})(angular.module('myModule'));