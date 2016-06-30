using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;

namespace Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers
{
    public static class ErrorHandlingScenarioHelper
    {
        public static string ErrorString
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("ErrorString"))
                    return (string)ScenarioContext.Current["ErrorString"];
                else
                    throw new ArgumentOutOfRangeException("ExpectedError not found in scenario context");
            }

            set { ScenarioContext.Current.Set<string>(value, "ErrorString"); }
        }
    }
}
