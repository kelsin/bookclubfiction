var app = angular.module('BookClubFiction', []);

app.controller('ProfileController', ['$scope', 'profile', function($scope, profile){
	$scope.profile = profile;
}]);

app.controller('SecondingController', ['$scope', 'profile', 'seconding', 'voting', function($scope, profile, seconding, voting){
    $scope.profile = profile;
    $scope.seconding = seconding;
    $scope.voting = voting;
    
    $scope.classes = function(bookId){
        var c = [];
        if(voting.votedOn(bookId)){
            c.push('seconded');
            if(voting.extraVotedOn(bookId)){
                c.push('plus-one');
            }
        }
        return c;
    };
    
    $scope.votingSort = function(book){
        return voting.votes(book.id) * -1;
    };
}]);

app.controller('NominationsController', ['$scope', 'search', '$interval', 'nominations', '$document', function($scope, search, $interval, nominations, $document){
    $scope.search = search;
    $scope.query = '';
    $scope.nominations = nominations;
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
}]);

app.factory('profile', function(){
    return {
        name: 'Caitlin',
        extraVotes: 5,
        uid: 2508813
    };
});

app.factory('search', ['$http', function($http){

    var service = {
        loading: false,
        loaded: false,
        results: {
            query: '',
            books: []
        },
        clear: function() {
            service.results = {
                    query: '',
                    books: []
                };
            service.loaded = false;
        },
        search: function(query){
            if(query.length > 0){
                service.loading = true;
                $http({method: 'GET', url: '/search/' + encodeURIComponent(query)}).
                    success(function(data){
                        service.loaded = true;
                        service.results = data;
                        service.loading = false;
                    }).
                    error(function(){});
            } else {
                service.clear();
            }
        }
    };
    return service;
}]);

app.factory('nominations', function(){
    return nominations = {
        books: []
    };
});

app.factory('voting', function(){
    var votes = {
        12345: {
            total: 5,
            voted: true,
            extra: false
        },
        12346: {
            total: 5,
            voted: false,
            extra: false
        },
        12347: {
            total: 2,
            voted: false,
            extra: false
        },
        12348: {
            total: 8,
            voted: true,
            extra:true
        }
    };
    var voting = {};
    voting.usedExtraVotes = function(){
        var num = 0;
        $.each( votes, function(i, vote){
            if(vote.extra){
                num++;
            }
        });
        return num;
    };
    voting.vote = function(bookId){
        if(voting.votedOn(bookId)){
            votes[bookId].voted = false;
            votes[bookId].total--;
            if(voting.extraVotedOn(bookId)){
                votes[bookId].extra = false;
                votes[bookId].total--;
            }
        } else {
            votes[bookId].voted = true;
            votes[bookId].total++;
        }
    };
    voting.extraVote = function(bookId){
        if(voting.votedOn(bookId)){
            if(votes[bookId].extra){
                votes[bookId].extra = false;
                votes[bookId].total--;
            } else {
                votes[bookId].extra = true;
                votes[bookId].total++;
            }
        }
    };
    voting.votedOn = function(bookId){
        return( votes[bookId].voted);
    };
    voting.extraVotedOn = function(bookId){
        return( votes[bookId].extra);
    };
    voting.votes = function(bookId){
        return votes[bookId].total;
    };
    return voting;
});

app.factory('seconding', function(){
    return {
        genre: 'Horror',
        active: true,
        books: [{
            title: 'Book 1',
            id: 12345,
            rating: 4.03,
            imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
            url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
        },
        {
            title: 'Book 2',
            id: 12346,
            rating: 3.03,
            imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
            url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
        },
        {
            title: 'Book 3',
            id: 12347,
            rating: 3.77,
            imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
            url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
        },
        {
            title: 'Book 4',
            id: 12348,
            rating: 5,
            imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
            url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
        }]
    };
});