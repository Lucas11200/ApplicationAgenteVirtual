<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="grupoTela.aspx.cs" Inherits="ApplicationAgenteVirtual.grupoTela" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="navbar">
        <br />
        <br />
        <div runat="server" class="row">
            <div class="col-md-12 text-center ">
                <asp:Label runat="server" ID="lblGrupos"><b>Grupo</b></asp:Label>
                <asp:DropDownList runat="server" ID="ddlGrupo" AutoPostBack="true" OnSelectedIndexChanged="ddlGrupo_SelectedIndexChanged" Style="width: 200px; margin-left: 5%;"></asp:DropDownList>
                <asp:Button CssClass="btn btn-danger btn-sm" runat="server" ID="btnSalvarGrupoTela" OnClick="btnSalvarGrupoTela_Click" Text="Salvar Grupo Tela" Visible="false" />
            </div>
        </div>
        <br />
        <br />
        <div runat="server" id="divTelas" align="center" visible="false">
            <asp:CheckBoxList ID="chkListTela"
                CellPadding="15"
                CellSpacing="10"
                RepeatColumns="2"
                RepeatDirection="Vertical"
                RepeatLayout="Table"
                TextAlign="Right"
                runat="server">
            </asp:CheckBoxList>
        </div>
        <br />
        <br />
        <br />
    </div>
</asp:Content>
