$(function() {
	$('#start-parse').click(function() {
	  $('body').addClass('loading');
	});

	$('#start-download').click(function() {
	  $('body').addClass('loading');
	});

	if ($('.survey-details').length > 0) {
		$('body').removeClass('loading');
	}
});