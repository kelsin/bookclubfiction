(function () {
  function IndexController($scope, $location, RoundService) {
  	$scope.round = RoundService;
  	$scope.$watch('round.current', function(newRound){
  		console.log('adsf');
  		if(newRound.state === 'nominating'){
  			$location.url('/nominations');
  		}
  	});
  }

  angular
    .module('BookClubFiction')
    .controller('IndexController', IndexController);
})();
