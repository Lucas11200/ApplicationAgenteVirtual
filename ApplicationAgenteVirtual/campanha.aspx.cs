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
    public partial class campanha : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Campanha"])
                Server.Transfer("logon.aspx", true);
            else if (!Page.IsPostBack)
            {
                CarregarClientes();
                CarregarOperacoes();
                CarregarCampanha();
            }
        }

        protected void ddlCliente_SelectedIndexChanged(object sender, EventArgs e)
        {
            CarregarOperacoes();
        }

        protected void ddlOperacao_SelectedIndexChanged(object sender, EventArgs e)
        {
            CarregarCampanha();
        }

        private void CarregarClientes()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerCliente;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdCliente = new SqlCommand("sp_Sel_Cliente", con);

            //Informando qual o tipo de comando
            cmdCliente.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerCliente = cmdCliente.ExecuteReader();

            List<Cliente> listCliente = new List<Cliente>();

            //Populando primeira linha do DropDownList com "Selecione..."
            Cliente clienteSelecione = new Cliente();

            clienteSelecione.IDCliente = 0;
            clienteSelecione.Descricao = "Selecione...";

            listCliente.Add(clienteSelecione);

            while (readerCliente.Read())
            {
                Cliente cliente = new Cliente();

                cliente.IDCliente = (int)readerCliente[0];
                cliente.Descricao = readerCliente[1].ToString();

                listCliente.Add(cliente);

            }

            ddlCliente.DataSource = listCliente;
            ddlCliente.DataValueField = "IDCliente";
            ddlCliente.DataTextField = "Descricao";
            ddlCliente.DataBind();

            //Fecha conexão
            con.Close();
        }

        private void CarregarOperacoes()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerOperacao;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdOperacao = new SqlCommand("sp_Sel_Operacao", con);

            //Informando qual o tipo de comando
            cmdOperacao.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdOperacao.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdOperacao.Parameters.AddWithValue("@IDCliente", Convert.ToInt16(ddlCliente.SelectedValue));

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerOperacao = cmdOperacao.ExecuteReader();

            List<Operacao> listOperacao = new List<Operacao>();

            //Populando primeira linha do DropDownList com "Selecione..."
            Operacao operacaoSelecione = new Operacao();

            operacaoSelecione.IDOperacao = 0;
            operacaoSelecione.Descricao = "Selecione...";

            listOperacao.Add(operacaoSelecione);

            while (readerOperacao.Read())
            {
                Operacao operacao = new Operacao();

                operacao.IDOperacao = (int)readerOperacao[0];
                operacao.Descricao = readerOperacao[1].ToString();

                listOperacao.Add(operacao);

            }

            ddlOperacao.DataSource = listOperacao;
            ddlOperacao.DataValueField = "IDOperacao";
            ddlOperacao.DataTextField = "Descricao";
            ddlOperacao.DataBind();

            //Fecha conexão
            con.Close();
        }

        private void CarregarCampanha()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerCampanha;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdCampanha = new SqlCommand("sp_Sel_Campanha", con);

            //Informando qual o tipo de comando
            cmdCampanha.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdCampanha.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdCampanha.Parameters.AddWithValue("@IDOperacao", Convert.ToInt16(ddlOperacao.SelectedValue));

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerCampanha = cmdCampanha.ExecuteReader();

            List<Campanha> listCampanha = new List<Campanha>();

            //Populando primeira linha do DropDownList com "Selecione..."
            Campanha campanhaSelecione = new Campanha();

            campanhaSelecione.IDCampanha = 0;
            campanhaSelecione.Descricao = "Selecione...";

            listCampanha.Add(campanhaSelecione);

            while (readerCampanha.Read())
            {
                Campanha campanha = new Campanha();

                campanha.IDCampanha = (int)readerCampanha[0];
                campanha.Descricao = readerCampanha[1].ToString();

                listCampanha.Add(campanha);

            }

            ddlCampanha.DataSource = listCampanha;
            ddlCampanha.DataValueField = "IDCampanha";
            ddlCampanha.DataTextField = "Descricao";
            ddlCampanha.DataBind();

            //Fecha conexão
            con.Close();
        }

        protected void btnSelecionarCampanha_Click(object sender, EventArgs e)
        {
            if (ddlCampanha.SelectedIndex > 0)
            {
                HiddenField hdnIDCampanhaSelecionada = Master.FindControl("hdnIDCampanhaSelecionada") as HiddenField;
                Label lblCampanhaSelecionada = Master.FindControl("lblCampanhaSelecionada") as Label;
                Label divCampanha = Master.FindControl("divCampanha") as Label;

                Session["IDCampanhaSelecionada"] = ddlCampanha.SelectedValue;
                Session["CampanhaSelecionada"] = ddlCampanha.SelectedItem.Text;

                hdnIDCampanhaSelecionada.Value = ddlCampanha.SelectedValue;
                lblCampanhaSelecionada.Text = ddlCampanha.SelectedItem.Text;


            }
            else
            {
                HiddenField hdnIDCampanhaSelecionada = Master.FindControl("hdnIDCampanhaSelecionada") as HiddenField;
                Label lblCampanhaSelecionada = Master.FindControl("lblCampanhaSelecionada") as Label;

                Session["IDCampanhaSelecionada"] = "";
                Session["CampanhaSelecionada"] = "";

                hdnIDCampanhaSelecionada.Value = "";
                lblCampanhaSelecionada.Text = "";
            }

        }
    }
}