(function () {
  function AdminVotesController($scope, UsersService) {
    $scope.users = [];

    UsersService.users()
      .then(function(users) {
        $scope.users = users;
      });

    $scope.vote = function(userId) {
      UsersService.vote(userId)
        .then(function() {
          var user = _.find($scope.users, { id: userId });
          user.extra_votes++;
        });
    };

    $scope.unvote = function(userId) {
      UsersService.unvote(userId)
        .then(function() {
          var user = _.find($scope.users, { id: userId });
          user.extra_votes--;
        });
    };
  }

  angular
    .module('BookClubFiction')
    .controller('AdminVotesController', AdminVotesController);
})();
