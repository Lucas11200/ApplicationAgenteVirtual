using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ApplicationAgenteVirtual
{
    public partial class historico : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Histórico"])
                Server.Transfer("logon.aspx", true);
            else if (Session["IDCampanhaSelecionada"] == null || string.IsNullOrEmpty(Session["IDCampanhaSelecionada"].ToString()))
            {
                string scriptText1 = "menssagem('Atenção','Preencha a campanha!'); ";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script", scriptText1, true);
                divBotoes.Visible = false;               
            }
            else if (!Page.IsPostBack)
            {
                CarregarUsuarios();
            }
        }

        private void CarregarUsuarios()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerUsuario;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdUsuarios = new SqlCommand("sp_Sel_Usuario", con);

            //Informando qual o tipo de comando
            cmdUsuarios.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerUsuario = cmdUsuarios.ExecuteReader();

            List<Usuario> listUsuario = new List<Usuario>();

            //Populando primeira linha do DropDownList com "Selecione..."
            listUsuario.Add(new Usuario() { IDUsuario = 0, UserName = "Selecione..." });

            while (readerUsuario.Read())
            {
                Grupo grupo = new Grupo();

                listUsuario.Add(new Usuario() { IDUsuario = (int)readerUsuario[0], UserName = readerUsuario[1].ToString() });
            }

            ddlUsuarios.DataSource = listUsuario;
            ddlUsuarios.DataValueField = "IDUsuario";
            ddlUsuarios.DataTextField = "UserName";
            ddlUsuarios.DataBind();

            //Fecha conexão
            con.Close();
        }

        protected void btnGerar_Click(object sender, EventArgs e)
        {
            bool validacao = true;
            string inconsistencia = "";

            if (ddlUsuarios.SelectedValue == "0")
            {
                inconsistencia += "Selecione um usuário para uma nova pesquisa. ";
                validacao = false;
            }

            DateTime inpDataInicio;
            if (!DateTime.TryParse(txtDataInicio.Text, out inpDataInicio))
            {
                inconsistencia += " Data Início inválida. ";
                validacao = false;
            }

            DateTime inpDataFim;
            if (!DateTime.TryParse(txtDataFim.Text, out inpDataFim))
            {
                inconsistencia += " Data Fim inválida. ";
                validacao = false;
            }

            if (inpDataInicio > inpDataFim)
            {
                inconsistencia += " Data Início maior que Data Fim. ";
                validacao = false;
            }

            if (validacao)
            {
                ltlHistorico.Text = "";

                List<Historico> listHistorico = CarregarListHistorico();
                StringBuilder sb = new StringBuilder();
                var listGrupo = listHistorico.GroupBy(x => new { x.DataCriacao, x.Grupo, x.Usuario, x.ExclusivoRobo }).Select(x => x.Key);

                if (listHistorico.Count == 0)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "showToast('Não há histórico.', 'danger');", true);
                }
                else
                {
                    sb.AppendLine("<div><table style='margin-left: 20%;'>");

                    string dataCriacao = "";

                    foreach (var grupo in listGrupo)
                    {
                        if (string.IsNullOrEmpty(dataCriacao))
                        {
                            dataCriacao = grupo.DataCriacao;

                            string chkBoxExclusivoRobo = grupo.ExclusivoRobo == true ? "<span class='aspNetDisabled' style='float: right; margin-left: 10%;'><input id='chkExclusivoRobo' type='checkbox' name='chkExclusivoRobo' disabled='true' checked='checked'><label for='chkExclusivoRobo'>Exclusivo Robô</label></span>" : "<span class='aspNetDisabled' style='float: right; margin-left: 10%;'><input id='chkExclusivoRobo' type='checkbox' name='chkExclusivoRobo' disabled='true' ><label for='chkExclusivoRobo'>Exclusivo Robô</label></span>";

                            sb.AppendLine("<tr>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    "<span id='lblUsuario'><b> Usuário:</b></span>" +
                                    "<span id= 'lblNomeUsuario'> " + grupo.Usuario + " </span>" +
                                "</td>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    "<span ><b> Data:</b></span>" +
                                    "<span id= 'lblNomeUsuario'> " + grupo.DataCriacao + " </span>" +
                                "</td>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    chkBoxExclusivoRobo +
                                "</td>" +
                            "</tr>" +
                            "<tr>" +
                                "<td style='padding-top: 2%;' colspan='6'>" +
                                    "<span ><b> Publico Selecionado</b></span>" +
                                "</td>" +
                            "</tr>");
                        }
                        else if (dataCriacao != grupo.DataCriacao)
                        {
                            string chkBoxExclusivoRobo = grupo.ExclusivoRobo == true ? "<span class='aspNetDisabled' style='float: right; margin-left: 10%;'><input id='chkExclusivoRobo' type='checkbox' name='chkExclusivoRobo' disabled='true' checked='checked'><label for='chkExclusivoRobo'>Exclusivo Robô</label></span>" : "<span class='aspNetDisabled' style='float: right; margin-left: 10%;'><input id='chkExclusivoRobo' type='checkbox' name='chkExclusivoRobo' disabled='true' ><label for='chkExclusivoRobo'>Exclusivo Robô</label></span>";

                            sb.AppendLine("<tr>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    "<span id='lblUsuario'><b> Usuário:</b></span>" +
                                    "<span id= 'lblNomeUsuario'> " + grupo.Usuario + " </span>" +
                                "</td>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    "<span ><b> Data:</b></span>" +
                                    "<span id= 'lblNomeUsuario'> " + grupo.DataCriacao + " </span>" +
                                "</td>" +
                                "<td colspan='2' style='padding-top: 5%;'>" +
                                    chkBoxExclusivoRobo +
                                "</td>" +
                            "</tr>" +
                            "<tr>" +
                                "<td style='padding-top: 2%;' colspan='6'>" +
                                    "<span ><b> Publico Selecionado</b></span>" +
                                "</td>" +
                            "</tr>");
                        }

                        sb.AppendLine("<tr>" +
                                "<td style='padding-top: 2%;' colspan='6'>" +
                                    "<span id='lblUsuario'><b> Grupo " + grupo.Grupo + "</b></span>" +
                                "</td>" +
                            "</tr>");

                        var listLinhas = listHistorico.Where(x => x.DataCriacao == grupo.DataCriacao && x.Grupo == grupo.Grupo);

                        foreach (var linha in listLinhas)
                        {
                            sb.AppendLine(
                            "<tr>" +
                                "<td colspan='2'>" +
                                    "<input name='txtTipoFiltro' type='text' title='Filtro' value='" + linha.TipoFiltro + "' id='txtTipoFiltro' disabled='disabled' class='aspNetDisabled'>" +
                                "</td>" +
                                "<td colspan='2'>" +
                                    "<input name='txtOperador' type='text' title='Operador' value='" + linha.Operador + "' id='txtOperador' disabled='disabled' class='aspNetDisabled'>" +
                                "</td>" +
                                "<td colspan='2'>" +
                                    "<input name='txtValor' type='text' title='Valor' value='" + linha.Valor + "' id='txtValor' disabled='disabled' class='aspNetDisabled'>" +
                                "</td>" +
                            "</tr>");
                        }
                    }

                    sb.AppendLine("</table></div>");

                    ltlHistorico.Text = sb.ToString();
                }
            }
            else
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "showToast('" + inconsistencia + "', 'danger');", true);
        }

        private List<Historico> CarregarListHistorico()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerHistorico;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdHistorico = new SqlCommand("sp_Sel_Historico", con);

            //Informando qual o tipo de comando
            cmdHistorico.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdHistorico.Parameters.Clear();

            int idCampanha = int.Parse(Session["IDCampanhaSelecionada"].ToString());

            //Populando os parametros para executação da procedure
            cmdHistorico.Parameters.AddWithValue("@IDCampanha", idCampanha);
            cmdHistorico.Parameters.AddWithValue("@DataInicio", DateTime.Parse(txtDataInicio.Text));
            cmdHistorico.Parameters.AddWithValue("@DataFim", DateTime.Parse(txtDataFim.Text));
            cmdHistorico.Parameters.AddWithValue("@Usuario", Session["NomeUsuario"].ToString());

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerHistorico = cmdHistorico.ExecuteReader();

            List<Historico> listHistorico = new List<Historico>();

            while (readerHistorico.Read())
            {
                listHistorico.Add(new Historico()
                {
                    Usuario = readerHistorico[0].ToString(),
                    DataCriacao = readerHistorico[1].ToString(),
                    Grupo = int.Parse(readerHistorico[2].ToString()),
                    TipoFiltro = readerHistorico[3].ToString(),
                    Operador = readerHistorico[4].ToString(),
                    Valor = readerHistorico[5].ToString(),
                    ExclusivoRobo = bool.Parse(readerHistorico[6].ToString())
                });
            }

            //Fecha conexão
            con.Close();
            return listHistorico;
        }

        protected void btnLimpar_Click(object sender, EventArgs e)
        {
            ddlUsuarios.SelectedIndex = 0;
            txtDataInicio.Text = "";
            txtDataFim.Text = "";
            ltlHistorico.Text = "";
        }
    }
}
