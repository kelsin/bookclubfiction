(function() {
  function StatusService($http, RoundService) {
    var self = this;

    $http.get('/status').
      success(function(data) {
        self.user = data.user;
        RoundService.current = data.current;
      }).
      error(function() {
        console.log("Error loading status");
      });

    self.logged_in = function() {
      return !!self.user;
    };
  }

  angular
    .module('BookClubFiction')
    .service('StatusService', StatusService);
})();
