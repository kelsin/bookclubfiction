(function () {
  function UserController($scope, $location, StatusService, RoundService) {
    $scope.status = StatusService;
    $scope.round = RoundService;

    $scope.$watch('round.current', function(newRound){
      if(StatusService.logged_in() && $location.path().indexOf("/admin") !== 0) {
        if(newRound && newRound.state) {
          $location.url('/' + newRound.state);
        }
      }
    });
  }

  angular
    .module('BookClubFiction')
    .controller('UserController', UserController);
})();
