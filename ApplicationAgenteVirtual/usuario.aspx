<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="usuario.aspx.cs" Inherits="ApplicationAgenteVirtual.usuario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .borderRigthVisible {
            border-right-style: hidden;
        }

        .buttonWith {
            width: 10px;
        }

        table {
            width: 100%;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>

    <div class="navbar ">
        <br />
        <br />
        <asp:HiddenField runat="server" ID="hdnUserName" />
        <div class="row">
            <div class="col-md-4 text-right">
                <asp:Label runat="server"><b>E-mail</b></asp:Label>

            </div>
            <div class="col-md-4">
                <asp:TextBox runat="server" ID="txtEmailUsuario" Style="width: 300px;"></asp:TextBox>
            </div>
            <div class="col-md-4 text-left">
                <asp:Button CssClass="btn btn-danger btn-sm " runat="server" ID="btnBuscar" OnClick="btnBuscar_Click" Text="buscar" />
            </div>
        </div>
        <br />
        <div class="row">
            <div class="col-md-12  text-center">
                <asp:Label runat="server" ID="lblNomeUsuario" />
            </div>
        </div>
        <br />
        <div class="row" id="divGrupos" runat="server" visible="false">
            <div class="col-md-4 text-right">
                <asp:Label runat="server" ID="lblGrupos"><b>Grupo</b></asp:Label>
            </div>
            <div class="col-md-4">
                <asp:DropDownList runat="server" ID="ddlGrupo" AutoPostBack="true" Style="width: 300px;"></asp:DropDownList>
            </div>
            <div class="col-md-4">
                <asp:Button CssClass="btn btn-danger btn-sm" runat="server" ID="btnSalvar" OnClick="btnSalvarGrupo_Click" Text="Salvar" />
            </div>
        </div>
        <br />
        <br />
        <div align="center">
            <div class="table table-responsive">
                <asp:GridView ID="UsuarioGrupoGridView"
                    DataSourceID="UsuarioGrupoSource"
                    AutoGenerateColumns="false"
                    OnRowCommand="UsuarioGrupoGridView_RowCommand"
                    EmptyDataText="Não há usuários cadastrados"
                    DataKeyNames="IDUsuario"
                    Width="60%"
                    runat="server">

                    <Columns>
                        <asp:ButtonField ButtonType="Image" CommandName="Deletar" ShowHeader="false" ItemStyle-CssClass="buttonWith" HeaderText="Ações" ImageUrl="~/images/imgDelete.png" />
                        <asp:BoundField DataField="UserName" HeaderText="Usuário" />
                        <asp:BoundField DataField="Grupo" HeaderText="Grupo" />
                    </Columns>

                </asp:GridView>

                <asp:SqlDataSource ID="UsuarioGrupoSource"
                    SelectCommand="sp_Sel_UsuarioGrupo"
                    ConnectionString="<%$ ConnectionStrings:AgenteVirtualConfig%>"
                    runat="server" />
            </div>
        </div>
    </div>
</asp:Content>
