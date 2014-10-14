(function () {
  function SecondingController($scope, ProfileService, SecondingService, VotingService) {
    $scope.profile = ProfileService;
    $scope.seconding = SecondingService;
    $scope.voting = VotingService;

    $scope.classes = function(bookId){
        var c = [];
        if(VotingService.votedOn(bookId)){
            c.push('seconded');
            if(VotingService.extraVotedOn(bookId)){
                c.push('plus-one');
            }
        }
        return c;
    };

    $scope.votingSort = function(book){
        return VotingService.votes(book.id) * -1;
    };
  }

  angular
    .module('BookClubFiction')
    .controller('SecondingController', SecondingController);
})();
