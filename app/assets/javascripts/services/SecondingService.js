(function() {
  function SecondingService($http, $q, RoundService, StatusService) {
    var self = this;

    self.vote = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/nominations/' + nominationId + '/vote')
        .success(function(data){
          RoundService.current = data.round;
          StatusService.user = data.user;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.unvote = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.delete('/rounds/' + roundId + '/nominations/' + nominationId + '/vote')
        .success(function(data){
          RoundService.current = data.round;
          StatusService.user = data.user;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.extra = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/nominations/' + nominationId + '/extra')
        .success(function(data){
          RoundService.current = data.round;
          StatusService.user = data.user;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.unextra = function(nominationId, roundId) {
      var deferred = $q.defer();
      $http.delete('/rounds/' + roundId + '/nominations/' + nominationId + '/extra')
        .success(function(data){
          RoundService.current = data.round;
          StatusService.user = data.user;
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
    .service('SecondingService', SecondingService);
})();
