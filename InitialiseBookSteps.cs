using System;
using System.Collections.Generic;
using System.Linq;
using Cashbook.Web.BusinessLogic;
using Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Reckon.Cashbook.DataClasses;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Cashbook.Web.UnitTests.SpecFlow.StepDefinitions
{
    [Binding]
    public class InitialiseBookSteps
    {
        [Given(@"the OnlineUserID is ""(.*)""")]
        public void GivenTheOnlineUserIDIs(string p0)
        {
            //Assert.IsFalse(string.IsNullOrEmpty(p0), "OnlineUserID cannot be empty or null");
            //PortalHandler ph = new PortalHandler();
            //InitialiseBookHelper.CashbookUserID = ph.GetCashbookUserIDFromOnlineUserID(p0);
            //InitialiseBookHelper.OnlineUserID = p0;
            //Assert.IsTrue(InitialiseBookHelper.CashbookUserID != Guid.Empty, "Failed to add new user or fail to get existing user ID");
        }
        
        [Given(@"the OnlineClientID is (.*)")]
        public void GivenTheOnlineClientIDIs(int p0)
        {
            //Assert.IsTrue(p0 > 0, "OnlineClientID cannot be 0");
            //PortalHandler ph = new PortalHandler();
            //InitialiseBookHelper.CashbookClientID = ph.GetCashbookClientIDFromOnlineClientID(p0.ToString());
            //InitialiseBookHelper.OnlineClientID = p0.ToString();
            //Assert.IsTrue(InitialiseBookHelper.CashbookClientID != Guid.Empty, "Failed to add new client or fail to get existing client ID");
        }
        
        [Given(@"the CountryCode is ""(.*)""")]
        public void GivenTheCountryCodeIs(string p0)
        {
            //string error = null;
            //Assert.IsFalse(string.IsNullOrEmpty(p0), "CountryCode cannot be empty or null");
            //MasterDataHandler dh = new MasterDataHandler();
            //InitialiseBookHelper.CountryID = dh.GetCountryIDFromCode(p0, out error);
            //Assert.IsTrue(InitialiseBookHelper.CountryID != Guid.Empty, "Failed to get countryID");
        }
        
        [Given(@"the business template is ""(.*)""")]
        public void GivenTheBusinessTemplateIs(string p0)
        {
            //string error = null;
            //Assert.IsFalse(string.IsNullOrEmpty(p0), "Business template name cannot be empty or null");
            //Assert.IsTrue(InitialiseBookHelper.CountryID != Guid.Empty, "Failed to get countryID");
            //MasterDataHandler dh = new MasterDataHandler();
            //var results = dh.GetAllBusinessTemplates(InitialiseBookHelper.CountryID, out error);
            //if (results != null && results.Count > 0)
            //{
            //    var template = results.FirstOrDefault(i => i.BusinessTypeName == p0);
            //    if (template != null)
            //    {
            //        InitialiseBookHelper.BusinessTemplateID = template.BusinessTemplateID;
            //        var accounts = dh.GetChartOfAccountsForBusinessTemplate(InitialiseBookHelper.CountryID,
            //            InitialiseBookHelper.BusinessTemplateID, out error);
            //        if (accounts != null)
            //            InitialiseBookHelper.MasterAccounts =
            //                accounts.Select(i => i.MasterAccountingCategoryID).ToList();
            //    }
            //}
            //else
            //{
            //    Assert.Fail("No business template for " + p0);
            //}
            //Assert.IsTrue(InitialiseBookHelper.BusinessTemplateID != Guid.Empty, "Failed to get business template ID");
        }

        [Given(@"the accounts are")]
        public void GivenTheAccountsAre(Table table)
        {
            //var bankAccounts = table.CreateSet<NewCashbookBankAccountDetail>();
            //InitialiseBookHelper.BankAccounts = (List<NewCashbookBankAccountDetail>) bankAccounts;
        }

        [Given(@"the following parameters set for the new book")]
        public void GivenTheFollowingParametersSetForTheNewBook(Table table)
        {
            //InitialiseBookHelper.BookDetail = table.CreateInstance<CashbookDetail>();
        }

        [When(@"I call the CreateNewBook method")]
        public void WhenICallTheCreateNewBookMethod()
        {
            //string error = null;
            //InitialiseBookHelper.BookDetail.CashbookID = Guid.NewGuid();
            //InitialiseBookHelper.BookDetail.DateCreated = DateTime.Now;
            //InitialiseBookHelper.BookDetail.DateCreatedUTC = new DateTimeOffsetDetail();
            //InitialiseBookHelper.BookDetail.DateCreatedUTC.Value = InitialiseBookHelper.BookDetail.DateCreated;
            ////newDetail.BookStartDate = CashbookDetails.CashbookStartDate;
            //InitialiseBookHelper.BookDetail.CountryID = InitialiseBookHelper.CountryID;
            ////newDetail.BookName = CashbookDetails.Description;
            ////newDetail.FinancialYearStartDay = CashbookDetails.FinancialYearStartDay;
            ////newDetail.FinancialYearStartMonth = (int)CashbookDetails.FinancialYearStartMonth;
            ////newDetail.IndustryCodeID = CashbookDetails.IndustryCodeID;
            //InitialiseBookHelper.BookDetail.OwnerReckonClientID = InitialiseBookHelper.CashbookClientID;
            ////newDetail.AccountingBasis = CashbookDetails.AccountingMethod;
            //InitialiseBookHelper.BookDetail.BusinessTemplateID = InitialiseBookHelper.BusinessTemplateID;
            //InitialiseBookHelper.BookDetail.BankAccounts = InitialiseBookHelper.BankAccounts;
            //InitialiseBookHelper.BookDetail.BookSharing = new List<NewCashbookShareDetail>();
            //InitialiseBookHelper.BookDetail.BookSharing.Add(new NewCashbookShareDetail() { OnlineUserID = InitialiseBookHelper.OnlineUserID, AccessLevel = CashbookShareDetail.Action.Full });
            ////newDetail.DoTrackTax = CashbookDetails.DoTrackTax;

            ////clean
            //CashbookHandler cdh = new CashbookHandler();
            //List<ProvisioningBookDetail> books = cdh.GetBookByUserID(InitialiseBookHelper.OnlineUserID, out error);
            //if (books != null && books.Count > 0)
            //{
            //    var existingBook = books.FirstOrDefault(i => i.BookName == InitialiseBookHelper.BookDetail.Description);
            //    if (string.IsNullOrEmpty(error) && existingBook != null)
            //        cdh.DeleteCashbook(existingBook.BookID, InitialiseBookHelper.CashbookUserID, out error);
            //}
            //if (string.IsNullOrEmpty(error))
            //{
            //    //add book
            //    CashbookHandler dh = new CashbookHandler();
            //    dh.AddCashbook(InitialiseBookHelper.BookDetail, InitialiseBookHelper.CashbookUserID, out error);
            //}
            //Assert.IsTrue(string.IsNullOrEmpty(error), "Fail to create a book");
        }


        [Then(@"the bookID can not be empty")]
        public void ThenTheBookIDCanNotBeEmpty()
        {
            //string error = null;
            //CashbookHandler cdh = new CashbookHandler();
            //List<ProvisioningBookDetail> books = cdh.GetBookByUserID(InitialiseBookHelper.OnlineUserID, out error);
            //if (books != null && books.Count > 0)
            //{
            //    var existingBook = books.FirstOrDefault(i => i.BookName == InitialiseBookHelper.BookDetail.Description);
            //    if (existingBook != null)
            //        InitialiseBookHelper.BookID = existingBook.BookID;
            //}
            //Assert.IsTrue(InitialiseBookHelper.BookID != Guid.Empty, "Book created with errors");
        }

    }
}
