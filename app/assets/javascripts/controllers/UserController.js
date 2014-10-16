(function () {
  function UserController($scope, StatusService) {
    $scope.status = StatusService;
  }

  angular
    .module('BookClubFiction')
    .controller('UserController', UserController);
})();
