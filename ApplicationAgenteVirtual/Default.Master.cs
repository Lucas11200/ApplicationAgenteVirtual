using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Principal;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class Default : System.Web.UI.MasterPage
    {
        MembershipUser usuario;

        protected void Page_Load(object sender, EventArgs e)
        {
            ValidarLogin();

            lblCampanhaSelecionada.Text = Session["CampanhaSelecionada"] != null ? Session["CampanhaSelecionada"].ToString() : "";

            lblrodape.Text = "&#169 "+ DateTime.Today.Year + " - System Marketing Consulting Ltda.";
        }

        private void ValidarLogin()
        {
            //Como obter o usuário logado na máquina via aplicação web            
            string userNameWindows = this.Context.Request.LogonUserIdentity.Name;
            userNameWindows = userNameWindows.Replace("SYSTEMMKT\\", "");

            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerUsuario;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdUsuario = new SqlCommand("sp_Sel_UsuarioLogin", con);

            //Informando qual o tipo de comando
            cmdUsuario.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdUsuario.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdUsuario.Parameters.AddWithValue("@Usuario", userNameWindows);

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerUsuario = cmdUsuario.ExecuteReader();
            bool usuarioCadastrado = false;
            Session["Acionamento"] = false;
            Session["Campanha"] = false;
            Session["Definir Público"] = false;
            Session["Grupos"] = false;
            Session["Grupos Tela"] = false;
            Session["Histórico"] = false;
            Session["Usuários"] = false;
            Session["NomeUsuario"] = userNameWindows;

            while (readerUsuario.Read())
            {
                usuarioCadastrado = true;

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Acionamento")
                {
                    btnAcionamento.Visible = true;
                    Session["Acionamento"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Campanha")
                {
                    btnCampanha.Visible = true;
                    Session["Campanha"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Definir Público")
                {
                    btnDefinirPublico.Visible = true;
                    Session["Definir Público"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Grupos")
                {
                    btnUsuarios.Visible = true;
                    btnGrupo.Visible = true;
                    Session["Grupos"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Grupos Tela")
                {
                    btnUsuarios.Visible = true;
                    btnGrupoTela.Visible = true;
                    Session["Grupos Tela"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Histórico")
                {
                    btnHistorico.Visible = true;
                    Session["Histórico"] = true;
                }

                if (readerUsuario[1] != null && readerUsuario[1].ToString() == "Usuários")
                {
                    btnUsuarios.Visible = true;
                    btnGerenciar.Visible = true;
                    Session["Usuários"] = true;
                }

            }

            //Fecha conexão
            con.Close();

            if (!usuarioCadastrado)
                Server.Transfer("logon.aspx", true);
        }
    }
}