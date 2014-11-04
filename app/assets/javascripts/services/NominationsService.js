(function() {
  function NominationsService($rootScope, $http, $q, RoundService) {
    var self = this;
    self.books = [];

    self.size = function() {
      return self.books.length;
    };

    self.isEmpty = function() {
      return self.size() === 0;
    };

    self.select = function(book, roundId){
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/selections', { book: book })
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

    self.nominate = function(book, roundId){
      var deferred = $q.defer();
      $http.post('/rounds/' + roundId + '/nominations', { book: book })
        .success(function(data){
          RoundService.current = data.round;
          deferred.resolve(data.round);
        })
        .error(function(error){
          console.log(error);
          $rootScope.nominationError = error.error;
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.remove = function(id, roundId){
      var deferred = $q.defer();
      $http.delete('/rounds/' + roundId + '/selections/' + id)
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
    .service('NominationsService', NominationsService);
})();
