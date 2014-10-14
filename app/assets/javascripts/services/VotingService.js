(function() {
  function VotingService($http) {
    var self = this;

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

    self.usedExtraVotes = function(){
        var num = 0;
        $.each( votes, function(i, vote){
            if(vote.extra){
                num++;
            }
        });
        return num;
    };
    self.vote = function(bookId){
        if(self.votedOn(bookId)){
            votes[bookId].voted = false;
            votes[bookId].total--;
            if(self.extraVotedOn(bookId)){
                votes[bookId].extra = false;
                votes[bookId].total--;
            }
        } else {
            votes[bookId].voted = true;
            votes[bookId].total++;
        }
    };
    self.extraVote = function(bookId){
        if(self.votedOn(bookId)){
            if(votes[bookId].extra){
                votes[bookId].extra = false;
                votes[bookId].total--;
            } else {
                votes[bookId].extra = true;
                votes[bookId].total++;
            }
        }
    };
    self.votedOn = function(bookId){
        return( votes[bookId].voted);
    };
    self.extraVotedOn = function(bookId){
        return( votes[bookId].extra);
    };
    self.votes = function(bookId){
        return votes[bookId].total;
    };
  }

  angular
    .module('BookClubFiction')
    .service('VotingService', VotingService);
})();
