(function() {
  function SearchService($http) {
    var self = this;

    self.clear = function() {
      self.loading = false;
      self.loaded = false;
      self.results = {
        query: '',
        books: []
      };
    };

    // Setup initial state
    self.clear();

    self.search = function(query) {
      if(query.length > 0){
        self.loading = true;
        $http({method: 'GET', url: '/search/' + encodeURIComponent(query)}).
          success(function(data){
            self.loaded = true;
            self.results = data;
            self.loading = false;
          }).
          error(function(){
            console.log('Error searching');
          });
      } else {
        self.clear();
      }
    };
  }

  angular
    .module('BookClubFiction')
    .service('SearchService', SearchService);
})();
