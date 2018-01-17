using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class cadGrupo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ObterConexao obterConexao = new ObterConexao();

            var conexao = obterConexao.ObtendoConexao();
        }

        public void GrupoGridView_RowCommand(Object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = GrupoGridView.Rows[index];

                hdnIDGrupo.Value = GrupoGridView.DataKeys[index].Value.ToString();
                txtdescricaoGrupo.Text = row.Cells[2].Text;
            }
            else if (e.CommandName == "Deletar")
            {

            }
        }

        protected void btnSalvarGrupo_Click(object sender, EventArgs e)
        {

        }
    }
}