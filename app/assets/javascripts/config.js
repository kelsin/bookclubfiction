(function(){
	function config($routeProvider, $locationProvider){
		$locationProvider.html5Mode(true);
		$routeProvider
			.when('/nominations', {
				controller: 'NominationsController',
				templateUrl: 'templates/nominations.html'
			})
			.when('/seconding', {
				controller: 'SecondingController',
				templateUrl: 'templates/seconding.html'
			})
			.when('/reading', {
				templateUrl: 'templates/reading.html'
			})
			.when('/admin', {
				controller: 'AdminController',
				templateUrl: 'templates/admin.html'
			})
			.when('/admin/votes', {
				templateUrl: 'templates/admin-votes.html'
			})
			.otherwise({
				controller: 'IndexController',
				templateUrl: 'index.html'
			});
	}
	angular
    	.module('BookClubFiction')
    	.config(config);
})();