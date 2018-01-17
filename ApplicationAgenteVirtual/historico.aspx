<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="historico.aspx.cs" Inherits="ApplicationAgenteVirtual.historico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="navbar">
        <br />
        <br />
        <div class="row" runat="server" id="divBotoes">
            <div class="col-lg-3 text-center">
                <asp:DropDownList CssClass="dropdown-toggle " runat="server" ID="ddlUsuarios" AutoPostBack="true" Style="width: 200px; margin-left: 5%; height: 24px;"></asp:DropDownList>
            </div>
            <div class="col-lg-3 text-center">
                <asp:TextBox ID="txtDataInicio" runat="server" Text="Data Início"></asp:TextBox>
            </div>
            <div class="col-lg-3 text-center">
                <asp:TextBox ID="txtDataFim" runat="server" Text="Data Fim"></asp:TextBox>
            </div>
            <div class="col-lg-3 text-left">
                <asp:Button CssClass="btn btn-danger btn-sm" runat="server" ID="btnGerar" OnClick="btnGerar_Click" Text="Nova Pesquisa" />
                <asp:Button CssClass="btn btn-danger btn-sm" runat="server" ID="btnLimpar" OnClick="btnLimpar_Click" Text="Limpar" />
            </div>
        </div>
        <br />
        <br />


        <div style="padding-top: 3%">
            <asp:Literal runat="server" ID="ltlHistorico" />
            <%--<table style="margin-left: 20%;">
            <tr>
                <td colspan="2">
                    <asp:Label runat="server" ID="Label7" Text="adriano.silva"><b>Usuário:</b></asp:Label>
                    <asp:Label runat="server" ID="lblNomeUsuario" Text="adriano.silva" />
                </td>
                <td colspan="2">
                    <asp:Label runat="server" ID="Label8"><b>Data:</b></asp:Label>
                    <asp:Label runat="server" ID="Label9" Text="18/12/20107" />
                </td>
                <td colspan="2">
                    <asp:CheckBox runat="server" ID="chkExclusivoRobo" Text="Exclusivo Robô" Enabled="false" Checked="false" Style="float: right; margin-left: 10%;" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 2%;" colspan="6">
                    <asp:Label runat="server" ID="Label10"><b>Publico Selecionado</b></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 2%;" colspan="6">
                    <asp:Label runat="server" ID="Label1"><b>Grupo 1</b></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:TextBox ID="TextBox1" ToolTip="Filtro" runat="server" Enabled="false" Text="Estado"></asp:TextBox>
                </td>
                <td colspan="2">
                    <asp:TextBox ID="TextBox2" runat="server" Enabled="false" Text="="></asp:TextBox>
                </td>
                <td colspan="2">
                    <asp:TextBox ID="TextBox3" runat="server" Enabled="false" Text="SP"></asp:TextBox>
                </td>
            </tr>
            
            
            
        </table>--%>
        </div>
        <br />
        <br />
    </div>
</asp:Content>
