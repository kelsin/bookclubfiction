(function(){
  // 5 minutes, 60 seconds
  var lockTime = 5 * 60;
  var π = Math.PI;

  function secondingBook(RoundService) {
    return {
      restrict: 'E',
      scope: { nomination: '=' },
      templateUrl: 'book/seconding.html',
      controller: 'VotesController',
      link: function(scope, element, attrs) {
        var loader = element.find('.timer-loader');
        var border = element.find('.timer-border');
        var created, voteAge, start, α, label = '';

        var update = function() {
          created = scope.nomination.extra ? scope.nomination.extra_created_at : scope.nomination.vote_created_at;
          voteAge = scope.nomination.current - created;
          start = Math.round(new Date().getTime() / 1000);
          α = 360/lockTime * voteAge;

          scope.locked = voteAge > lockTime;

          // Update text only if we're not locked
          if(!scope.locked) {
            scope.label = scope.nomination.extra ? 'Extra ' : '';
          }
        };

        var tick = function() {
          var current = Math.round(new Date().getTime() / 1000);
          var diff = current - start;

          scope.locked = (voteAge + diff) > lockTime;

          if(!scope.locked) {
            scope.untilLocked = moment((lockTime - diff - voteAge) * 1000).format('m:ss');
            α += 360 / lockTime;
            var r = -( α * π / 180 ),
                x = Math.sin( r ) * 125,
                y = Math.cos( r ) * - 125,
                mid = ( α > 180 ) ? 0 : 1,
                anim = 'M 0 0 v -125 A 125 125 1 '
                       + mid + ' 1 '
                       +  x  + ' '
                       +  y  + ' z';
            x = Math.round( x * 1000 ) / 1000;
            y = Math.round( y * 1000 ) / 1000;
            loader.attr( 'd', anim );
            border.attr( 'd', anim );
          }
        };

        // Update timer every second
        scope.$on('timerTick', tick);

        // Everytime the vote changes, update starting variables
        scope.$watch('nomination.current', update);

        // Initial setup
        update();
        tick();
      }
    };
  }

  angular
    .module('BookClubFiction')
    .directive('secondingbook', secondingBook);
})();
