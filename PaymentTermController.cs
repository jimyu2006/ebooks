using Kendo.Mvc.Extensions;
using Reckon.CashbookCore.Contracts;
using Reckon.CashbookCore.Contracts.Commands.Contacts;
using Reckon.CashbookCore.Contracts.Commands.PaymentTerm;
using Reckon.CashbookCore.Contracts.QueryModel.PaymentTerm;
using Reckon.Core.BCLExtensions;
using Reckon.Security;
using Reckon.Service.DTO;
using ReckonOne.Web.Areas.Core.Extensions;
using ReckonOne.Web.Areas.Core.Models.Dialog;
using ReckonOne.Web.Areas.Core.Models.Invoices;
using ReckonOne.Web.Areas.Core.Models.PaymentTerm;
using ReckonOne.Web.Controllers;
using ReckonOne.Web.Helpers;
using ReckonOne.Web.Infrastructure;
using ReckonOne.Web.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using ContactType = Reckon.Service.DTO.ContactType;


namespace ReckonOne.Web.Areas.Core.Controllers
{
    public class PaymentTermController : BaseController
    {

        private const string PAYMENTTERMNAME_DUPLICATE_ERROR = "A payment term with this name already exists.";
        private const string PAYMENTTERM_EXTRA = " (default)";

        private readonly IPaymentTermCommandService _paymentTermCommandService;
        private readonly IInvoiceQueryService _invoiceQueryService;
        private readonly IContactsQueryService _contactsQueryService;
        private readonly ICashbookSettings _cashbookSettings;
        private readonly IPaymentTermQueryService _paymentTermQueryService;
        private readonly IPermissionsManager _permissionsManager;
        private readonly ICashbookQueryService _cashbookQueryService;
        private readonly ICompanyQueryService _companyQueryService;

        public PaymentTermController(IPermissionsManager permissionsManager,
                                    IPaymentTermQueryService paymentTermQueryService,
                                    IPaymentTermCommandService PaymentTermCommandServic,
                                    IInvoiceQueryService InvoiceQueryService,
                                    IContactsQueryService contactsQueryService,
                                    ICashbookSettings cashbookSettings,
                                    ICashbookQueryService cashbookQueryService,
                                    ICompanyQueryService companyQueryService)
        {
            _permissionsManager = permissionsManager;
            _paymentTermQueryService = paymentTermQueryService;
            _paymentTermCommandService = PaymentTermCommandServic;
            _invoiceQueryService = InvoiceQueryService;
            _contactsQueryService = contactsQueryService;
            _cashbookSettings = cashbookSettings;
            _cashbookQueryService = cashbookQueryService;
            _companyQueryService = companyQueryService;
        }

        /// <summary>
        /// Invoice payment terms list
        /// </summary>
        /// <returns>Invoice payment terms list in accordion for Sale Preferences </returns>
        [ReckonAuthorize(UserPermission.Terms_View)]
        public ActionResult Index()
        {
            var paymentTerms = _paymentTermQueryService.GetPaymentTerms(UserContext.GetCurrentCashbookId()).OrderBy(o => o.TermName);
            var model = new PaymentTermListViewModel(paymentTerms, _permissionsManager);
            return View(model);
        }

        /// <summary>
        /// Retrun Payment terms based on the cashbookId and customerId
        /// </summary>
        /// <param name="invoiceId"></param>
        /// <param name="customerId"></param>
        /// <returns>PaymentTerm List</returns>
        [ReckonAuthorize(UserPermission.Invoices_View, UserPermission.Invoices_PrintEmail, UserPermission.Terms_View)]
        public JsonResult GetPaymentTermsList(Guid? invoiceId, Guid? customerId)
        {
            var cashbookId = UserContext.GetCurrentCashbookId();
            var invoiceIdValue = invoiceId == null ? Guid.Empty : invoiceId.Value;
            var customerIdValue = customerId == null ? Guid.Empty : customerId.Value;
            var contact = _contactsQueryService.GetContactDetail(cashbookId, customerIdValue);

            var paymentTermId = Guid.Empty.ToString();
            var paymmentTerms = _paymentTermQueryService.GetPaymentTerms(cashbookId,
                                                            customerIdValue,
                                                            contact == null ? true : contact.IsCustomer,
                                                            contact == null ? false : !contact.IsCustomer)
                                                            .Where(p => p.IsActive == true).ToList();

            var defaultPaymentTerm = paymmentTerms.FirstOrDefault(p => p.IsDefault);

            if (contact != null && contact.TermId.HasValue)
            {
                defaultPaymentTerm = _paymentTermQueryService.GetPaymentTermById(contact.TermId.Value);
            }

            if (defaultPaymentTerm != null)
            {
                var selectedPayment = paymmentTerms.FirstOrDefault(p => p.PaymentTermId == defaultPaymentTerm.PaymentTermId);
                if (selectedPayment != null)
                {
                    selectedPayment.TermName += PAYMENTTERM_EXTRA;
                }
            }

            return Json(paymmentTerms, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Return customer's paymentTerm setting
        /// </summary>
        /// <param name="invoiceId"></param>
        /// <param name="customerId"></param>
        /// <param name="invoiceDate"></param>
        /// <param name="isChangeCustomer"></param>
        /// <returns>PaymentTermDueDate viewmodel contains a paymentterm, paymenttermlist and payment duedate</returns>
        [HttpPost]
        [ReckonAuthorize(UserPermission.Invoices_View, UserPermission.Invoices_PrintEmail, UserPermission.Terms_View)]
        public JsonResult GetPaymentTerm(Guid invoiceId, Guid customerId, DateTime invoiceDate, bool isChangeCustomer)
        {
            var cashbookId = UserContext.GetCurrentCashbookId();

            var invoice = (invoiceId as Guid?).HasRealValue() ? _invoiceQueryService.GetInvoiceById(invoiceId) : null;

            var contact = _contactsQueryService.GetContactDetail(cashbookId, customerId);

            var isCustomer = contact == null || contact.IsCustomer;

            Guid paymentTermId = contact == null ? Guid.Empty : contact.TermId.GetValueOrDefault(Guid.Empty);

            var paymmentTerms = _paymentTermQueryService.GetPaymentTerms(cashbookId,
                                                            customerId,
                                                            isCustomer,
                                                            !isCustomer)
                                                            .Where(p => p.IsActive).ToList();

            PaymentTermDetail paymentTerm;

            //Set default paymentterm to cashbook's default
            PaymentTermDetail defaultPaymentTerm = paymmentTerms.FirstOrDefault(p => p.IsDefault);

            if (isChangeCustomer)
            {
                if (paymentTermId != Guid.Empty)
                {
                    paymentTerm = _paymentTermQueryService.GetPaymentTermById(paymentTermId);
                    if (paymentTerm.IsActive)
                    {
                        paymentTerm.TermName += PAYMENTTERM_EXTRA;
                    }
                    else
                    {
                        paymentTerm = new PaymentTermDetail();
                    }
                }
                else
                {
                    paymentTerm = defaultPaymentTerm ?? new PaymentTermDetail();
                }
            }
            else
            {
                var invoiceViewModel = new InvoiceDetailViewModel(invoice, _cashbookSettings, CountrySettings, _cashbookQueryService, _companyQueryService);
                if (invoiceViewModel.PaymentTermId == null)
                {
                    if (paymentTermId != Guid.Empty)
                    {
                        paymentTerm = _paymentTermQueryService.GetPaymentTermById(paymentTermId);
                        //If customer has a paymentterm then set customer's paymentterm as default
                        if (paymentTerm.IsActive)
                        {
                            defaultPaymentTerm = paymentTerm;
                        }
                    }
                    else
                    {
                        paymentTerm = defaultPaymentTerm ?? new PaymentTermDetail();
                    }
                }
                else
                {
                    paymentTerm = _paymentTermQueryService.GetPaymentTermById(invoiceViewModel.PaymentTermId.Value);
                }
            }

            if (defaultPaymentTerm != null)
            {
                var selectedPayment = paymmentTerms.FirstOrDefault(p => p.PaymentTermId == (defaultPaymentTerm.PaymentTermId));
                if (selectedPayment != null)
                {
                    selectedPayment.TermName += PAYMENTTERM_EXTRA;
                }
            }

            DateTime paymentDueDate = DateTime.MinValue;
            if (invoice != null && paymentTerm != null)
            {
                paymentDueDate = _paymentTermQueryService.GetPaymentTermDueDate(cashbookId,
                                                                                paymentTerm.PaymentTermId,
                                                                                invoice.InvoiceDate,
                                                                                 UserContext.LoginName);
            }
            else
            {
                if (invoiceDate != DateTime.MinValue && paymentTerm != null)
                {
                    paymentDueDate = _paymentTermQueryService.GetPaymentTermDueDate(cashbookId,
                                                                                    paymentTerm.PaymentTermId,
                                                                                    invoiceDate,
                                                                                     UserContext.LoginName);
                }
            }

            DateTime? dueDate = null;
            if (paymentDueDate != DateTime.MinValue)
            {
                dueDate = paymentDueDate;
            }

            var creditLimit = _contactsQueryService.GetAvailableCreditLimit(new AvailableCreditLimitRequest()
            {
                CashbookID = cashbookId,
                CustomerSupplierID = customerId,
                IsCustomer = isCustomer,
                ExcludesTransaction = true,
                TransactionID = Guid.Empty,
                TransactionType = CreditTransactionType.NotSet
            });

            // Return data using Newtonsoft.Net so dates will be in ISO 8601 format.
            return new JsonNetResult()
            {
                Data = new PaymentTermInfo()
                {
                    HasCreditLimit = creditLimit.HasCreditLimit,
                    AvailableBalance = creditLimit.AvailableCredit,
                    CustomerCreditLimit = creditLimit.CreditLimit,
                    PaymentDueDate = dueDate,
                    PaymentTerm = paymentTerm,
                    PaymentTerms = paymmentTerms
                }
            };
        }



        /// <summary>
        /// Return customer's paymentTerm setting
        /// </summary>
        /// <param name="termId"></param>
        /// <param name="issueDate"></param>
        /// <returns>payment duedate</returns>
        [ReckonAuthorize(UserPermission.Invoices_View, UserPermission.Invoices_PrintEmail,  UserPermission.Terms_View)]
        public JsonResult GetPaymentTermDueDate(Guid termId, DateTime issueDate)
        {
            var dueDate = _paymentTermQueryService.GetPaymentTermDueDate(UserContext.GetCurrentCashbookId(), termId, issueDate, UserContext.LoginName);
            if (dueDate == DateTime.MinValue)
            {
                return Json(null, JsonRequestBehavior.AllowGet);
            }
            
            // Return date using Newtonsoft.Net so it will be in ISO 8601 format.
            return new JsonNetResult() { Data = dueDate };
        }


        [ReckonAuthorize(UserPermission.Terms_View)]
        public JsonResult GetPaymentTerm(Guid paymentTermId)
        {
            var paymentTerm = _paymentTermQueryService.GetPaymentTermById(paymentTermId);

            return Json(paymentTerm, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Return a blank paymentterm view for the lightbox
        /// </summary>
        /// <param name="name"></param>
        /// <param name="isInLightBoxMode"></param>
        /// <returns>a blank paymentterm view</returns>
        [ReckonAuthorize(UserPermission.Terms_AddEdit)]
        public ActionResult CreatePaymentTerm(string name, bool IsFromListMode = false)
        {
            PaymentTermLightBoxViewModel paymentTermViewModel = new PaymentTermLightBoxViewModel(_permissionsManager)
            {
                CashbookId = UserContext.GetCurrentCashbookId(),
                TermName = name,
                NetDueDay = 14,
                IssuedWithinDays = 0
            };
            paymentTermViewModel.IsActive = true;
            paymentTermViewModel.PaymentTermStatus = PaymentTermStatus.Active;
            paymentTermViewModel.IsInLightboxMode = true;
            paymentTermViewModel.IsFromListMode = IsFromListMode;
            paymentTermViewModel.IsCreate = true;

            return PartialView("Create", paymentTermViewModel);
        }


        /// <summary>
        /// Return an existing paymentterm view from the paymentTermId
        /// </summary>
        /// <param name="paymentTermId"></param>
        /// <returns>an existing paymentterm view</returns>
        [ReckonAuthorize(UserPermission.Terms_View)]
        public ActionResult EditPaymentTerm(Guid paymentTermId)
        {
            var paymentDetail = _paymentTermQueryService.GetPaymentTermById(paymentTermId);
            PaymentTermLightBoxViewModel paymentTermViewModel = new PaymentTermLightBoxViewModel(paymentDetail, _permissionsManager);
            paymentTermViewModel.IsInLightboxMode = true;
            paymentTermViewModel.IsFromListMode = true;
            paymentTermViewModel.IsCreate = false;

            return PartialView("Create", paymentTermViewModel);
        }


        /// <summary>
        /// To check the paymentterm name already exists or not
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="contactType"></param>
        /// <param name="termname"></param>
        /// <returns>text</returns>
        public ActionResult CheckPaymentTerm(string TermName, Guid paymentTermId)
        {
            try
            {
                var paymentTerms = _paymentTermQueryService.GetPaymentTerms(UserContext.GetCurrentCashbookId());

                if (TermName.HasValue())
                {
                    var existedTerm = paymentTerms.Where(p => p.TermName.ToLower() == TermName.ToLower()).FirstOrDefault();

                    if (existedTerm != null)
                    {
                        if (existedTerm.PaymentTermId != paymentTermId)
                        {
                            return Json(false, JsonRequestBehavior.AllowGet);
                        }
                    }
                    return Json(true, JsonRequestBehavior.AllowGet);
                }
            }
            catch (InvalidOperationException)
            {
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Save payment term
        /// </summary>
        /// <param name="paymentTermViewModel"></param>
        /// <returns>GenericPaymentTermResponse</returns>
        [HttpPost]
        [ReckonAuthorize(UserPermission.Terms_AddEdit)]
        public ActionResult SavePaymentTerm(PaymentTermLightBoxViewModel paymentTermViewModel)
        {

            GenericPaymentTermResponse response = new GenericPaymentTermResponse();
            try
            {
                var checkResult = CheckPaymentTerm(paymentTermViewModel.TermName, paymentTermViewModel.PaymentTermId);
                if ((bool)((JsonResult)checkResult).Data)
                {
                    response = paymentTermViewModel.IsCreate ?
                        _paymentTermCommandService.SavePaymentTerm(Map(paymentTermViewModel)) : 
                        _paymentTermCommandService.UpdatePaymentTerm(Map(paymentTermViewModel));
                }
                else
                {
                    ModelState.AddModelError("TermName", PAYMENTTERMNAME_DUPLICATE_ERROR);
                    return JsonError(ModelState, paymentTermViewModel);
                }

            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = ex.Message;
            }
            return Json(response);
        }

        /// <summary>
        /// Delete the selected paymentterms
        /// </summary>
        /// <param name="paymentTermIds">list of paymentterms</param>
        /// <returns>JsonSuccess or error message</returns>
        [ReckonAuthorize(UserPermission.Terms_Delete)]
        public JsonResult DeletePaymentTerms(List<PaymentTermViewModel> model)
        {
            var result = _paymentTermCommandService.DeletePaymentTerms(new DeletePaymentTermCommand(UserContext.GetCurrentCashbookId(),
                            model.Select(p => p.PaymentTermId).ToList())).ToList();

            if (result.TrueForAll(r => r.Success))
            {
                return JsonSuccess();
            }

            var dialog = BuildBulkErrorMessage(result, model, "delete");

            return ModelState.ToJsonError(dialog.FormattedErrors, dialog.EntityIds);
        }

        /// <summary>
        /// Active selected paymentterms
        /// </summary>
        /// <param name="model">list of paymentterms</param>
        /// <returns>JsonSuccess or error message</returns>
        [ReckonAuthorize(UserPermission.Terms_AddEdit)]
        public JsonResult ActivePaymentTermsStatus(List<PaymentTermViewModel> model)
        {
            return ChangePaymentTermsStatus(model, TermStatus.Active);
        }

        /// <summary>
        /// Inactive selected paymentterms
        /// </summary>
        /// <param name="model">list of paymentterms</param>
        /// <returns>JsonSuccess or error message</returns>
        [ReckonAuthorize(UserPermission.Terms_AddEdit)]
        public JsonResult InActivePaymentTermsStatus(List<PaymentTermViewModel> model)
        {
            return ChangePaymentTermsStatus(model, TermStatus.Inactive);
        }

        private JsonResult ChangePaymentTermsStatus(List<PaymentTermViewModel> model, TermStatus status)
        {
            var result = _paymentTermCommandService.ChangePaymentTermStatus(new PaymentTermStatusCommand(
                            UserContext.GetCurrentCashbookId(),
                            model.Select(p => p.PaymentTermId).ToList(),
                            status)).ToList();

            if (result.TrueForAll(r => r.Success))
            {
                return JsonSuccess();
            }

            var dialog = BuildBulkErrorMessage(result, model, status.ToString());

            return ModelState.ToJsonError(dialog.FormattedErrors, dialog.EntityIds);
        }

        /// <summary>
        /// Build error message of bulk action
        /// </summary>
        /// <param name="result">list of GenericPaymentTermResponse</param>
        /// <param name="model">list of PaymentTermViewModel</param>
        /// <param name="Action">action name</param>
        /// <returns>Concated error message</returns>
        private BulkOperationErrorDialogViewModel BuildBulkErrorMessage(List<GenericPaymentTermResponse> result, List<PaymentTermViewModel> model, string Action)
        {
            var errorItems = BulkOperationErrorDialogViewModel.CreateErrorDialogModel(result, model, Action,
                "payment term", "payment terms", res => res.PaymentTermId, viewmodel => viewmodel.PaymentTermId,
                (res, viewmodel) => new BulkOperationErrorItem
                {
                    EntityId = res.PaymentTermId.ToString(),
                    EntityName = viewmodel.TermName,
                    ErrorCode = res.ErrorCode,
                    ErrorMessage = res.Message
                });

            return errorItems;
        }

        /// <summary>
        /// Map PaymentTermLightBoxViewModel To PaymentTermDetail
        /// </summary>
        /// <param name="term"></param>
        /// <returns>PaymentTermDetail</returns>
        private PaymentTermDetail Map(PaymentTermLightBoxViewModel term)
        {
            return new PaymentTermDetail()
            {
                PaymentTermId = term.PaymentTermId,
                CashbookID = term.CashbookId == null ? Guid.Empty : term.CashbookId.Value,
                TermName = term.TermName,
                TermDescription = term.TermDescription,
                ContactType = term.ContactType,
                IsActive = term.IsActive,
                IsDefault = term.IsDefault,
                IsDueDateWeekend = term.IsDueDateWeekend,
                IsIssuedWithinDays = term.IsIssuedWithinDays,
                IssuedWithinDays = term.IssuedWithinDays,
                NetDueDay = term.NetDueDay,
                NetDueDaySelection = (NetDueDateOptions)term.NetDueDaysSelection,
                IsShowInInvoice = (term.ContactType == ContactType.Customer || term.ContactType == ContactType.Both),
                IsShowInBill = (term.ContactType == ContactType.Supplier || term.ContactType == ContactType.Both)
            };
        }
    }
}