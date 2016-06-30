using System;
using TechTalk.SpecFlow;
using Cashbook.Controllers;
using Reckon.Cashbook.DataClasses;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Reckon.Cashbook.Controllers;
using Reckon.Cashbook.DataClasses.EventClasses;
using System.Collections.Generic;
using Cashbook.Web.UnitTests.SpecFlow.ScenarioHelpers;
using Reckon.DataClasses;
using TechTalk.SpecFlow.Assist;
using System.Linq;
using Reckon.Domain.Model;
using System.Collections.ObjectModel;
using Reckon.UnitTests.Data;
using Reckon.Data.ORM.Mock.Context;
using Reckon.Domain.Model.Core;
using Reckon.Service.Messages.Requests;
using Reckon.Service.Messages.Responses;
using Reckon.Service.DTO;
using Reckon.ErrorValidation;
using Reckon.Plugin.Factories;

namespace Cashbook.Web.UnitTests.SpecFlow.StepDefinitions
{
    [Binding]
    public class MockProvisioningSteps
    {
        FactoryRepository _factory;
        List<PurchasedModuleDetail> _purchasedModuleDetail = new List<PurchasedModuleDetail>();
        ICollection<EvoReportForGroupDto> _expectedReport = null;

        [Given(@"the book contains the following modules")]
        public void GivenTheBookContainsTheFollowingModules(Table table)
        {
            _purchasedModuleDetail = table.CreateSet<PurchasedModuleDetail>() as List<PurchasedModuleDetail>;

            foreach (var item in _purchasedModuleDetail)
            {
                item.ExpiryDate = DateTime.Now.AddDays(1);
            }

        }

        public void SetupDomainObjects()
        {
            ProvisioningScenarioHelper.Cashbook = new MockCashbookData().Data[0];
            ProvisioningScenarioHelper.Country = new MockCountryData().Data[0];
            ProvisioningScenarioHelper.RoleDisplayData = new MockRoleDisplayData().Data;
            ProvisioningScenarioHelper.ActionRules = new MockActionRuleData(null).Data;
            ProvisioningScenarioHelper.ActionTypes = new MockActionTypeData().Data;

            ProvisioningScenarioHelper.PermissionVisibilityActions = new MockPermissionVisibilityActionData(ProvisioningScenarioHelper.ActionTypes).Data;
            ProvisioningScenarioHelper.PermissionTypes = new MockPermissionTypeData().Data;

            ProvisioningScenarioHelper.ActionModules = new MockActionModuleData(true).Data.ToList();

            ProvisioningScenarioHelper.ProvisioningUserDetails = new List<ProvisioningUserDetail>();
            ProvisioningScenarioHelper.ProvisioningUserDetails.Add(new ProvisioningUserDetail() { UserID = "9000-1", AccountName = "Unit Test (Admin)", RoleID = Reckon.Domain.Model.UserRole.Administrator, Username = "Unit Test (Admin)" });
            ProvisioningScenarioHelper.ProvisioningUserDetails.Add(new ProvisioningUserDetail() { UserID = "9000-2", AccountName = "Unit Test (Owner)", RoleID = Reckon.Domain.Model.UserRole.Owner, Username = "Unit Test (Admin)" });
            ProvisioningScenarioHelper.ProvisioningUserDetails.Add(new ProvisioningUserDetail() { UserID = "9000-3", AccountName = "Unit Test (User)", RoleID = Reckon.Domain.Model.UserRole.User, Username = "Unit Test (Admin)" });

            ProvisioningScenarioHelper.Roles = new List<Reckon.Domain.Model.Role>();
            ProvisioningScenarioHelper.Roles.Add(new Reckon.Domain.Model.Role()
            {
                CashbookID = MockCashbookData.CashbookID1,
                RoleID = (int)Reckon.Domain.Model.UserRole.Administrator,
                PermissionTypes = ProvisioningScenarioHelper.PermissionTypes
            });

            Reckon.Domain.Model.User user = new Reckon.Domain.Model.User()
            {
                ID = MockUsersData.User1,
                OnlineUserID = ProvisioningScenarioHelper.ProvisioningUserDetails[0].UserID,
                Roles = ProvisioningScenarioHelper.Roles
            };
            ProvisioningScenarioHelper.User = user;
            ProvisioningScenarioHelper.MasterReportGroups = new MockMasterReportGroups().Data;

        }

        private void SetupUnitOfWorkObjects()
        {
            _factory.GetFactory<Country>().GetRepository().Add(ProvisioningScenarioHelper.Country);
            _factory.GetFactory<Reckon.Domain.Model.Cashbook>().GetRepository().Add(ProvisioningScenarioHelper.Cashbook);
            _factory.GetFactory<Reckon.Domain.Model.User>().GetRepository().Add(ProvisioningScenarioHelper.User);

            foreach (var role in ProvisioningScenarioHelper.RoleDisplayData)
                _factory.GetFactory<RoleDisplayGroup>().GetRepository().Add(role);

            foreach (var at in ProvisioningScenarioHelper.ActionTypes)
                _factory.GetFactory<ActionType>().GetRepository().Add(at);

            foreach (var ar in ProvisioningScenarioHelper.ActionRules)
                _factory.GetFactory<ActionRule>().GetRepository().Add(ar);

            foreach (var pt in ProvisioningScenarioHelper.PermissionTypes)
                _factory.GetFactory<PermissionType>().GetRepository().Add(pt);

            foreach (var am in ProvisioningScenarioHelper.ActionModules)
                _factory.GetFactory<ActionModule>().GetRepository().Add(am);

            foreach (var pm in _purchasedModuleDetail)
                _factory.GetFactory<PurchasedModuleDetail>().GetRepository().Add(pm);

            foreach (var pva in ProvisioningScenarioHelper.PermissionVisibilityActions)
                _factory.GetFactory<Reckon.Domain.Model.PermissionVisibilityAction>().GetRepository().Add(pva);

            _factory.GetFactory<ProvisioningUserDetail>().GetRepository().Add(ProvisioningScenarioHelper.ProvisioningUserDetails);
        }

        [When(@"Getting reports for group '(.*)'")]
        public void WhenGettingReportsForGroup(string p0)
        {
            SetupDomainObjects();

            _factory = new FactoryRepository(RepositoryType.Mock);

            using (new MockUnitOfWorkScope(true))
            {
                SetupUnitOfWorkObjects(); 

                EvoReportsForGroupGetRequest request = new EvoReportsForGroupGetRequest()
                {
                    CashbookID = MockCashbookData.CashbookID1,
                    ReportGroupID = ProvisioningScenarioHelper.MasterReportGroups.Where(x => x.DisplayName == p0).FirstOrDefault().MasterReportGroupID,
                    CountryID = ProvisioningScenarioHelper.Country.ID,
                    CashbookUserID = MockUsersData.User1
                };

                Reckon.Service.ServiceImplementations.EvoReportService reportService = new Reckon.Service.ServiceImplementations.EvoReportService();

                List<ValidationError> validationErrors = new List<ValidationError>();
                _expectedReport = reportService.GetReportGroupsFromTask(request, out validationErrors, _factory);
            }
        }

        [Then(@"i should get the following reports")]
        public void ThenIShouldGetTheFollowingReports(Table table)
        {
            List<ReportResult> expectedReports = new List<ReportResult>();
            foreach (var report in _expectedReport)
            {
                expectedReports.Add(new ReportResult() { ReportName = report.DisplayName });
            }

            var reports = table.CreateSet<ReportResult>() as List<ReportResult>;
            
            var result = reports.Where(y => expectedReports.Any(z => z.ReportName == y.ReportName));
            if (result.Count() != expectedReports.Count())
            {
                Assert.Fail("Reports expected.");
            }
        }

        class ReportResult
        {
            public string ReportName { get; set; }
        }
    }
}
