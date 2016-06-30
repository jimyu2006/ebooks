using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reckon.UI.Web;
using ReckonOne.Web.Models;

namespace ReckonOne.Web.Areas.Core.Extensions
{
    public static class ModelStateExtensions
    {
        private static string GetErrorMessageOrException(ModelError error)
        {
            return error.ErrorMessage ?? (error.Exception != null ? error.Exception.Message : null);
        }

        /// <summary>
        /// Extract flatten error message array
        /// ["error1", "error2", "error3"...]
        /// </summary>
        /// <param name="modelState">ModelState</param>
        /// <returns>flattern errors</returns>
        public static string[] ExtractErrorMessages(this ModelStateDictionary modelState)
        {
            return modelState.Keys.SelectMany(k => modelState[k].Errors).Select(GetErrorMessageOrException).ToArray();
        }

        /// <summary>
        /// Formats the model state errors by key for validation summary
        /// </summary>
        /// <param name="modelState">ModelState</param>
        /// <returns></returns>
        public static KeyValuePair<string, ModelError>[] CustomSerialiseErrors(this ModelStateDictionary modelState)
        {
            return (from key in modelState.Keys
                from modelError in modelState[key].Errors
                select new KeyValuePair<string, ModelError>(key, modelError)).ToArray();
        }

        /// <summary>
        /// Adds multiple errors to the ModelState at once.
        /// All errors are added under the same error key.
        /// Equivalent to calling AddModelError once foreach error in errors.
        /// </summary>
        /// <param name="modelState">this ModelState for extension method</param>
        /// <param name="errorKey">Key value to apply for all errors to be added to ModelState</param>
        /// <param name="errors">IEnumerable&lt;string&gt; of errors to be added to the ModelState</param>
        public static void AddModelErrors(this ModelStateDictionary modelState, string errorKey, IEnumerable<string> errors)
        {
            foreach (var error in errors)
                modelState.AddModelError(errorKey, error);
        }

        /// <summary>
        /// Adds multiple errors to the ModelState at once.
        /// All errors are added under the constant error key "server".
        /// Equivalent to calling AddModelError once foreach error in errors.
        /// </summary>
        /// <param name="modelState">this ModelState for extension method</param>
        /// <param name="errors">IEnumerable&lt;string&gt; of errors to be added to the ModelState</param>
        public static void AddModelErrors(this ModelStateDictionary modelState, IEnumerable<string> errors)
        {
            AddModelErrors(modelState, ModelStateErrorKeys.Server, errors);
        }

        /// <summary>
        /// Convert a single string to a JsonError by adding it to the model state
        /// Uses the existing JsonAnswer.Error method to return the string in the correct json format 
        /// as expected by ajax calls from the UI
        /// </summary>
        /// <param name="modelState"></param>
        /// <param name="error"></param>
        /// <param name="resultsData"></param>
        /// <returns></returns>
        public static JsonResult ToJsonError(this ModelStateDictionary modelState, string error, object resultsData = null)
        {
            return modelState.ToJsonError(new List<string>{ error }, resultsData);
        }

        /// <summary>
        /// Convert a IEnumerable&lt;string&gt; of errors to a JsonError by adding it to the model state 
        /// Uses the existing JsonAnswer.Error method to return the string in the correct json format 
        /// as expected by ajax calls from the UI
        /// </summary>
        /// <param name="modelState"></param>
        /// <param name="errors"></param>
        /// <param name="resultsData"></param>
        /// <returns></returns>
        public static JsonResult ToJsonError(this ModelStateDictionary modelState, IEnumerable<string> errors, object resultsData = null)
        {
            modelState.AddModelErrors(errors);
            return JsonAnswer.Error(modelState, resultsData);
        }
    }
}