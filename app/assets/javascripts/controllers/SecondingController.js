(function () {
  function SecondingController($scope, $location, $interval, $window, StatusService, RoundService) {
    $scope.round = RoundService;
    $scope.status = StatusService;

    $scope.voteTimer = $interval(function(){
        $scope.$broadcast('timerTick');
    }, 1000);
  }

  angular
    .module('BookClubFiction')
    .controller('SecondingController', SecondingController);
})();
