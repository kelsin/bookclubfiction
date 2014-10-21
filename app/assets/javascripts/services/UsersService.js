(function() {
  function UsersService($http, $q) {
    var self = this;

    self.users = function() {
      var deferred = $q.defer();
      $http.get('/users')
        .success(function(data) {
          deferred.resolve(data.users);
        })
        .error(function(error) {
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.vote = function(userId) {
      var deferred = $q.defer();
      $http.post('/users/' + userId + '/vote')
        .success(function(data) {
          deferred.resolve(data.user);
        })
        .error(function(error) {
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };

    self.unvote = function(userId) {
      var deferred = $q.defer();
      $http.delete('/users/' + userId + '/vote')
        .success(function(data) {
          deferred.resolve(data.user);
        })
        .error(function(error) {
          console.log(error);
          deferred.reject(error);
        });
      return deferred.promise;
    };
  }

  angular
    .module('BookClubFiction')
    .service('UsersService', UsersService);
})();
