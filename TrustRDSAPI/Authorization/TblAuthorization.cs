using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace TrustRDSAPI.Authorization
{
    public class TblAuthorization: AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if(actionContext.Request.Headers.Authorization==null)
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            }
            else
            {
                string token = actionContext.Request.Headers.Authorization.ToString();
                //string decodeToken = Encoding.UTF8.GetString(Convert.FromBase64String(token));
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Found);
                //actionContext.Response.StatusCode = HttpStatusCode.Found;
            }
            base.OnAuthorization(actionContext);
        }
        //public override Task OnAuthorizationAsync(HttpActionContext actionContext, System.Threading.CancellationToken cancellationToken)
        //{

        //    var principal = actionContext.RequestContext.Principal as ClaimsPrincipal;

        //    if (!principal.Identity.IsAuthenticated)
        //    {
        //        return Task.FromResult<object>(null);
        //    }

        //    var userName = principal.FindFirst(ClaimTypes.Name).Value;
        //    //var userAllowedTime = principal.FindFirst("userAllowedTime").Value;

        //    //if (currentTime != userAllowedTime)
        //    //{
        //    //    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, "Not allowed to access...bla bla");
        //    //    return Task.FromResult<object>(null);
        //    //}

        //    //User is Authorized, complete execution
        //    return Task.FromResult<object>(null);

        //}

    }
}