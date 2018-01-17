using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ApplicationAgenteVirtual
{
    public class ObterConexao
    {
        public SqlConnection ObtendoConexao()
        {
            SqlConnection con = new SqlConnection();
            con.ConnectionString = ConfigurationManager.ConnectionStrings["AgenteVirtualConfig"].ConnectionString;
            return con;
        }
    }
}