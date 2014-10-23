(function () {
  function ReadingController($scope, RoundService) {
    $scope.round = RoundService;
  }

  angular
    .module('BookClubFiction')
    .controller('ReadingController', ReadingController);
})();
