using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cashbook.Web.UnitTests.SpecFlow.StepDefinitions
{
    public static class StepMethodExtensions
    {
        public static Guid AsGuid(this string source)
        {
            return string.IsNullOrEmpty(source) ? Guid.Empty : new Guid(source);
        }

        public static DateTime AsDateTime(this string source)
        {
            DateTime result;
            string dateString = source.ToLower();
            int offset;

            if (dateString.Contains("today") || dateString.Contains("now"))
            {
                int.TryParse(dateString.Replace("today", null).Replace("now", null).Replace("+", null), out offset);
                result = DateTime.Today.AddDays(offset);
            }
            else
                DateTime.TryParse(dateString, out result);

            return result;
        }

        public static bool AsBoolean(this string source)
        {
            bool result = false;

            if (!string.IsNullOrEmpty(source))
            {
                if (source.Trim().ToLower() == "true")
                    result = true;
                else if (source.Trim().ToLower() == "false")
                    result = false;
                else
                    throw new ArgumentOutOfRangeException("Unknown boolean value " + source + " found");
            }

            return result;
        }
    }
}
