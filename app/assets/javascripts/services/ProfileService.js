(function() {
  function ProfileService($http) {
    var self = this;
    self.user = {};

    $http.get('/status').
      success(function(data) {
        self.user = data.user;
      }).
      error(function() {
        console.log("Error loading profile");
      });
  }

  angular
    .module('BookClubFiction')
    .service('ProfileService', ProfileService);
})();
