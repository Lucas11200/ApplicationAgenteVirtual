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
    public partial class definirPublico : Page
    {
        public int Contador { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(bool)Session["Definir Público"])
                Server.Transfer("logon.aspx", true);
            else if (Session["IDCampanhaSelecionada"] == null || string.IsNullOrEmpty(Session["IDCampanhaSelecionada"].ToString()))
            {
                string scriptText1 = "menssagem('Atenção','Preencha a campanha!'); ";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script", scriptText1, true);
                divDefinirPublico.Visible = false;                
            }
            else
            {
                //Carrega dados da base e setar nos view state ex: Grupo1, Grupo2 etc....
                //Popular o ViewState "ContadorGrupo", com quantos grupos foram salvos.
                //Se feito corretamente o metodo MontarGrupos fará o trabalho dele
                //Como o grid é feito todo no backend, cada postback ele some. Portanto deve ser montado novamente.
                //Colocar o metodo de buscar na base dentro do IsPostBack, assim ele n fica metralhando o banco.

                if (!Page.IsPostBack)
                    ObterQTDGrupo();

                if (ViewState["ContadorGrupo"] == null)
                    ViewState["ContadorGrupo"] = 1;

                if (ViewState["ChamadaRemoverGrupo"] == null)
                    ViewState["ChamadaRemoverGrupo"] = false;

                if (ViewState["ChamadaAdicionarGrupo"] == null)
                    ViewState["ChamadaAdicionarGrupo"] = false;

                Contador = int.Parse(ViewState["ContadorGrupo"].ToString());

                MontarGrupos();

                if (!Page.IsPostBack)
                    for (int i = 1; i <= Contador; i++)
                    {
                        CarregarGridView(i);
                    }
            }
        }

        private void ObterQTDGrupo()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerQTDGrupo;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdQTDGrupo = new SqlCommand("sp_Sel_CountFiltroGrupoCampanha", con);

            //Informando qual o tipo de comando
            cmdQTDGrupo.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdQTDGrupo.Parameters.Clear();

            int idCampanha = int.Parse(Session["IDCampanhaSelecionada"].ToString());

            //Populando os parametros para executação da procedure
            cmdQTDGrupo.Parameters.AddWithValue("@IDCampanha", idCampanha);

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerQTDGrupo = cmdQTDGrupo.ExecuteReader();

            int contador = 1;

            while (readerQTDGrupo.Read())
            {
                contador = int.Parse(readerQTDGrupo[0].ToString()) > 0 ? int.Parse(readerQTDGrupo[0].ToString()) : 1;
            }

            ViewState["ContadorGrupo"] = contador;

            //Fecha conexão
            con.Close();
        }

        protected override object SaveViewState()
        {
            // Change Text Property of Label when this function is invoked.
            if (HasControls() && (Page.IsPostBack))
            {
                SalvaGridView();
            }

            return base.SaveViewState();
        }

        private void MontarGrupos()
        {
            for (int idGrupo = 1; idGrupo <= Contador; idGrupo++)
            {
                MontaHtmlGrupo(idGrupo, false);
            }
        }

        private void MontaHtmlGrupo(int idGrupo, bool removerGrupo)
        {
            StringBuilder sb = new StringBuilder();

            //monta grupo
            sb.AppendLine("<tr>");
            sb.AppendLine("<td colspan='5' style='padding-left: 5%;'>");

            controlador.Controls.Add(new LiteralControl(sb.ToString()));

            Label grupo = new Label();
            grupo.Text = "Grupo " + idGrupo + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            grupo.ID = "grupo" + idGrupo;

            controlador.Controls.Add(grupo);

            if (idGrupo >= 2)
            {
                LinkButton btnRemoverGrupo = new LinkButton();
                btnRemoverGrupo.ID = "btnRemoverGrupo-" + idGrupo;
                btnRemoverGrupo.Text = "Excluir";
                btnRemoverGrupo.Click += btnRemoverGrupo_Click;
                btnRemoverGrupo.Visible = removerGrupo;

                if (bool.Parse(ViewState["ChamadaRemoverGrupo"].ToString()) && idGrupo == Contador)
                {
                    btnRemoverGrupo.Visible = true;
                    ViewState["ChamadaRemoverGrupo"] = false;
                }
                else if (bool.Parse(ViewState["ChamadaAdicionarGrupo"].ToString()) && idGrupo == Contador)
                {
                    LinkButton linkBtn = controlador.FindControl("btnRemoverGrupo-" + (idGrupo - 1)) as LinkButton;
                    if (linkBtn != null)
                        linkBtn.Visible = false;

                    btnRemoverGrupo.Visible = true;
                    ViewState["ChamadaAdicionarGrupo"] = false;
                }
                else if (!bool.Parse(ViewState["ChamadaRemoverGrupo"].ToString()) && !bool.Parse(ViewState["ChamadaAdicionarGrupo"].ToString()) && idGrupo == Contador)
                {
                    btnRemoverGrupo.Visible = true;
                }

                if (btnRemoverGrupo.Visible)
                {
                    Label removerLabel = new Label();
                    removerLabel.Text = " ";
                    removerLabel.Visible = true;
                    controlador.Controls.Add(removerLabel);
                }

                controlador.Controls.Add(btnRemoverGrupo);
            }

            sb = new StringBuilder();
            sb.AppendLine("</td>");
            sb.AppendLine("</tr>");
            sb.AppendLine("<tr style=''>");
            sb.AppendLine("<td>");

            controlador.Controls.Add(new LiteralControl(sb.ToString()));

            GridView gridView = new GridView();

            gridView.ShowHeader = false;
            gridView.AutoGenerateColumns = false;
            gridView.HorizontalAlign = HorizontalAlign.Center;
            gridView.RowDataBound += new GridViewRowEventHandler(GridView_RowDataBound);
            gridView.RowCommand += new GridViewCommandEventHandler(GridView_RowCommand);
            gridView.EnableViewState = true;
            //gridView.Load += new EventHandler(SalvaGridView);

            TemplateField ddlTipoFiltro = new TemplateField();
            ddlTipoFiltro.ItemStyle.Width = Unit.Pixel(210);
            ddlTipoFiltro.ItemStyle.Height = Unit.Pixel(27);
            ddlTipoFiltro.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            ddlTipoFiltro.ItemTemplate = new DynamicDropDownField("Filtro", "ddlTipoFiltro", 200);
            gridView.Columns.Add(ddlTipoFiltro);

            TemplateField ddlOperador = new TemplateField();
            ddlOperador.ItemStyle.Width = Unit.Pixel(110);
            ddlOperador.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            ddlOperador.ItemTemplate = new DynamicDropDownField("Operador", "ddlOperador", 100);
            gridView.Columns.Add(ddlOperador);

            TemplateField txtValores = new TemplateField();
            txtValores.ItemStyle.Width = Unit.Pixel(160);
            txtValores.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            txtValores.ItemTemplate = new DynamicTextField("Valores", "txtValor", 150);
            gridView.Columns.Add(txtValores);

            TemplateField botoes = new TemplateField();
            botoes.ItemStyle.Width = Unit.Pixel(80);
            botoes.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            botoes.ItemTemplate = new DynamicButton();
            gridView.Columns.Add(botoes);

            TemplateField remover = new TemplateField();
            remover.ItemStyle.Width = Unit.Pixel(80);
            remover.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            remover.ItemTemplate = new DynamicButtonRemover(false);
            gridView.Columns.Add(remover);
            gridView.ID = "GridView-" + idGrupo;

            controlador.Controls.Add(gridView);

            if (ViewState["Grupo" + idGrupo] == null)
            {
                ViewState["Grupo" + idGrupo] = null;
            }

            PreencheLinhas(gridView, idGrupo);

            sb = new StringBuilder();
            sb.AppendLine("</td>");
            sb.AppendLine("</tr>");
            controlador.Controls.Add(new LiteralControl(sb.ToString()));
        }

        private void PreencheLinhas(GridView gdView, int idGrupo)
        {
            if (ViewState["Grupo" + idGrupo] == null)
            {
                DataTable dt = new DataTable();
                DataRow dr = null;

                dt.Columns.Add(new DataColumn("ddlTipoFiltro", typeof(int)));
                dt.Columns.Add(new DataColumn("ddlOperador", typeof(int)));
                dt.Columns.Add(new DataColumn("txtValor", typeof(string)));
                dt.Columns.Add(new DataColumn("condicao", typeof(string)));
                dr = dt.NewRow();

                dr["ddlTipoFiltro"] = DBNull.Value;
                dr["ddlOperador"] = DBNull.Value;
                dr["txtValor"] = DBNull.Value;
                dr["condicao"] = DBNull.Value;
                dt.Rows.Add(dr);

                ViewState["Grupo" + idGrupo] = dt;

                //gdView.ID = "GridView-" + idGrupo;
                gdView.DataSourceID = null;
                gdView.DataSource = dt;
                gdView.DataBind();
            }
            else
            {
                DataTable dt = (DataTable)ViewState["Grupo" + idGrupo];
                //gdView.ID = "GridView-" + idGrupo;                
                gdView.DataSource = null;
                gdView.DataBind();
                gdView.DataSource = dt;
                gdView.DataBind();
            }
        }

        private void MontarNovaLinha(GridView gdView)
        {
            if (ViewState["Grupo" + gdView.ID.Split('-')[1]] != null)
            {
                SalvaGridView();

                DataTable dt = (DataTable)ViewState["Grupo" + gdView.ID.Split('-')[1]];
                DataRow dr = null;
                dr = dt.NewRow();
                dr["ddlTipoFiltro"] = 0;
                dr["ddlOperador"] = 0;
                dr["txtValor"] = DBNull.Value;
                dr["condicao"] = DBNull.Value;
                dt.Rows.Add(dr);

                ViewState["Grupo" + gdView.ID.Split('-')[1]] = dt;

                gdView.DataSource = dt;
                gdView.DataBind();
            }
        }

        private void RemoveLinhaGrid(GridView gdView, GridViewRow row)
        {
            SalvaGridView();

            DataTable dt = (DataTable)ViewState["Grupo" + gdView.ID.Split('-')[1]];
            DataRow dr = dt.Rows[row.RowIndex];
            dt.Rows.Remove(dr);

            dt.Rows[(dt.Rows.Count - 1)]["condicao"] = DBNull.Value;

            ViewState["Grupo" + gdView.ID.Split('-')[1]] = dt;

            gdView.DataSource = dt;
            gdView.DataBind();
        }

        protected void btnIncluirGrupo_Click(object sender, EventArgs e)
        {
            ViewState["ChamadaAdicionarGrupo"] = true;

            Contador++;
            ViewState["ContadorGrupo"] = Contador;
            MontaHtmlGrupo(Contador, true);
        }

        protected void btnRemoverGrupo_Click(object sender, EventArgs e)
        {
            ViewState["ChamadaRemoverGrupo"] = true;

            LinkButton btn = (LinkButton)sender;
            int idGrupoRemovido = int.Parse(btn.ID.Split('-')[1]);

            //ViewState.Remove("Grupo" + idGrupoRemovido);

            ViewState["Grupo" + idGrupoRemovido] = "delete";

            StringBuilder sbScript = new StringBuilder();

            sbScript.Append("<script language='JavaScript' type='text/javascript'>\n");
            sbScript.Append("<!--\n");
            sbScript.Append(GetPostBackEventReference(this, "PBArg") + ";\n");
            sbScript.Append("// -->\n");
            sbScript.Append("</script>\n");

            RegisterStartupScript("AutoPostBackScript", sbScript.ToString());
        }

        #region Obter Listas

        private List<TipoFiltro> ObterTipoFiltro()
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerTipoFiltro;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdTipoFiltro = new SqlCommand("sp_Sel_TipoFiltro", con);

            //Informando qual o tipo de comando
            cmdTipoFiltro.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdTipoFiltro.Parameters.Clear();

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerTipoFiltro = cmdTipoFiltro.ExecuteReader();

            List<TipoFiltro> listTipoFiltro = new List<TipoFiltro>();

            //Populando primeira linha do DropDownList com "Selecione..."
            listTipoFiltro.Add(new TipoFiltro
            {
                IDTipoFiltro = 0,
                Descricao = "Selecione..."
            });

            while (readerTipoFiltro.Read())
            {
                TipoFiltro tipoFiltro = new TipoFiltro();

                tipoFiltro.IDTipoFiltro = (int)readerTipoFiltro[0];
                tipoFiltro.Descricao = readerTipoFiltro[1].ToString();

                listTipoFiltro.Add(tipoFiltro);
            }

            //Fecha conexão
            con.Close();

            return listTipoFiltro;
        }

        private List<Operadores> ObterOperador()
        {
            List<Operadores> listOperador = new List<Operadores>();

            listOperador.Add(new Operadores() { IdOperador = 1, Descricao = "<" });
            listOperador.Add(new Operadores() { IdOperador = 2, Descricao = ">" });
            listOperador.Add(new Operadores() { IdOperador = 3, Descricao = "<=" });
            listOperador.Add(new Operadores() { IdOperador = 4, Descricao = ">=" });
            listOperador.Add(new Operadores() { IdOperador = 5, Descricao = "=" });
            listOperador.Add(new Operadores() { IdOperador = 6, Descricao = "<>" });

            return listOperador;
        }

        #endregion

        #region Metodos da grid

        protected void GridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                GridView gdView = (GridView)sender;

                if (ViewState["Grupo" + gdView.ID.Split('-')[1]].ToString() != "delete")
                {
                    DataTable dt = (DataTable)ViewState["Grupo" + gdView.ID.Split('-')[1]];
                    DataRow dr = dt.Rows[e.Row.RowIndex];

                    DataRowView dataRow = e.Row.DataItem as DataRowView;

                    DropDownList ddlTipoFiltro = e.Row.FindControl("ddlTipoFiltro") as DropDownList;
                    var listTipoFiltro = ObterTipoFiltro();
                    ddlTipoFiltro.DataSource = listTipoFiltro;
                    ddlTipoFiltro.DataValueField = "IDTipoFiltro";
                    ddlTipoFiltro.DataTextField = "Descricao";
                    ddlTipoFiltro.DataBind();

                    ddlTipoFiltro.SelectedValue = dr["ddlTipoFiltro"].ToString();
                    dataRow["ddlTipoFiltro"] = dr["ddlTipoFiltro"];

                    DropDownList ddlOperador = e.Row.FindControl("ddlOperador") as DropDownList;
                    var listOperador = ObterOperador();

                    ddlOperador.DataSource = listOperador;
                    ddlOperador.DataValueField = "IdOperador";
                    ddlOperador.DataTextField = "Descricao";
                    ddlOperador.DataBind();

                    ddlOperador.SelectedValue = dr["ddlOperador"].ToString();
                    dataRow["ddlOperador"] = dr["ddlOperador"];

                    TextBox txtValor = e.Row.FindControl("txtValor") as TextBox;
                    txtValor.Text = dr["txtValor"].ToString();
                    dataRow["txtValor"] = dr["txtValor"];

                    if (dr["condicao"] != DBNull.Value)
                    {
                        //Botao E foi clicado
                        if (!string.IsNullOrEmpty(dr["condicao"].ToString()) && int.Parse(dr["condicao"].ToString()) == 1)
                        {
                            Button btn = e.Row.FindControl("btnE") as Button;
                            btn.BorderColor = System.Drawing.Color.Red;
                        }
                        //Botao OU foi clicado
                        else if (!string.IsNullOrEmpty(dr["condicao"].ToString()) && int.Parse(dr["condicao"].ToString()) == 0)
                        {
                            Button btn = e.Row.FindControl("btnOU") as Button;
                            btn.BorderColor = System.Drawing.Color.Red;
                        }
                    }

                    if (e.Row.RowIndex > 0)
                    {
                        Button btnRemover = e.Row.FindControl("removerRow") as Button;
                        btnRemover.Visible = true;
                    }
                }
            }
        }

        protected void GridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridViewRow gvr = (GridViewRow)(((Button)e.CommandSource).NamingContainer);
            int rowIndex = gvr.RowIndex;

            GridView gdView = (GridView)sender;
            GridViewRow row = gdView.Rows[rowIndex];
            DataRowView dataRow = row.DataItem as DataRowView;

            if (e.CommandName == "btnE_Click")
            {
                Button btn = (Button)row.FindControl("btnE");
                btn.BorderColor = System.Drawing.Color.Red;
                DataTable dt = (DataTable)ViewState["Grupo" + gdView.ID.Split('-')[1]];
                dt.Rows[row.RowIndex]["condicao"] = 1;

                if (dt.Rows.Count == (row.RowIndex + 1))
                {
                    MontarNovaLinha(gdView);
                }
            }
            else if (e.CommandName == "btnOU_Click")
            {
                Button btn = (Button)row.FindControl("btnOU");
                btn.BorderColor = System.Drawing.Color.Red;
                DataTable dt = (DataTable)ViewState["Grupo" + gdView.ID.Split('-')[1]];
                dt.Rows[row.RowIndex]["condicao"] = 0;

                if (dt.Rows.Count == (row.RowIndex + 1))
                {
                    MontarNovaLinha(gdView);
                }
            }
            else if (e.CommandName == "removerRow")
            {
                RemoveLinhaGrid(gdView, row);
            }
        }

        private void CarregarGridView(int idGrupo)
        {
            List<FiltroGrupoCampanha> listFiltroGrupoCampanha = ObterFiltroGrupoCampanhaRetorno(idGrupo);

            if (listFiltroGrupoCampanha.Count >= 1)
            {
                GridView gridView = (GridView)controlador.FindControl("GridView-" + idGrupo);

                //PreencheLinhas(gridView, idGrupo, listFiltroGrupoCampanha.Count);

                DataTable dt = (DataTable)ViewState["Grupo" + gridView.ID.Split('-')[1]];

                for (int i = dt.Rows.Count - 1; i >= 0; i--)
                {
                    DataRow dr = dt.Rows[i];
                    dr.Delete();
                }

                DataRow row;
                DataView view;

                for (int x = 0; x < listFiltroGrupoCampanha.Count; x++)
                {
                    row = dt.NewRow();

                    row["ddlTipoFiltro"] = listFiltroGrupoCampanha[x].IDTipoFiltro;

                    ObterOperadorRetorno(listFiltroGrupoCampanha, row, x);

                    row["txtValor"] = listFiltroGrupoCampanha[x].Valor;

                    row["condicao"] = listFiltroGrupoCampanha[x].Condicao;

                    dt.Rows.Add(row);
                }

                ViewState["Grupo" + gridView.ID.Split('-')[1]] = dt;

                view = new DataView(dt);

                gridView.DataSource = view;
                gridView.DataBind();
            }
        }

        private static void ObterOperadorRetorno(List<FiltroGrupoCampanha> listFiltroGrupoCampanha, DataRow row, int x)
        {
            if (listFiltroGrupoCampanha[x].Operador == "<")
                row["ddlOperador"] = 1;
            else if (listFiltroGrupoCampanha[x].Operador == ">")
                row["ddlOperador"] = 2;
            else if (listFiltroGrupoCampanha[x].Operador == "<=")
                row["ddlOperador"] = 3;
            else if (listFiltroGrupoCampanha[x].Operador == ">=")
                row["ddlOperador"] = 4;
            else if (listFiltroGrupoCampanha[x].Operador == "=")
                row["ddlOperador"] = 5;
            else if (listFiltroGrupoCampanha[x].Operador == "<>")
                row["ddlOperador"] = 6;
        }

        private List<FiltroGrupoCampanha> ObterFiltroGrupoCampanhaRetorno(int idGrupo)
        {
            int idCampanha = int.Parse(Session["IDCampanhaSelecionada"].ToString());

            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Abrindo um novo DataReader
            SqlDataReader readerFiltroGrupoCampanha;

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdFiltroGrupoCampanha = new SqlCommand("sp_Sel_FiltroGrupoCampanha", con);

            //Informando qual o tipo de comando
            cmdFiltroGrupoCampanha.CommandType = CommandType.StoredProcedure;

            //Limpa os parametros
            cmdFiltroGrupoCampanha.Parameters.Clear();

            cmdFiltroGrupoCampanha.Parameters.AddWithValue("@IDCampanha", idCampanha);
            cmdFiltroGrupoCampanha.Parameters.AddWithValue("@Grupo", idGrupo);

            //Abre conexão                    
            con.Open();

            //Executa o comando
            readerFiltroGrupoCampanha = cmdFiltroGrupoCampanha.ExecuteReader();

            List<FiltroGrupoCampanha> listFiltroGrupoCampanha = new List<FiltroGrupoCampanha>();

            while (readerFiltroGrupoCampanha.Read())
            {
                FiltroGrupoCampanha filtroGrupoCampanha = new FiltroGrupoCampanha();

                filtroGrupoCampanha.IDTipoFiltro = int.Parse(readerFiltroGrupoCampanha[0].ToString());
                filtroGrupoCampanha.Operador = readerFiltroGrupoCampanha[1].ToString();
                filtroGrupoCampanha.Valor = readerFiltroGrupoCampanha[2].ToString();
                filtroGrupoCampanha.Condicao = readerFiltroGrupoCampanha[3].ToString();
                chkExclusivoRobo.Checked = bool.Parse(readerFiltroGrupoCampanha[4].ToString());

                listFiltroGrupoCampanha.Add(filtroGrupoCampanha);
            }

            //Fecha conexão
            con.Close();
            return listFiltroGrupoCampanha;
        }

        private void SalvaGridView()
        {
            bool houveDelete = false;

            for (int i = 1; i <= Contador; i++)
            {
                //verifica se o viewstate vai ser deletado
                if ("delete" == ViewState["Grupo" + i].ToString())
                {
                    int proximaGrid = i;
                    proximaGrid++;
                    //carrega a proxima grid nele
                    GridView gridView = (GridView)controlador.FindControl("GridView-" + proximaGrid);

                    if (gridView != null)
                    {
                        DataTable dt = (DataTable)ViewState["Grupo" + gridView.ID.Split('-')[1]];

                        for (int x = 0; x < gridView.Rows.Count; x++)
                        {
                            DropDownList ddlTipoFiltro = (DropDownList)gridView.Rows[x].Cells[0].FindControl("ddlTipoFiltro") as DropDownList;
                            if (ddlTipoFiltro.SelectedValue != "0")
                                dt.Rows[x]["ddlTipoFiltro"] = ddlTipoFiltro.SelectedValue;

                            DropDownList ddlOperador = (DropDownList)gridView.Rows[x].Cells[1].FindControl("ddlOperador") as DropDownList;
                            if (ddlOperador.SelectedValue != "0")
                                dt.Rows[x]["ddlOperador"] = ddlOperador.SelectedValue;

                            TextBox txtValor = (TextBox)gridView.Rows[x].Cells[2].FindControl("txtValor");
                            if (!string.IsNullOrEmpty(txtValor.Text))
                                dt.Rows[x]["txtValor"] = txtValor.Text;
                        }

                        ViewState["Grupo" + i] = dt;
                        ViewState["Grupo" + proximaGrid] = "delete";

                        gridView.DataSource = dt;
                        gridView.DataBind();
                    }
                    else
                    {
                        ViewState.Remove("Grupo" + i);
                    }

                    houveDelete = true;
                }
                else
                {
                    GridView gridView = (GridView)controlador.FindControl("GridView-" + i);
                    DataTable dt = (DataTable)ViewState["Grupo" + gridView.ID.Split('-')[1]];

                    for (int x = 0; x < gridView.Rows.Count; x++)
                    {
                        DropDownList ddlTipoFiltro = (DropDownList)gridView.Rows[x].Cells[0].FindControl("ddlTipoFiltro") as DropDownList;
                        if (ddlTipoFiltro.SelectedValue != "0")
                            dt.Rows[x]["ddlTipoFiltro"] = ddlTipoFiltro.SelectedValue;

                        DropDownList ddlOperador = (DropDownList)gridView.Rows[x].Cells[1].FindControl("ddlOperador") as DropDownList;
                        if (ddlOperador.SelectedValue != "0")
                            dt.Rows[x]["ddlOperador"] = ddlOperador.SelectedValue;

                        TextBox txtValor = (TextBox)gridView.Rows[x].Cells[2].FindControl("txtValor");
                        if (!string.IsNullOrEmpty(txtValor.Text))
                            dt.Rows[x]["txtValor"] = txtValor.Text;
                    }

                    ViewState["Grupo" + gridView.ID.Split('-')[1]] = dt;

                    gridView.DataSource = dt;
                    gridView.DataBind();
                }
            }

            if (houveDelete)
            {
                int count = Contador;
                count--;
                ViewState["ContadorGrupo"] = count;
            }
        }

        #endregion

        #region Dynamic generating fields
        public class DynamicDropDownField : ITemplate
        {
            private string tooltip;
            private string id;
            private int width;

            public DynamicDropDownField(string tooltip, string id, int width)
            {
                this.tooltip = tooltip;
                this.id = id;
                this.width = width;
            }

            public void InstantiateIn(Control container)
            {
                //define the control to be added , i take text box as your need
                DropDownList ddl = new DropDownList();
                ddl.ID = id;
                ddl.ToolTip = tooltip;
                ddl.Width = width;
                ddl.EnableViewState = true;
                container.Controls.Add(ddl);
            }
        }

        public class DynamicTextField : ITemplate
        {
            private string tooltip;
            private string id;
            private int width;

            public DynamicTextField(string tooltip, string id, int width)
            {
                this.tooltip = tooltip;
                this.id = id;
                this.width = width;
            }

            public void InstantiateIn(Control container)
            {
                //define the control to be added , i take text box as your need
                TextBox txtBox = new TextBox();
                txtBox.ID = id;
                txtBox.ToolTip = tooltip;
                txtBox.Width = width;
                txtBox.EnableViewState = true;
                container.Controls.Add(txtBox);
            }
        }

        public class DynamicButton : ITemplate
        {
            public void InstantiateIn(Control container)
            {
                //define the control to be added , i take text box as your need
                Button botaoE = new Button();
                botaoE.ID = "btnE";
                botaoE.Text = "E";
                botaoE.CommandName = "btnE_Click";

                container.Controls.Add(botaoE);

                Button botaoOu = new Button();
                botaoOu.ID = "btnOU";
                botaoOu.Text = "OU";
                botaoOu.CommandName = "btnOU_Click";
                container.Controls.Add(botaoOu);
            }
        }

        public class DynamicButtonRemover : ITemplate
        {
            private bool visivel;

            public DynamicButtonRemover(bool visivel)
            {
                this.visivel = visivel;
            }

            public void InstantiateIn(Control container)
            {
                //define the control to be added , i take text box as your need
                Button remover = new Button();
                remover.ID = "removerRow";
                remover.Text = "Remover";
                remover.Visible = visivel;
                remover.CommandName = "removerRow";

                container.Controls.Add(remover);
            }
        }
        #endregion

        protected void btnMarcarPublico_Click(object sender, EventArgs e)
        {
            bool validacoes = true;
            int idCampanha = int.Parse(Session["IDCampanhaSelecionada"].ToString());
            string inconsistencia = "";

            for (int i = 1; i <= Contador; i++)
            {
                //verifica se o viewstate vai ser deletado
                if ("delete" != ViewState["Grupo" + i].ToString())
                {
                    GridView gridView = (GridView)controlador.FindControl("GridView-" + i);
                    DataTable dt = (DataTable)ViewState["Grupo" + gridView.ID.Split('-')[1]];

                    for (int x = 0; x < gridView.Rows.Count; x++)
                    {
                        DataRow dr = dt.Rows[x];

                        int idTipoFiltro = 0;
                        string operador = "";
                        string valor = "";

                        ValidacoesMarcarPublico(ref validacoes, gridView, x, ref idTipoFiltro, ref operador, ref valor, ref inconsistencia, i);
                    }
                }
            }

            if (validacoes)
            {
                DeleteFiltroGrupoCampanha(idCampanha);

                for (int i = 1; i <= Contador; i++)
                {
                    int ordem = 0;

                    //verifica se o viewstate vai ser deletado
                    if ("delete" != ViewState["Grupo" + i].ToString())
                    {
                        GridView gridView = (GridView)controlador.FindControl("GridView-" + i);
                        DataTable dt = (DataTable)ViewState["Grupo" + gridView.ID.Split('-')[1]];

                        for (int x = 0; x < gridView.Rows.Count; x++)
                        {
                            DataRow dr = dt.Rows[x];

                            ordem += 1;

                            DropDownList ddlTipoFiltro = (DropDownList)gridView.Rows[x].Cells[0].FindControl("ddlTipoFiltro") as DropDownList;
                            int idTipoFiltro = int.Parse(ddlTipoFiltro.SelectedValue);

                            DropDownList ddlOperador = (DropDownList)gridView.Rows[x].Cells[1].FindControl("ddlOperador") as DropDownList;
                            string operador = ddlOperador.SelectedItem.ToString();

                            TextBox txtValor = (TextBox)gridView.Rows[x].Cells[2].FindControl("txtValor");
                            string valor = txtValor.Text;

                            //Instanciando classe de conexão
                            ObterConexao obterConexao = new ObterConexao();

                            //Abrindo conexão para execução da procedure
                            var con = obterConexao.ObtendoConexao();

                            //Informando qual comando (procedure) irá executar e qual conexão
                            SqlCommand cmdFiltrosGrupoCampanha = new SqlCommand("sp_Ins_FiltroGrupoCampanha", con);
                            //Informando qual o tipo de comando
                            cmdFiltrosGrupoCampanha.CommandType = CommandType.StoredProcedure;

                            //Abre conexão                    
                            con.Open();

                            //Limpa os parametros
                            cmdFiltrosGrupoCampanha.Parameters.Clear();

                            //Populando os parametros para executação da procedure
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@IDCampanha", idCampanha);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Grupo", i);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@IDTipoFiltro", idTipoFiltro);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Operador", operador);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Valor", valor);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Condicao", dr["condicao"].ToString());
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Ordem", ordem);
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@Usuario", Session["NomeUsuario"].ToString());
                            cmdFiltrosGrupoCampanha.Parameters.AddWithValue("@ExclusivoRobo", chkExclusivoRobo.Checked);

                            //Executa o comando
                            cmdFiltrosGrupoCampanha.ExecuteNonQuery();

                            //Fecha conexão
                            con.Close();

                        }
                    }
                }

                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", " alertaSucesso('Salvo','Salvo com sucesso')", true);
            }
            else
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "alertaErro('Erro','" + inconsistencia + "')", true);

        }

        private static void DeleteFiltroGrupoCampanha(int idCampanha)
        {
            //Instanciando classe de conexão
            ObterConexao obterConexao = new ObterConexao();

            //Abrindo conexão para execução da procedure
            var con = obterConexao.ObtendoConexao();

            //Informando qual comando (procedure) irá executar e qual conexão
            SqlCommand cmdFiltrosGrupoCampanhaDelete = new SqlCommand("sp_Del_FiltroGrupoCampanha", con);
            //Informando qual o tipo de comando
            cmdFiltrosGrupoCampanhaDelete.CommandType = CommandType.StoredProcedure;

            //Abre conexão                    
            con.Open();

            //Limpa os parametros
            cmdFiltrosGrupoCampanhaDelete.Parameters.Clear();

            //Populando os parametros para executação da procedure
            cmdFiltrosGrupoCampanhaDelete.Parameters.AddWithValue("@IDCampanha", idCampanha);

            //Executa o comando
            cmdFiltrosGrupoCampanhaDelete.ExecuteNonQuery();

            //Fecha conexão
            con.Close();
        }

        private static void ValidacoesMarcarPublico(ref bool validacoes, GridView gridView, int x, ref int idTipoFiltro, ref string operador, ref string valor, ref string inconsistencia, int grupo)
        {
            DropDownList ddlTipoFiltro = (DropDownList)gridView.Rows[x].Cells[0].FindControl("ddlTipoFiltro") as DropDownList;
            if (ddlTipoFiltro.SelectedValue != "0")
                idTipoFiltro = int.Parse(ddlTipoFiltro.SelectedValue);
            else
            {
                validacoes = false;
                inconsistencia += "Grupo " + grupo + " - Existe filtro não selecionado. ";
            }

            DropDownList ddlOperador = (DropDownList)gridView.Rows[x].Cells[1].FindControl("ddlOperador") as DropDownList;
            if (ddlOperador.SelectedValue != "0")
                operador = ddlOperador.SelectedItem.ToString();
            else
            {
                validacoes = false;
                inconsistencia += "Grupo " + grupo + " - Existe operador não selecionado. ";
            }

            TextBox txtValor = (TextBox)gridView.Rows[x].Cells[2].FindControl("txtValor");
            if (!string.IsNullOrEmpty(txtValor.Text))
                valor = txtValor.Text;
            else
            {
                validacoes = false;
                inconsistencia += "Grupo " + grupo + " - Existe valor não selecionado. ";
            }
        }
    }

}