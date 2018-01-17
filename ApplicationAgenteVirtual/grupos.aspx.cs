using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class grupos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Grupos"])
                Server.Transfer("logon.aspx", true);

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
                int index = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = GrupoGridView.Rows[index];

                //Instanciando classe de conexão
                ObterConexao obterConexao = new ObterConexao();

                //Abrindo conexão para execução da procedure
                var con = obterConexao.ObtendoConexao();

                //Abrindo um novo DataReader
                SqlDataReader readerGrupo;

                //Informando qual comando (procedure) irá executar e qual conexão
                SqlCommand grupo = new SqlCommand("sp_Del_Grupo", con);

                //Populando os parametros para executação da procedure
                grupo.Parameters.AddWithValue("@IDGrupo", GrupoGridView.DataKeys[index].Value.ToString());

                //Informando qual o tipo de comando
                grupo.CommandType = CommandType.StoredProcedure;

                //Abre conexão                    
                con.Open();

                //Executa o comando
                readerGrupo = grupo.ExecuteReader();

                bool msgErro = false;

                while (readerGrupo.Read())
                {
                    msgErro = Convert.ToBoolean(readerGrupo[0].ToString());
                }

                //Fecha conexão
                con.Close();

                if (msgErro)
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaErro('Erro','Existem usuários atrelados a esse grupo.');", true);
            }

            GrupoGridView.DataBind();
        }

        protected void btnSalvarGrupo_Click(object sender, EventArgs e)
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            if (string.IsNullOrEmpty(hdnIDGrupo.Value))
            {
                //Informando qual comando (procedure) irá executar e qual conexão
                SqlCommand grupo = new SqlCommand("sp_Ins_Grupo", con);

                //Populando os parametros para executação da procedure
                grupo.Parameters.AddWithValue("@Descricao", txtdescricaoGrupo.Text);

                //Informando qual o tipo de comando
                grupo.CommandType = CommandType.StoredProcedure;

                //Abre conexão                    
                con.Open();

                //Executa o comando
                grupo.ExecuteReader();

                //Fecha conexão
                con.Close();

                //menssagem de sucesso
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo','Salvo com sucesso!');", true);

                LimparTela();
            }
            else
            {
                //Informando qual comando (procedure) irá executar e qual conexão
                SqlCommand grupo = new SqlCommand("sp_Upt_Grupo", con);

                //Populando os parametros para executação da procedure
                grupo.Parameters.AddWithValue("@Descricao", txtdescricaoGrupo.Text);
                grupo.Parameters.AddWithValue("@IDGrupo", hdnIDGrupo.Value);

                //Informando qual o tipo de comando
                grupo.CommandType = CommandType.StoredProcedure;

                //Abre conexão                    
                con.Open();

                //Executa o comando
                grupo.ExecuteReader();

                //Fecha conexão
                con.Close();

                //menssagem de sucesso
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo','Salvo com sucesso!');", true);

                LimparTela();
            }

            GrupoGridView.DataBind();
        }

        private void LimparTela()
        {
            hdnIDGrupo.Value = "";
            txtdescricaoGrupo.Text = "";
        }
    }
}