(function () {
  function ProfileController($scope, ProfileService) {
    $scope.profile = ProfileService;
  }

  angular
    .module('BookClubFiction')
    .controller('ProfileController', ProfileController);
})();
