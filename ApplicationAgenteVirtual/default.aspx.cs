using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //string userNameWindows = this.Context.Request.LogonUserIdentity.Name;
            //lblTESTE.Text = userNameWindows.Replace("SYSTEMMKT\\", "");

            //var usuario = Membership.GetUser();
            //lblTESTE.Text = usuario.UserName;

        }
    }
}