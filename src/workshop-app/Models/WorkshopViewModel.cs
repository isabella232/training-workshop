using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace workshop_app.Models
{
	public class WorkshopViewModel
	{
		public string StudentName { get; set; }
		public string EnvironmentName { get; set; }
		public bool ShowSlackButton { get; set; }
		public bool ShowProceedMessage { get; set; }
		public string ProceedMessage { get; set; }
		public string PostUrl { get; set; }
		public string ReleaseNumber { get; set; }
		public string CloudBaseUrl { get; set; }
		public string AppVersion { get; internal set; }
		public ReleaseInfo ReleaseInfo { get; internal set; }
	}
}
