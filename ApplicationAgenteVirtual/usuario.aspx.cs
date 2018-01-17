using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.DirectoryServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class usuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Usuários"])
                Server.Transfer("logon.aspx", true);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtEmailUsuario.Text))
            {
                DirectoryEntry acesso = AcessoAD();

                DirectorySearcher pesquisa = new DirectorySearcher(acesso);
                pesquisa.Filter = "(&(ObjectClass=user)(mail=" + txtEmailUsuario.Text + "))";

                pesquisa.PropertiesToLoad.Add("GivenName");
                pesquisa.PropertiesToLoad.Add("mail");
                pesquisa.PropertiesToLoad.Add("sn");
                pesquisa.PropertiesToLoad.Add("sAMAccountName");

                SearchResult resEnt = pesquisa.FindOne();

                string nome = "";
                string sobrenome = "";
                string email = "";
                string userName = "";

                if (resEnt != null)
                {
                    //Verifique se obteve um valor - nem todas as propriedades são obrigatórias e 
                    //se não estiverem preenchidas, elas podem ser "nulas"
                    if (resEnt.Properties["GivenName"] != null && resEnt.Properties["GivenName"].Count > 0)
                        nome = resEnt.Properties["GivenName"][0].ToString();

                    if (resEnt.Properties["sn"] != null && resEnt.Properties["sn"].Count > 0)
                        sobrenome = resEnt.Properties["sn"][0].ToString();

                    if (resEnt.Properties["mail"].Count > 0)
                        email = resEnt.Properties["mail"][0].ToString();

                    if (resEnt.Properties["sAMAccountName"].Count > 0)
                        userName = resEnt.Properties["sAMAccountName"][0].ToString();

                    lblNomeUsuario.Text = nome + " " + sobrenome + " " + "[" + email + "] - " + userName.ToLower();
                    hdnUserName.Value = userName;

                    divGrupos.Visible = true;
                    CarregarGrupos();
                }
                else
                {
                    lblNomeUsuario.Text = "Usuário não encontrado";
                    divGrupos.Visible = false;
                }
            }
            else
            {
                lblNomeUsuario.Text = "Usuário não encontrado";
                divGrupos.Visible = false;
            }

            lblNomeUsuario.Font.Bold = true;
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

        protected void btnSalvarGrupo_Click(object sender, EventArgs e)
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            bool validacao = true;

            if (string.IsNullOrEmpty(hdnUserName.Value))
            {
                validacao = false;
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaAviso('Atenção','Usuário não digitado!');", true);
            }
            else if (ddlGrupo.SelectedIndex == 0)
            {
                validacao = false;
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaAviso('Atenção','Grupo não selecionado!');", true);
            }

            if (validacao)
            {
                //Abrindo um novo DataReader
                SqlDataReader readerUsuarioGrupo;

                //Informando qual comando (procedure) irá executar e qual conexão
                SqlCommand usuarioGrupo = new SqlCommand("sp_Ins_UsuarioGrupo", con);

                //Populando os parametros para executação da procedure
                usuarioGrupo.Parameters.AddWithValue("@UserName", hdnUserName.Value);
                usuarioGrupo.Parameters.AddWithValue("@IDGrupo", ddlGrupo.SelectedValue);

                //Informando qual o tipo de comando
                usuarioGrupo.CommandType = CommandType.StoredProcedure;

                //Abre conexão                    
                con.Open();

                //Executa o comando
                readerUsuarioGrupo = usuarioGrupo.ExecuteReader();

                while (readerUsuarioGrupo.Read())
                {
                    if (Convert.ToBoolean(readerUsuarioGrupo[0]))
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaErro('Atenção','" + readerUsuarioGrupo[1].ToString() + "');", true);
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo!','Salvo com sucesso');", true);
                        Limpar();
                    }
                }

                //Fecha conexão
                con.Close();
                UsuarioGrupoGridView.DataBind();
            }
        }

        private void Limpar()
        {
            txtEmailUsuario.Text = "";
            divGrupos.Visible = false;
            lblNomeUsuario.Text = "";
            hdnUserName.Value = "";
            ddlGrupo.ClearSelection();
        }

        protected void UsuarioGrupoGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Deletar")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = UsuarioGrupoGridView.Rows[index];

                //Instanciando classe de conexão
                ObterConexao obterConexao = new ObterConexao();

                //Abrindo conexão para execução da procedure
                var con = obterConexao.ObtendoConexao();

                //Informando qual comando (procedure) irá executar e qual conexão
                SqlCommand grupo = new SqlCommand("sp_Del_UsuarioGrupo", con);

                //Populando os parametros para executação da procedure
                grupo.Parameters.AddWithValue("@IDUsuario", UsuarioGrupoGridView.DataKeys[index].Value.ToString());

                //Informando qual o tipo de comando
                grupo.CommandType = CommandType.StoredProcedure;

                //Abre conexão                    
                con.Open();

                //Executa o comando
                grupo.ExecuteReader();

                //Fecha conexão
                con.Close();

                Limpar();

                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo!', 'Usuario excluido com sucesso!');", true);
            }

            UsuarioGrupoGridView.DataBind();
        }

        private static DirectoryEntry AcessoAD()
        {
            string LDAP = Convert.ToString(ConfigurationManager.AppSettings["ServerLDAP"]);
            string userLDAP = Convert.ToString(ConfigurationManager.AppSettings["UserLDAP"]);
            string passwordLDAP = Convert.ToString(ConfigurationManager.AppSettings["SenhaLDAP"]);

            //DirectoryEntry entry = new DirectoryEntry("LDAP://DC=DOMAIN, DC=local");
            DirectoryEntry entry = new DirectoryEntry("LDAP://" + LDAP, userLDAP, passwordLDAP);
            return entry;

        }
    }
}
