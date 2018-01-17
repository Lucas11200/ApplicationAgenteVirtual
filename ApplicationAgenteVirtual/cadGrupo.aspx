<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cadGrupo.aspx.cs" Inherits="ApplicationAgenteVirtual.cadGrupo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .borderRigthVisible{
            border-right-style: hidden;
        }

        .buttonWith{
            width: 10px
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div align="center" id="divForm" runat="server">
            <div>
                <asp:HiddenField runat="server" ClientIDMode="Static" ID="hdnIDGrupo" />
                <asp:TextBox runat="server" ID="txtdescricaoGrupo"></asp:TextBox>
                <asp:Button runat="server" ID="btnSalvarGrupo" OnClick="btnSalvarGrupo_Click" Text="Salvar Grupo" />
            </div>
            <div>
                <asp:GridView ID="GrupoGridView"
                    DataSourceID="GrupoSource"
                    AutoGenerateColumns="false"
                    onrowcommand="GrupoGridView_RowCommand"
                    EmptyDataText="Não há grupos cadastrados"
                    datakeynames="IDGrupo"
                    Width="60%"
                    runat="server">

                    <Columns>
                        <asp:ButtonField ButtonType="Image" CommandName="Editar" HeaderStyle-CssClass="borderRigthVisible" ItemStyle-CssClass="borderRigthVisible buttonWith" HeaderText="Ações" ImageUrl="~/images/imgEdit.png"/>
                        <asp:ButtonField ButtonType="Image" CommandName="Deletar" ShowHeader="false" ItemStyle-CssClass="buttonWith" ImageUrl="~/images/imgDelete.png"/>                        
                        <asp:BoundField DataField="Descricao" HeaderText="Descrição" />
                    </Columns>

                </asp:GridView>

                <asp:SqlDataSource ID="GrupoSource"
                    SelectCommand="SELECT [IDGrupo], [Descricao] FROM [dbo].[Grupo]"
                    ConnectionString="<%$ ConnectionStrings:AgenteVirtualConfig%>"
                    runat="server" />
            </div>
        </div>
    </form>
</body>
</html>
