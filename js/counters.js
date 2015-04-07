$(function() {
	$.getJSON('https://rubygems.org/api/v1/search.json?query=cucumber', function(data) {
		console.log(data);
	});
}());