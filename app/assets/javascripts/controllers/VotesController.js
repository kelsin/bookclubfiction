(function () {
  function VotesController($scope, $window, StatusService, SecondingService, RoundService) {
    $scope.status = StatusService;

    var update = function(response) {
      var data = response.data;
      if (data.extra_votes) {
        StatusService.user.extra_votes = data.extra_votes;
      }
      $.extend($scope.nomination, data.nomination);
    };

    $scope.vote = function(nomination){
      if(StatusService.member()) {
        if(nomination.vote){
          SecondingService
            .unvote(nomination.id, RoundService.current.id)
            .then(update);
        } else {
          SecondingService
            .vote(nomination.id, RoundService.current.id)
            .then(update);
        }
      } else {
        $window.open(nomination.book.url, "_blank");
      }
    };

    $scope.extra = function(nomination){
      if(StatusService.member()) {
        if(nomination.extra){
          SecondingService
            .unextra(nomination.id, RoundService.current.id)
            .then(update);
        } else {
          SecondingService
            .extra(nomination.id, RoundService.current.id)
            .then(update);
        }
      } else {
        $window.open(nomination.book.url, "_blank");
      }
    };
  }

  angular
    .module('BookClubFiction')
    .controller('VotesController', VotesController);
})();
