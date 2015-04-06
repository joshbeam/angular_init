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