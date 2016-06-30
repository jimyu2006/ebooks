using System;
using Reckon.Core.User;
using Reckon.Settings;
using ReckonOne.Web.Areas.Core.Extensions;
using ReckonOne.Web.Infrastructure;
using ReckonOne.Web.Models;
using System.Net;
using System.Web.Mvc;
using Reckon.Logging;

namespace ReckonOne.Web.Controllers
{
    [NoCache]
    [Authorize]
    public class BaseController : Controller
    {
        public ILog Log { get; set; }
        public IUserContext UserContext { get; set; }
        public ICountrySettings CountrySettings { get; set; }
        public ISettingsManager SettingsManager { get; set; }

        /// <summary>
        /// Return a JsonResult containing an error response
        /// </summary>
        /// <param name="messages">Messages object the client will use to inform the user of the errors and any actions that can be taken</param>
        /// <param name="resultsData">Any state data relevant to the operation</param>
        protected static JsonResult JsonError(ModelStateDictionary messages, object resultsData = null)
        {
            //stops only content/html error with the line "Bad Request" being returned.
            //Response.TrySkipIisCustomErrors = true;      //now set the web.config httpError to passthrough
            if (System.Web.HttpContext.Current != null)
            {
                System.Web.HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            }

            var data = JsonResponse.ErrorResponse(messages.CustomSerialiseErrors(), resultsData);

            return new JsonResult()
            {
                Data = data,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }

        // ***************************************************************************************************************************************************
        //--------------------------original code below - kept as overload so things don't break! ---------------------------------------------------------
        /// <summary>
        /// Return a JsonResult containing an error response
        /// </summary>
        /// <param name="messages">Messages object the client will use to inform the user of the errors and any actions that can be taken</param>
        /// <param name="resultsData">Any state data relevant to the operation</param>
        [Obsolete]
        protected static JsonResult JsonError(object messages, object resultsData = null)
        {
            //stops only content/html error with the line "Bad Request" being returned.
            //Response.TrySkipIisCustomErrors = true;      //now set the web.config httpError to passthrough
            if (System.Web.HttpContext.Current != null)
            {
                System.Web.HttpContext.Current.Response.StatusCode = (int) HttpStatusCode.BadRequest;
            }

            var data = JsonResponse.ErrorResponse(messages, resultsData);
            return new JsonResult()
            {
                Data = data,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }

        /// <summary>
        /// Return a JsonResult containing a success response
        /// </summary>
        /// <param name="resultsData">Any state data relevant to the operation</param>
        /// <param name="jsonResult">a json result(could be Json.net JsonNetResult)</param>
        protected static JsonResult JsonSuccess(object resultsData = null, JsonResult jsonResult = null)
        {
            var data = JsonResponse.SuccessResponse(resultsData);

            var result = jsonResult ?? new JsonResult();
            result.Data = data;
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;

            return result;
        }

    }
}