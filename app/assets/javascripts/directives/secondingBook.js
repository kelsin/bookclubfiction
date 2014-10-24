(function(){
  // 5 minutes, 60 seconds
  var lockTime = 5 * 60,
      π = Math.PI;
  function secondingBook(RoundService) {
    return {
      restrict: 'E',
      scope: { nomination: '=', vote: '=', status: '=', extra: '='},
      templateUrl: 'book/seconding.html',
      link: function(scope, element, attrs) {
        var loader = element.find('.timer-loader');
        var border = element.find('.timer-border');
        var created = scope.nomination.extra ? scope.nomination.extra_created_at : scope.nomination.vote_created_at;
        var voteAge = scope.nomination.current - created;
        var start = Math.round(new Date().getTime() / 1000);
        var α = 360/lockTime * voteAge;

        var tick = function(){
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

        scope.$on('timerTick', tick);
        tick();
      }
    };
  }

  angular
    .module('BookClubFiction')
    .directive('secondingbook', secondingBook);
})();
