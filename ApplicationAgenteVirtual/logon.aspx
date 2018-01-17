<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="logon.aspx.cs" Inherits="ApplicationAgenteVirtual.logon" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style type='text/css'>
        .table {
            display: table;
        }

        .row {
            display: table-row;
        }

        .cell {
            display: table-cell;
            border: 1px; /*border: 1px solid red;*/
            padding: 1em;
        }

            .cell.empty {
                border: none;
                width: 100px;
            }

            .cell.rowspanned {
                position: absolute;
                padding-left: initial;
                top: 0;
                bottom: 0;
                width: 100px;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div align="center">
            <div class="table" style="width: 100%">
                <div class="row">
                    <img runat="server" src="images/logo_system_white.jpg" style="width: 25%" />
                </div>
                <div class="row">
                    <asp:Label runat="server" Text="Você não possui permissão, contate o administrador do sistema"></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
