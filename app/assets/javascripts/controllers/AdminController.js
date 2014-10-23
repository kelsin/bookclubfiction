(function () {
  function AdminController($scope, StatusService, RoundService, WinningService) {
    $scope.status = StatusService;
  	$scope.round = RoundService;
    $scope.genre = '';

    $scope.newRound = function() {
      RoundService.newRound($scope.genre).then(function(data){
        $scope.genre = '';
      }, function(error){
        console.log(error);
      });
    };

    $scope.backupRound = function() {
      RoundService.backupRound($scope.round.current.id);
    };

    $scope.progressRound = function() {
      RoundService.progressRound($scope.round.current.id);
    };

    $scope.win = function(nomination) {
      if(nomination.winner) {
        WinningService.unwin(nomination.id, RoundService.current.id);
      } else {
        WinningService.win(nomination.id, RoundService.current.id);
      }
    };
  }

  angular
    .module('BookClubFiction')
    .controller('AdminController', AdminController);
})();
