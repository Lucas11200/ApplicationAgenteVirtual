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
    public partial class acionamento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Acionamento"])
                Server.Transfer("logon.aspx", true);
            else if (Session["IDCampanhaSelecionada"] == null || string.IsNullOrEmpty(Session["IDCampanhaSelecionada"].ToString()))
            {
                string scriptText1 = "menssagem('Atenção','Preencha a campanha!');";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script", scriptText1, true);
                divAcionamento.Visible = false;
            }
            else
            {
                if (!Page.IsPostBack)
                    CarregarAcionamentos();
            }
        }

        private void CarregarAcionamentos()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerAcionamento;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdAcionamento = new SqlCommand("sp_Sel_HorarioAcionamento", con);

            //Informando qual o tipo de comando
            cmdAcionamento.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdAcionamento.Parameters.Clear();

            int idCampanha = string.IsNullOrEmpty(Session["IDCampanhaSelecionada"].ToString()) ? 0 : int.Parse(Session["IDCampanhaSelecionada"].ToString());

            //Populando os parametros para executação da procedure
            cmdAcionamento.Parameters.AddWithValue("@IDCampanha", idCampanha);

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerAcionamento = cmdAcionamento.ExecuteReader();

            int contador = 1;

            while (readerAcionamento.Read())
            {
                SetIDHorarioAcionamento(readerAcionamento, contador);

                SetHoraInicio(readerAcionamento, contador);

                SetHoraFim(readerAcionamento, contador);

                SetVigenciaInicio(readerAcionamento, contador);

                SetVigenciaFim(readerAcionamento, contador);

                SetCustoExtraDia(readerAcionamento, contador);

                contador = contador + 1;
            }

            //Fecha conexão
            con.Close();
        }

        private void SetVigenciaFim(SqlDataReader readerAcionamento, int contador)
        {
            string ano = DateTime.Parse(readerAcionamento[5].ToString()).Year.ToString();
            string mes = DateTime.Parse(readerAcionamento[5].ToString()).Month.ToString();
            string dia = DateTime.Parse(readerAcionamento[5].ToString()).Day.ToString();

            string vigenciaFim = ano + "-" + mes.PadLeft(2, '0') + "-" + dia.PadLeft(2, '0');

            if (contador == 1)
                txtVigenciaFim1.Text = vigenciaFim;
            else if (contador == 2)
                txtVigenciaFim2.Text = vigenciaFim;
            else if (contador == 3)
                txtVigenciaFim3.Text = vigenciaFim;
            else if (contador == 4)
                txtVigenciaFim4.Text = vigenciaFim;
            else if (contador == 5)
                txtVigenciaFim5.Text = vigenciaFim;
            else if (contador == 6)
                txtVigenciaFim6.Text = vigenciaFim;
            else if (contador == 7)
                txtVigenciaFim7.Text = vigenciaFim;
        }

        private void SetVigenciaInicio(SqlDataReader readerAcionamento, int contador)
        {
            string ano = DateTime.Parse(readerAcionamento[4].ToString()).Year.ToString();
            string mes = DateTime.Parse(readerAcionamento[4].ToString()).Month.ToString();
            string dia = DateTime.Parse(readerAcionamento[4].ToString()).Day.ToString();

            string vigenciaInicio = ano + "-" + mes.PadLeft(2, '0') + "-" + dia.PadLeft(2, '0');

            if (contador == 1)
                txtVigenciaInicio1.Text = vigenciaInicio;
            else if (contador == 2)
                txtVigenciaInicio2.Text = vigenciaInicio;
            else if (contador == 3)
                txtVigenciaInicio3.Text = vigenciaInicio;
            else if (contador == 4)
                txtVigenciaInicio4.Text = vigenciaInicio;
            else if (contador == 5)
                txtVigenciaInicio5.Text = vigenciaInicio;
            else if (contador == 6)
                txtVigenciaInicio6.Text = vigenciaInicio;
            else if (contador == 7)
                txtVigenciaInicio7.Text = vigenciaInicio;
        }

        private void SetHoraFim(SqlDataReader readerAcionamento, int contador)
        {
            if (contador == 1)
                txtHoraFim1.Text = readerAcionamento[3].ToString();
            else if (contador == 2)
                txtHoraFim2.Text = readerAcionamento[3].ToString();
            else if (contador == 3)
                txtHoraFim3.Text = readerAcionamento[3].ToString();
            else if (contador == 4)
                txtHoraFim4.Text = readerAcionamento[3].ToString();
            else if (contador == 5)
                txtHoraFim5.Text = readerAcionamento[3].ToString();
            else if (contador == 6)
                txtHoraFim6.Text = readerAcionamento[3].ToString();
            else if (contador == 7)
                txtHoraFim7.Text = readerAcionamento[3].ToString();
        }

        private void SetHoraInicio(SqlDataReader readerAcionamento, int contador)
        {
            if (contador == 1)
                txtHoraInicio1.Text = readerAcionamento[2].ToString();
            else if (contador == 2)
                txtHoraInicio2.Text = readerAcionamento[2].ToString();
            else if (contador == 3)
                txtHoraInicio3.Text = readerAcionamento[2].ToString();
            else if (contador == 4)
                txtHoraInicio4.Text = readerAcionamento[2].ToString();
            else if (contador == 5)
                txtHoraInicio5.Text = readerAcionamento[2].ToString();
            else if (contador == 6)
                txtHoraInicio6.Text = readerAcionamento[2].ToString();
            else if (contador == 7)
                txtHoraInicio7.Text = readerAcionamento[2].ToString();
        }

        private void SetCustoExtraDia(SqlDataReader readerAcionamento, int contador)
        {
            if (contador == 1)
                lblCustoExtraDia1.Text = readerAcionamento[7].ToString();
            else if (contador == 2)
                lblCustoExtraDia2.Text = readerAcionamento[7].ToString();
            else if (contador == 3)
                lblCustoExtraDia3.Text = readerAcionamento[7].ToString();
            else if (contador == 4)
                lblCustoExtraDia4.Text = readerAcionamento[7].ToString();
            else if (contador == 5)
                lblCustoExtraDia5.Text = readerAcionamento[7].ToString();
            else if (contador == 6)
                lblCustoExtraDia6.Text = readerAcionamento[7].ToString();
            else if (contador == 7)
                lblCustoExtraDia7.Text = readerAcionamento[7].ToString();
        }

        private void SetIDHorarioAcionamento(SqlDataReader readerAcionamento, int contador)
        {
            if (contador == 1)
                hdnIDHorarioAcionamento1.Value = readerAcionamento[0].ToString();
            else if (contador == 2)
                hdnIDHorarioAcionamento2.Value = readerAcionamento[0].ToString();
            else if (contador == 3)
                hdnIDHorarioAcionamento3.Value = readerAcionamento[0].ToString();
            else if (contador == 4)
                hdnIDHorarioAcionamento4.Value = readerAcionamento[0].ToString();
            else if (contador == 5)
                hdnIDHorarioAcionamento5.Value = readerAcionamento[0].ToString();
            else if (contador == 6)
                hdnIDHorarioAcionamento6.Value = readerAcionamento[0].ToString();
            else if (contador == 7)
                hdnIDHorarioAcionamento7.Value = readerAcionamento[0].ToString();
        }

        protected void btnSalvarAcionamento_Click(object sender, EventArgs e)
        {
            //1 - Segunda
            //2 - Terça
            //3 - Quarta
            //4 - Quinta
            //5 - Sexta
            //6 - Sábado
            //7 - Domingo

            string inconsistencias = "";
            bool datasValida = true;
            int idCampanha = int.Parse(Session["IDCampanhaSelecionada"].ToString());

            for (int i = 1; i <= 7; i++)
            {

                int? hdnIDHorarioAcionamento = null;

                hdnIDHorarioAcionamento = GetIDHorarioAcionamento(i, hdnIDHorarioAcionamento);

                string inpHoraInicio = string.Empty;
                string inpHoraFim = string.Empty;
                string vigenciaInicial = string.Empty;
                string vigenciaFim = string.Empty;

                inpHoraInicio = GetHoraInicio(i, inpHoraInicio);

                inpHoraFim = GetHoraFim(i, inpHoraFim);

                vigenciaInicial = GetVigenciaInicial(i, vigenciaInicial);

                vigenciaFim = GetVigenciaFim(i, vigenciaFim);

                decimal CustoExtraDia = 0;

                CustoExtraDia = GetCustoExtraDia(i, CustoExtraDia);

                DateTime inpVigenciaInicio;
                if (!DateTime.TryParse(vigenciaInicial, out inpVigenciaInicio))
                {
                    inconsistencias += GetDiaDaSemana(inconsistencias, i);

                    datasValida = false;

                    inconsistencias += " Vigência Inicial inválida. ";
                }

                DateTime inpVigenciaFim;
                if (!DateTime.TryParse(vigenciaFim, out inpVigenciaFim))
                {
                    inconsistencias += GetDiaDaSemana(inconsistencias, i);

                    datasValida = false;

                    inconsistencias += " Vigência Final inválida. ";
                }

                if (inpVigenciaInicio > inpVigenciaFim)
                {
                    inconsistencias += GetDiaDaSemana(inconsistencias, i);

                    datasValida = false;

                    inconsistencias += " Vigência Inicial não pode ser maior que Vigência Final. ";
                }

                if (datasValida)
                {
                    //Instanciando classe de conexão
                    ObterConexao obterConexao = new ObterConexao();

                    //Abrindo conexão para execução da procedure
                    var con = obterConexao.ObtendoConexao();

                    //Informando qual comando (procedure) irá executar e qual conexão
                    SqlCommand cmdAcionamento = new SqlCommand("sp_Ins_HorarioAcionamento", con);
                    //Informando qual o tipo de comando
                    cmdAcionamento.CommandType = CommandType.StoredProcedure;

                    //Abre conexão                    
                    con.Open();

                    //Limpa os parametros
                    cmdAcionamento.Parameters.Clear();

                    //Populando os parametros para executação da procedure
                    cmdAcionamento.Parameters.AddWithValue("@IDHorarioAcionamento", hdnIDHorarioAcionamento);
                    cmdAcionamento.Parameters.AddWithValue("@IDCampanha", idCampanha);
                    cmdAcionamento.Parameters.AddWithValue("@HoraInicio", inpHoraInicio);
                    cmdAcionamento.Parameters.AddWithValue("@HoraFim", inpHoraFim);
                    cmdAcionamento.Parameters.AddWithValue("@VigenciaInicio", inpVigenciaInicio);
                    cmdAcionamento.Parameters.AddWithValue("@VigenciaFim", inpVigenciaFim);
                    cmdAcionamento.Parameters.AddWithValue("@DiaSemana", i);
                    cmdAcionamento.Parameters.AddWithValue("@CustoExtraDia", CustoExtraDia);

                    //Executa o comando
                    cmdAcionamento.ExecuteNonQuery();

                    //Fecha conexão
                    con.Close();
                }
                else
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaErro('Erro!','"+ inconsistencias +"');", true);
            }
            
            if (datasValida)          
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CallMyFunction", "alertaSucesso('Salvo!','Salvo com sucesso');", true);
         

            CarregarAcionamentos();
        }

        private string GetVigenciaInicial(int i, string vigenciaInicial)
        {
            if (i == 1)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio1.Text) ? "" : txtVigenciaInicio1.Text;
            else if (i == 2)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio2.Text) ? "" : txtVigenciaInicio2.Text;
            else if (i == 3)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio3.Text) ? "" : txtVigenciaInicio3.Text;
            else if (i == 4)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio4.Text) ? "" : txtVigenciaInicio4.Text;
            else if (i == 5)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio5.Text) ? "" : txtVigenciaInicio5.Text;
            else if (i == 6)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio6.Text) ? "" : txtVigenciaInicio6.Text;
            else if (i == 7)
                vigenciaInicial = string.IsNullOrEmpty(txtVigenciaInicio7.Text) ? "" : txtVigenciaInicio7.Text;
            return vigenciaInicial;
        }

        private string GetVigenciaFim(int i, string vigenciaFim)
        {
            if (i == 1)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim1.Text) ? "" : txtVigenciaFim1.Text;
            else if (i == 2)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim2.Text) ? "" : txtVigenciaFim2.Text;
            else if (i == 3)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim3.Text) ? "" : txtVigenciaFim3.Text;
            else if (i == 4)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim4.Text) ? "" : txtVigenciaFim4.Text;
            else if (i == 5)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim5.Text) ? "" : txtVigenciaFim5.Text;
            else if (i == 6)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim6.Text) ? "" : txtVigenciaFim6.Text;
            else if (i == 7)
                vigenciaFim = string.IsNullOrEmpty(txtVigenciaFim7.Text) ? "" : txtVigenciaFim7.Text;
            return vigenciaFim;
        }

        private string GetHoraInicio(int i, string inpHoraInicio)
        {
            if (i == 1)
                inpHoraInicio = txtHoraInicio1.Text;
            else if (i == 2)
                inpHoraInicio = txtHoraInicio2.Text;
            else if (i == 3)
                inpHoraInicio = txtHoraInicio3.Text;
            else if (i == 4)
                inpHoraInicio = txtHoraInicio4.Text;
            else if (i == 5)
                inpHoraInicio = txtHoraInicio5.Text;
            else if (i == 6)
                inpHoraInicio = txtHoraInicio6.Text;
            else if (i == 7)
                inpHoraInicio = txtHoraInicio7.Text;
            return inpHoraInicio;
        }

        private string GetHoraFim(int i, string inpHoraFim)
        {
            if (i == 1)
                inpHoraFim = txtHoraFim1.Text;
            else if (i == 2)
                inpHoraFim = txtHoraFim2.Text;
            else if (i == 3)
                inpHoraFim = txtHoraFim3.Text;
            else if (i == 4)
                inpHoraFim = txtHoraFim4.Text;
            else if (i == 5)
                inpHoraFim = txtHoraFim5.Text;
            else if (i == 6)
                inpHoraFim = txtHoraFim6.Text;
            else if (i == 7)
                inpHoraFim = txtHoraFim7.Text;
            return inpHoraFim;
        }

        private decimal GetCustoExtraDia(int i, decimal CustoExtraDia)
        {
            if (i == 1)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia1.Text) ? 0 : decimal.Parse(lblCustoExtraDia1.Text);
            else if (i == 2)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia2.Text) ? 0 : decimal.Parse(lblCustoExtraDia2.Text);
            else if (i == 3)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia3.Text) ? 0 : decimal.Parse(lblCustoExtraDia3.Text);
            else if (i == 4)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia4.Text) ? 0 : decimal.Parse(lblCustoExtraDia4.Text);
            else if (i == 5)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia5.Text) ? 0 : decimal.Parse(lblCustoExtraDia5.Text);
            else if (i == 6)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia6.Text) ? 0 : decimal.Parse(lblCustoExtraDia6.Text);
            else if (i == 7)
                CustoExtraDia = string.IsNullOrEmpty(lblCustoExtraDia7.Text) ? 0 : decimal.Parse(lblCustoExtraDia7.Text);
            return CustoExtraDia;
        }

        private int? GetIDHorarioAcionamento(int i, int? hdnIDHorarioAcionamento)
        {
            if (i == 1)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento1.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento1.Value);
            else if (i == 2)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento2.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento2.Value);
            else if (i == 3)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento3.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento3.Value);
            else if (i == 4)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento4.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento4.Value);
            else if (i == 5)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento5.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento5.Value);
            else if (i == 6)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento6.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento6.Value);
            else if (i == 7)
                hdnIDHorarioAcionamento = string.IsNullOrEmpty(hdnIDHorarioAcionamento7.Value) ? (int?)null : int.Parse(hdnIDHorarioAcionamento7.Value);
            return hdnIDHorarioAcionamento;
        }

        private static string GetDiaDaSemana(string incosistencias, int i)
        {
            if (i == 1)
                incosistencias = "Segunda -";
            else if (i == 2)
                incosistencias = "Terça -";
            else if (i == 3)
                incosistencias = "Quarta -";
            else if (i == 4)
                incosistencias = "Quinta -";
            else if (i == 5)
                incosistencias = "Sexta -";
            else if (i == 6)
                incosistencias = "Sábado -";
            else if (i == 7)
                incosistencias = "Domingo -";
            return incosistencias;
        }

    }
}