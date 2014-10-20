(function(){
  function votes(RoundService) {
    return {
      restrict: 'E',
      replace: false,
      controller: function($scope, RoundService) {
        $scope.round = RoundService;
      },
      link: function(scope, element, attrs) {
        var container = d3.select(element[0]);

        var x = d3.scale.linear().range([0, 640]);

        var chart = container.append("ul").attr("class", "chart");

        scope.$watch('round.current.votes', function(votes) {
          if(votes) {
            x.domain([0, d3.max(votes, function(v) {
              return v.value;
            })]);

            var vote = chart.selectAll('li').data(votes, function(v) {
              return v.id;
            });

            vote.enter().append('li')
              .style('width', '0')
              .style('background-color', '#3d905e')
              .style('height', '20px');

            vote.exit().remove();

            vote
              .text(function(v) { return v.book.title + ', ' + v.book.rating + ', ' + v.value + ' votes'; })
              .transition()
              .style('width', function(v) {
                return x(v.value) + 'px';
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
