(function() {
  function StatusService($http, RoundService) {
    var self = this;
    self.user = {};
    self.logged_in = false;

    $http.get('/status').
      success(function(data) {
        self.user = data.user;
        self.logged_in = data.logged_in;
        RoundService.current = data.current;
      }).
      error(function() {
        console.log("Error loading status");
      });
  }

  angular
    .module('BookClubFiction')
    .service('StatusService', StatusService);
})();
