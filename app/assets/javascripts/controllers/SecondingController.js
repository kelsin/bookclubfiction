(function () {
  function SecondingController($scope, $location, $interval, $window, StatusService, SecondingService, RoundService) {
    $scope.seconding = SecondingService;
    $scope.round = RoundService;
    $scope.status = StatusService;

    $scope.voteTimer = $interval(function(){
        $scope.$broadcast('timerTick');
    }, 1000);

    $scope.vote = function(nomination){
      if(StatusService.member()) {
        if(nomination.vote){
            SecondingService.unvote(nomination.id, RoundService.current.id);
        } else {
            SecondingService.vote(nomination.id, RoundService.current.id);
        }
      } else {
        $window.open(nomination.book.url, "_blank");
      }
    };
    $scope.extra = function(nomination){
      if(StatusService.member()) {
        if(nomination.extra){
            SecondingService.unextra(nomination.id, RoundService.current.id);
        } else {
            SecondingService.extra(nomination.id, RoundService.current.id);
        }
      } else {
        $window.open(nomination.book.url, "_blank");
      }
    };
  }

  angular
    .module('BookClubFiction')
    .controller('SecondingController', SecondingController);
})();
