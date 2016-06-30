using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;

namespace Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers
{
    public static class PaymentReceiptScenarioHelper
    {
        public static PaymentReceiptDetail Current
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("CurrentPaymentReceipt"))
                    return (PaymentReceiptDetail)ScenarioContext.Current["CurrentPaymentReceipt"];
                else
                    throw new ArgumentOutOfRangeException("CurrentPaymentReceipt not found in scenario context");
            }
            set { ScenarioContext.Current.Set<PaymentReceiptDetail>(value, "CurrentPaymentReceipt"); }
        }

        public static PaymentReceiptDetail Original
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("OriginalPaymentReceipt"))
                    return (PaymentReceiptDetail)ScenarioContext.Current["OriginalPaymentReceipt"];
                else
                    throw new ArgumentOutOfRangeException("OriginalPaymentReceipt not found in scenario context");
            }
            set { ScenarioContext.Current.Set<PaymentReceiptDetail>(value, "OriginalPaymentReceipt"); }
        }

        public static List<PaymentReceiptDetail> AllPaymentsReceipts
        {
            get
            {
                if (ScenarioContext.Current.ContainsKey("AllPaymentsReceipts"))
                    return (List<PaymentReceiptDetail>)ScenarioContext.Current["AllPaymentsReceipts"];
                else
                    throw new ArgumentOutOfRangeException("AllPaymentsReceipts not found in scenario context");
            }
            set { ScenarioContext.Current.Set<List<PaymentReceiptDetail>>(value, "AllPaymentsReceipts"); }
        }
    }
}
