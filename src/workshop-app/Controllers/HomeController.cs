﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using workshop_app.Models;

namespace workshop_app.Controllers
{
	public class HomeController : Controller
	{
		private readonly IConfiguration _config;
		private readonly ILogger<HomeController> _logger;
		private readonly HttpClient _httpClient;

		public HomeController(ILogger<HomeController> logger, IConfiguration configuration, HttpClient httpClient)
		{
			_config = configuration;
			_logger = logger;
			_httpClient = httpClient;
		}

		public IActionResult Index()
		{
			var model = new WorkshopViewModel()
			{
				StudentName = _config["Workshop:StudentName"],
				EnvironmentName = _config["Workshop:Environment"],
			};

			if (!model.StudentName.Contains("Unknown") 
				&& !model.EnvironmentName.Contains("Unknown")
				&& !string.IsNullOrEmpty(_config["Workshop:SlackUrl"])
				)
			{
				model.ShowProceedMessage = true;
				switch (model.EnvironmentName.ToLower())
				{
					case "development":
						model.ProceedMessage = "Woohoo, you're getting close!<br />Please proceed to your test environment application.";
						break;
					case "test":
						model.ProceedMessage = "Woohoo, you're getting close!<br />Please proceed to your production environment application.";
						break;
					case "production":
						model.ProceedMessage = "Woohoo, you made it!<br /><br />Enter your Slack username below and click the button to post your success to Slack.";
						model.ShowSlackButton = true;
						model.PostUrl = Url.Action("PostToSlack", "Home", new { slackUser = "(slackUser)" });
						break;
				}
			}

			return View(model);
		}

		public async Task<IActionResult> PostToSlack(string slackUser)
		{
			var response = await _httpClient.PostAsJsonAsync(_config["Workshop:SlackUrl"], new { text = $":tada: :tada: <@{slackUser}> successfully completed the Octopus 101 training workshop. :tada: :tada:" });
			return Content(response.StatusCode.ToString());
		}

		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public IActionResult Error()
		{
			return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
		}
	}
}