;(function(app) {

	'use strict';

	app.{{type}}({{type}});

	{{type}}.$inject = {{inject | array_string}};

	function {{type}}({{inject | comma_delimited_variables}}) {

	}

})(angular.module('{{module}}'));