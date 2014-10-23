(function() {
  function WinningService($http, $q, RoundService) {
    var self = this;

    self.win = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/nominations/' + nominationId + '/win')
        .success(function(data){
          RoundService.current = data.round;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.unwin = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.delete('/rounds/' + roundId + '/nominations/' + nominationId + '/win')
        .success(function(data){
          RoundService.current = data.round;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };
  }

  angular
    .module('BookClubFiction')
    .service('WinningService', WinningService);
})();
