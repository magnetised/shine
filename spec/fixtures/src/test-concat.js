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

/*! I do want to see this comment
 *
 */

// I don't want to see this comment
$(function(long_variable_name) {
	long_variable_name.find('all');
	var why_use_a_longer_name = window;
	var my_callback_function = (function(isnt_it_lovely) {
		return function(a_window_event) {
			isnt_it_lovely.clicko(a_window_event);
		};
	})(this);
	if (long_variable_name.shouting()) {
		// ow my ears
		long_variable_name.dont_shout();
	} else {
		long_variable_name.i_cant_hear_you();
	}
	why_use_a_longer_name.setTimeout(my_callback_function, 1000);
})(Monkey);

