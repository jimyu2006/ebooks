using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;

namespace Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers
{
    public static class AccountingCategoryScenarioHelper
    {
        public static AccountingCategoryDetail Current
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("CurrentAccount"))
                    return (AccountingCategoryDetail)ScenarioContext.Current["CurrentAccount"];
                else
                    throw new ArgumentOutOfRangeException("CurrentAccount not found in scenario context");
            }
            set { ScenarioContext.Current.Set<AccountingCategoryDetail>(value, "CurrentAccount"); }
        }

        public static AccountingCategoryDetail Original
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("OriginalAccount"))
                    return (AccountingCategoryDetail)ScenarioContext.Current["OriginalAccount"];
                else
                    throw new ArgumentOutOfRangeException("OriginalAccount not found in scenario context");
            }
            set { ScenarioContext.Current.Set<AccountingCategoryDetail>(value, "OriginalAccount"); }
        }

        public static List<AccountingCategoryDetail> AllAccounts
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("AllAccounts"))
                    return (List<AccountingCategoryDetail>)ScenarioContext.Current["AllAccounts"];
                else
                    throw new ArgumentOutOfRangeException("AllAccounts not found in scenario context");
            }
            set { ScenarioContext.Current.Set<List<AccountingCategoryDetail>>(value, "AllAccounts"); }
        }
    }
}