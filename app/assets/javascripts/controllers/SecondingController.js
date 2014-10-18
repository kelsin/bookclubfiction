(function () {
  function SecondingController($scope, StatusService, SecondingService, RoundService) {
    $scope.seconding = SecondingService;
    $scope.round = RoundService;
    $scope.status = StatusService;
    $scope.vote = function(nomination){
        if(nomination.vote){
            SecondingService.unvote(nomination.id, RoundService.current.id);
        } else {
            SecondingService.vote(nomination.id, RoundService.current.id);
        }
    };
    $scope.extra = function(nomination){
        if(nomination.extra){
            SecondingService.unextra(nomination.id, RoundService.current.id);
        } else {
            SecondingService.extra(nomination.id, RoundService.current.id);
        }
    };
  }

  angular
    .module('BookClubFiction')
    .controller('SecondingController', SecondingController);
})();
