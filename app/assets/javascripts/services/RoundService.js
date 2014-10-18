(function() {
  function RoundService($http, $q, $rootScope) {
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
    };

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
    };

    // Setup faye
    self.faye = new Faye.Client('/faye');
    self.faye.subscribe('/nominations', function(message) {
      var nomination = _.find(self.current.nominations, { id: message.id });
      nomination.value = message.value;
      nomination.votes = message.votes;
      nomination.extras = message.extras;
      $rootScope.$apply();
    });
  }

  angular
    .module('BookClubFiction')
    .service('RoundService', RoundService);
})();
