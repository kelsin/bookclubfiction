(function() {
  function SecondingService($http) {
    var self = this;

    self.genre = 'Horror';
    self.active = true;

    self.books = [{
      title: 'Book 1',
      id: 12345,
      rating: 4.03,
      imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
      url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
    },{
      title: 'Book 2',
      id: 12346,
      rating: 3.03,
      imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
      url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
    },{
      title: 'Book 3',
      id: 12347,
      rating: 3.77,
      imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
      url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
    },{
      title: 'Book 4',
      id: 12348,
      rating: 5,
      imgUrl: 'https://d.gr-assets.com/books/1376392909m/28876.jpg',
      url: 'http://www.goodreads.com/book/show/28876.His_Majesty_s_Dragon'
    }];
  }

  angular
    .module('BookClubFiction')
    .service('SecondingService', SecondingService);
})();
