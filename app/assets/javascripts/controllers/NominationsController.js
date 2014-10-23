(function () {
  function NominationsController($scope, $interval, $location, $document, StatusService, SearchService, NominationsService, RoundService) {
    $scope.status = StatusService;
    $scope.search = SearchService;
    $scope.query = '';
    $scope.nominations = NominationsService;
    $scope.round = RoundService;

    var timer = null;
    $scope.onChange = function (){
        $interval.cancel(timer);
        timer = $interval(function(){
            $scope.search.search($scope.query);
        }, 500, 1);
    };
    $scope.select = function(book){
        NominationsService.select(book, RoundService.current.id);
        $scope.clear();
    };
    $scope.nominate = function(book){
        NominationsService.nominate(book, RoundService.current.id);
    };
    $scope.remove = function(id){
        NominationsService.remove(id, RoundService.current.id);
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
