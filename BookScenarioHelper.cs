using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;

namespace Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers
{
    public static class BookScenarioHelper
    {
        public static CashbookDetail CurrentBook
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("CurrentBook"))
                    return (CashbookDetail)ScenarioContext.Current["CurrentBook"];
                else
                    throw new ArgumentOutOfRangeException("CurrentBook not found in scenario context");
            }
            set { ScenarioContext.Current.Set<CashbookDetail>(value, "CurrentBook"); }
        }

        public static CashbookSettingDetail CurrentSettings
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("CurrentSettings"))
                    return (CashbookSettingDetail)ScenarioContext.Current["CurrentSettings"];
                else
                    throw new ArgumentOutOfRangeException("CurrentSetting not found in scenario context");
            }
            set { ScenarioContext.Current.Set<CashbookSettingDetail>(value, "CurrentSettings"); }
        }
    }
}