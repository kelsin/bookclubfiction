(function(){
	function config($routeProvider, $locationProvider){
		$locationProvider.html5Mode(true);
		$routeProvider
			.when('/nominations', {
				controller: 'NominationsController',
				templateUrl: 'nominations.html'
			})
			.when('/seconding', {
				controller: 'SecondingController',
				templateUrl: 'seconding.html'
			})
			.when('/reading', {
				templateUrl: 'reading.html'
			})
			.when('/admin', {
				controller: 'AdminController',
				templateUrl: 'admin.html'
			})
			.when('/admin/votes', {
				templateUrl: 'admin-votes.html'
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
