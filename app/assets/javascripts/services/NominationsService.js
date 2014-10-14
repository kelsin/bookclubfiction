(function() {
  function NominationsService($http) {
    var self = this;
    self.books = [];

    self.size = function() {
      return self.books.length;
    };

    self.isEmpty = function() {
      return self.size() === 0;
    };
  }

  angular
    .module('BookClubFiction')
    .service('NominationsService', NominationsService);
})();
