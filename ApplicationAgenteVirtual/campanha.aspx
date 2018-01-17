<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="campanha.aspx.cs" Inherits="ApplicationAgenteVirtual.campanha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">

    <div class="navbar ">
        <br />
        <br />
        <div class="row">
            <div class="col-md-6 text-right">
                <asp:Label runat="server" ID="lblCliente"><b>Cliente : </b></asp:Label>
            </div>
            <div class="col-md-6 text-left">
                <div class="dropdown">
                    <asp:DropDownList runat="server" ID="ddlCliente" AutoPostBack="true" OnSelectedIndexChanged="ddlCliente_SelectedIndexChanged" CssClass="btn btn-danger btn-sm dropdown-toggle"></asp:DropDownList>
                </div>
            </div>
        </div>
        <br />
        <div class="row">
            <div class="col-md-6 text-right">
                <asp:Label runat="server" ID="lblOperacao" Style="margin-left: 2%;"><b>Operacão:</b></asp:Label>
            </div>
            <div class="col-md-6 text-left">
                <div class="dropdown">
                    <asp:DropDownList runat="server" ID="ddlOperacao" AutoPostBack="true" OnSelectedIndexChanged="ddlOperacao_SelectedIndexChanged" CssClass="btn btn-danger btn-sm dropdown-toggle"></asp:DropDownList>
                </div>
            </div>
        </div>
        <br />
        <div class="row">
            <div class="col-md-6 text-right">
                <asp:Label runat="server" ID="lblCampanha" Style="margin-left: 2.5%;"><b>Campanha :</b></asp:Label>
            </div>
            <div class="col-md-6 text-left">
                <div class="dropdown ">
                    <asp:DropDownList runat="server" ID="ddlCampanha" CssClass="btn btn-danger btn-sm dropdown-toggle"></asp:DropDownList>
                </div>
            </div>
        </div>
        <br />
        <br />
        <div class="row">
            <div class="col-md-12 text text-center">
                <asp:Button runat="server" ID="btnSelecionarCampanha" OnClick="btnSelecionarCampanha_Click" Text="Selecionar Campanha" CssClass="btn btn-danger" />
            </div>
        </div>
        <br />
    </div>
</asp:Content>
