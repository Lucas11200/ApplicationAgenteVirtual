<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="grupos.aspx.cs" Inherits="ApplicationAgenteVirtual.grupos" %>

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
    <div class="navbar">
        <br /><br />
        <div align="center">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hdnIDGrupo" />
            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:TextBox runat="server" ID="txtdescricaoGrupo"></asp:TextBox>
                     <asp:Button CssClass="btn btn-danger btn-sm" runat="server" ID="btnSalvarGrupo" OnClick="btnSalvarGrupo_Click" Text="Salvar Grupo" />
                </div>              
            </div>
            <br />
            <div style="padding-top: 10px">
                <asp:GridView ID="GrupoGridView"
                    DataSourceID="GrupoSource"
                    AutoGenerateColumns="false"
                    OnRowCommand="GrupoGridView_RowCommand"
                    EmptyDataText="Não há grupos cadastrados"
                    DataKeyNames="IDGrupo"
                    Width="60%"
                    runat="server">

                    <Columns>
                        <asp:ButtonField ButtonType="Image" CommandName="Editar" HeaderStyle-CssClass="borderRigthVisible" ItemStyle-CssClass="borderRigthVisible buttonWith" HeaderText="Ações" ImageUrl="~/images/imgEdit.png" Text="Editar" />
                        <asp:ButtonField ButtonType="Image" CommandName="Deletar" ShowHeader="false" ItemStyle-CssClass="buttonWith" ImageUrl="~/images/imgDelete.png" />
                        <asp:BoundField DataField="Descricao" HeaderText="Descrição" />
                    </Columns>

                </asp:GridView>

                <asp:SqlDataSource ID="GrupoSource"
                    SelectCommand="SELECT [IDGrupo], [Descricao] FROM [dbo].[Grupo]"
                    ConnectionString="<%$ ConnectionStrings:AgenteVirtualConfig%>"
                    runat="server" />
            </div>
        </div>
        <br />
        <br />
    </div>
</asp:Content>
