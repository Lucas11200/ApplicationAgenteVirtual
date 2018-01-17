<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="grupo.aspx.cs" %>

<html>
<head runat="server">
    <title>::: System Interact ::: Agente Virtual :::</title>
    <link rel="stylesheet" type="text/css" href="css/interno.css">
    <link rel="stylesheet" type="text/css" href="css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="css/datatables.css">
    <script src="scripts/jquery-3.2.1.js" type="text/javascript"></script>
    <script src="scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="scripts/datatables.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#frame").load("/instructions.html", function (response, status, xhr) {
                if (status == "error") {
                    var msg = "Erro ao carregar a página!";
                    console.log(msg)
                } else {
                    var msg = "Página de instruções carregada com sucesso!";
                    console.log(msg)
                }
            });
        });
    </script>
</head>
<body runat="server">
    <header>
        <div id="headertitle">
            <h2>Agente Virtual - Gerenciamento </h2>
        </div>
        <div id="imgheaderbox">
            <img src="images/systeminteractlg.png" alt="System Interact" title="System Interact">
        </div>
    </header>
    <aside>
        <div id="navmenubar">
            <form runat="server">
                <ul>
                    <asp:LinkButton ID="btnCampanha" href="campanha.aspx" runat="server"><b>Campanha</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnDefinirPublico" href="definirPublico.aspx" runat="server"><b>Definir Público</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnAcionamento" href="acionamento.aspx" runat="server"><b>Acionamento</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnHistorico" href="historico.aspx" runat="server"><b>Histórico</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnGrupo" href="grupos.aspx" runat="server"><b>Grupos</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnGrupoTela" href="grupoTela.aspx" runat="server"><b>Grupos Tela</b></asp:LinkButton><br>
                    <br>
                    <asp:LinkButton ID="btnUsuarios" href="usuarios.aspx" runat="server"><b>Usuários</b></asp:LinkButton><br>
                    <br>
                </ul>
            </form>
        </div>
    </aside>
    <section runat="server">
        <form runat="server">
            <div align="center" id="divForm" runat="server">
                <div>
                    <asp:HiddenField runat="server" ClientIDMode="Static" ID="hdnIDGrupo"/>
                    <asp:TextBox runat="server" ID="txtDescricaoGrupo"></asp:TextBox>
                    <asp:Button runat="server" ID="btnSalvarGrupo" Text="Salvar Grupo" />

                </div>
            </div>
        </form>
    </section>
    <footer>
        &#169;2017 - System Marketing Consulting Ltda.
    </footer>
</body>
</html>
