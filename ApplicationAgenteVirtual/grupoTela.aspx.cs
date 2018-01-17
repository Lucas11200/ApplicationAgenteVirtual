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
    public partial class grupoTela : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Grupos Tela"])
                Server.Transfer("logon.aspx", true);
            else if (!Page.IsPostBack)
            {
                CarregarGrupos();
                CarregarTelas();
            }
        }

        private void CarregarGrupos()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerGrupo;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdGrupo = new SqlCommand("sp_Sel_Grupo", con);

            //Informando qual o tipo de comando
            cmdGrupo.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerGrupo = cmdGrupo.ExecuteReader();

            List<Grupo> listGrupo = new List<Grupo>();

            //Populando primeira linha do DropDownList com "Selecione..."
            Grupo grupoSelecione = new Grupo();

            grupoSelecione.IDGrupo = 0;
            grupoSelecione.Descricao = "Selecione...";

            listGrupo.Add(grupoSelecione);

            while (readerGrupo.Read())
            {
                Grupo grupo = new Grupo();

                grupo.IDGrupo = (int)readerGrupo[0];
                grupo.Descricao = readerGrupo[1].ToString();

                listGrupo.Add(grupo);

            }

            ddlGrupo.DataSource = listGrupo;
            ddlGrupo.DataValueField = "IDGrupo";
            ddlGrupo.DataTextField = "Descricao";
            ddlGrupo.DataBind();

            //Fecha conexão
            con.Close();
        }

        private void CarregarTelas()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerTela;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdTela = new SqlCommand("sp_Sel_Tela", con);

            //Informando qual o tipo de comando
            cmdTela.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerTela = cmdTela.ExecuteReader();

            List<Tela> listTela = new List<Tela>();

            while (readerTela.Read())
            {
                Tela tela = new Tela();

                tela.IDTela = (int)readerTela[0];
                tela.Descricao = readerTela[1].ToString();

                listTela.Add(tela);

            }

            chkListTela.DataSource = listTela;
            chkListTela.DataValueField = "IDTela";
            chkListTela.DataTextField = "Descricao";
            chkListTela.DataBind();

            //Fecha conexão
            con.Close();
        }

        protected void ddlGrupo_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (ListItem item in chkListTela.Items)
            {
                if (item.Selected)
                    item.Selected = false;
            }

            if (ddlGrupo.SelectedValue != "0")
            {
                btnSalvarGrupoTela.Visible = true;
                divTelas.Visible = true;

                CheckedGrupoTela();
            }
            else
            {
                btnSalvarGrupoTela.Visible = false;
                divTelas.Visible = false;
            }
        }

        private void CheckedGrupoTela()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerGrupoTela;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdGrupoTela = new SqlCommand("sp_Sel_GrupoTela", con);

            //Informando qual o tipo de comando
            cmdGrupoTela.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdGrupoTela.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdGrupoTela.Parameters.AddWithValue("@IDGrupo", Convert.ToInt16(ddlGrupo.SelectedValue));

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerGrupoTela = cmdGrupoTela.ExecuteReader();

            while (readerGrupoTela.Read())
            {
                string idTela = readerGrupoTela[1].ToString();

                foreach (ListItem item in chkListTela.Items)
                {
                    if (item.Value == idTela)
                        item.Selected = true;
                }

            }

            //Fecha conexão
            con.Close();
        }

        protected void btnSalvarGrupoTela_Click(object sender, EventArgs e)
        {
            LimparGrupoTela(Convert.ToInt16(ddlGrupo.SelectedValue));

            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdGrupoTela = new SqlCommand("sp_Ins_GrupoTela", con);
            //Informando qual o tipo de comando
            cmdGrupoTela.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            foreach (ListItem item in chkListTela.Items)
            {
                if (item.Selected)
                {
                    //Limpa os parametros
                    cmdGrupoTela.Parameters.Clear();

                    //Populando os parametros para executação da procedure
                    cmdGrupoTela.Parameters.AddWithValue("@IDGrupo", ddlGrupo.SelectedValue);
                    cmdGrupoTela.Parameters.AddWithValue("@IDTela", item.Value);

                    //Executa o comando
                    cmdGrupoTela.ExecuteNonQuery();
                }
            }

            //Fecha conexão
            con.Close();

            Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo!','Salvo com sucesso');", true);
        }

        private void LimparGrupoTela(int idGrupo)
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdGrupoTela = new SqlCommand("sp_Del_GrupoTela", con);
            //Informando qual o tipo de comando
            cmdGrupoTela.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Limpa os parametros
            cmdGrupoTela.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdGrupoTela.Parameters.AddWithValue("@IDGrupo", idGrupo);

            //Executa o comando
            cmdGrupoTela.ExecuteNonQuery();

            //Fecha conexão
            con.Close();

        }
    }
}