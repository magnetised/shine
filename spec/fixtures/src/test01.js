var Outside = {
	run: function(house_warming_party) {
		var c = (function(something, party) {
			return function() {
				party.police();
				something.close_and_die();
			};
		})(this, house_warming_party);
	}
};
