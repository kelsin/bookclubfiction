(function(){
  function voteSort(a, b){
    var diff = b.value - a.value;
    if(diff === 0){
      return b.book.rating - a.book.rating;
    } else {
      return diff;
    }
  }

  function votes(RoundService) {
    return {
      restrict: 'E',
      replace: false,
      controller: function($scope, RoundService) {
        $scope.round = RoundService;
      },
      link: function(scope, element, attrs) {
        var container = d3.select(element[0]);

        var x = d3.scale.linear().range([0, 100]);

        var chart = container.append("ul").attr("class", "chart");

        scope.$watch('round.current.votes', function(votes) {
          if(votes) {
            x.domain([0, d3.max(votes, function(v) {
              return v.value;
            })]);

            var vote = chart.selectAll('li').data(votes, function(v) {
              return v.id;
            });

            var li = vote.enter().append('li');
            var div = li.append('div')
              .attr('class', 'book-standing')
              .style('width', '0');

            div.append('span')
              .attr('class','title')
              .text(function(v){ return v.book.title });
            div.append('span')
              .attr('class', 'rating')
              .text(function(v){return 'Average Rating: ' + v.book.rating });
            div.append('span')
              .attr('class','votes');

            vote.exit().remove();

            vote.sort(voteSort);
            vote.select('span.votes').text(function(v){return v.value + ' votes'; });
            vote.select('div.book-standing')
              .transition().duration(500)
              .styleTween('width', function(v, i, a) {
                var total = parseInt(window.getComputedStyle(this.parentNode,null).getPropertyValue("width"));
                var current = parseInt(a);
                var percent = Math.round(100 * current / total);
                return d3.interpolate(percent + '%', x(v.value) + '%');
              });
          }
        });
      }
    };
  }

  angular
    .module('BookClubFiction')
    .directive('votes', votes);
})();
