(function () {
  function NominationsController($scope, SearchService, $interval, NominationsService, $document) {
    $scope.search = SearchService;
    $scope.query = '';
    $scope.nominations = NominationsService;
    var timer = null;
    $scope.onChange = function (){
        $interval.cancel(timer);
        timer = $interval(function(){
            $scope.search.search($scope.query);
        }, 500, 1);
    };
    $scope.nominate = function(book){
        $scope.nominations.books.push(book);
        $scope.clear();
    };
    $scope.remove = function(index){
        $scope.nominations.books.splice(index, 1);
    };
    $scope.promote = function(index){
        var book = $scope.nominations.books.splice(index,1)[0];
        if(book){
            $scope.nominations.books.unshift(book);
        }
    };
    $scope.clear = function(){
        $scope.search.clear();
        $scope.query = '';
    };
    $scope.$watch('search.results', function(){
        document.getElementById('searchResults').scrollTop = 0;
    });
    $document.mouseup(function(e){
        var container = $('#searchAndResults');
        if(!container.is(e.target) && container.has(e.target).length === 0 && $scope.search.results.books.length > 0){
            $scope.clear();
            $scope.$apply();
        }
    });
  }

  angular
    .module('BookClubFiction')
    .controller('NominationsController', NominationsController);
})();
