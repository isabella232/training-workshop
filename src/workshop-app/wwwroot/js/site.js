$(document).ready(function () {
	$(document).ajaxError(function (event, request, settings, thrownError) {
		$("#msg").append("<li>Error requesting page " + settings.url + ": " + thrownError + "</li>");
		console.log(request);
	});

	$("#btn-slackpost").click(function () {
		var userField = $("#slackUser");
		var slackUser = userField.val();
		if (slackUser.trim() === "") {
			alert("Please enter your Slack username");
			userField.focus();
		} else {
			var url = slackPostUrl.replace("(slackUser)", userField.val());
			$.get(url);
			$(this)
				.after("<h1>DONE!</h1>")
				.remove();
		}
	});
});

