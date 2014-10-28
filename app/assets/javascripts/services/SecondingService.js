(function() {
	function SecondingService($http, $q) {
		var self = this;

		self.vote = function(nominationId, roundId) {
			return $http.post('/rounds/' + roundId + '/nominations/' + nominationId + '/vote');
		};

		self.unvote = function(nominationId, roundId) {
			return $http.delete('/rounds/' + roundId + '/nominations/' + nominationId + '/vote');
		};

		self.extra = function(nominationId, roundId) {
			return $http.post('/rounds/' + roundId + '/nominations/' + nominationId + '/extra');
		};

		self.unextra = function(nominationId, roundId) {
			return $http.delete('/rounds/' + roundId + '/nominations/' + nominationId + '/extra');
		};
	}

	angular
		.module('BookClubFiction')
		.service('SecondingService', SecondingService);
})();
