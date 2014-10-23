(function () {
  function IndexController($scope, $location, RoundService) {
  	$scope.round = RoundService;
  }

  angular
    .module('BookClubFiction')
    .controller('IndexController', IndexController);
})();
