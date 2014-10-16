(function() {
  function RoundService($http, $q) {
    var self = this;
    self.current = {};

    self.newRound = function(genre){
      var deferred = $q.defer();
      $http.post('/rounds', { genre: genre})
        .success(function(data){
          self.current = data.round;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    }

    self.progressRound = function(roundId){
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/progress')
        .success(function(data){
          self.current = data.round;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    }
  }



  angular
    .module('BookClubFiction')
    .service('RoundService', RoundService);
})();
