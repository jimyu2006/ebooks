using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;

namespace Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers
{
    public static class ContactScenarioHelper
    {
        public static CustomerSupplierDetail Current
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("CurrentContact"))
                    return (CustomerSupplierDetail)ScenarioContext.Current["CurrentContact"];
                else
                    throw new ArgumentOutOfRangeException("CurrentContact not found in scenario context");
            }
            set { ScenarioContext.Current.Set<CustomerSupplierDetail>(value, "CurrentContact"); }
        }

        public static CustomerSupplierDetail Original
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("OriginalContact"))
                    return (CustomerSupplierDetail)ScenarioContext.Current["OriginalContact"];
                else
                    throw new ArgumentOutOfRangeException("OriginalContact not found in scenario context");
            }
            set { ScenarioContext.Current.Set<CustomerSupplierDetail>(value, "OriginalContact"); }
        }

        public static List<CustomerSupplierDetail> AllContacts
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("AllContacts"))
                    return (List<CustomerSupplierDetail>)ScenarioContext.Current["AllContacts"];
                else
                    throw new ArgumentOutOfRangeException("AllContacts not found in scenario context");
            }
            set { ScenarioContext.Current.Set<List<CustomerSupplierDetail>>(value, "AllContacts"); }
        }
    }
}