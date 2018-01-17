<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="definirPublico.aspx.cs" Inherits="ApplicationAgenteVirtual.definirPublico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">

    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
            border: 1.5px solid #ddd;
        }

        td, th {
            border: 1.5px solid #ddd;
            text-align: center;
            padding: 8px;
        }

        tr:nth-child(odd) {
            background-color: #eee;
        }
    </style>

    <!-- Content -->
    <div class="navbar" runat="server" id="divDefinirPublico">
        <div>
            <br />
            <br />
            <div class="row">
                <div class="col-md-12 text-right">
                    <span class="ui-icon-info"></span>
                    <asp:CheckBox runat="server" ID="chkExclusivoRobo" Style="margin-right: 3%" Text="Exclusivo Robô" CssClass="checkbox checkbox-inline" />
                </div>
            </div>
            <div class="table">
                <asp:PlaceHolder ID="controlador" runat="server" />
            </div>
            <br />
            <br />
            <div class="row">
                <div class="col-md-12 text-right ">
                    <asp:Button runat="server" ID="btnIncluirGrupo" OnClick="btnIncluirGrupo_Click" CssClass="btn btn-danger btn-sm" Text="Incluir Grupo" />
                    <span style="margin-right: 3%; vertical-align: top;" data-toggle="modal" data-target="#Modal"><i class="fa fa-info-circle" style="color: dodgerblue"></i></span>
                </div>
            </div>

            <br />
            <br />
            <div class="row">
                <div class="col-md-12 text-center">
                    <asp:Button runat="server" ID="btnMarcarPublico" OnClick="btnMarcarPublico_Click" CssClass="btn btn-danger" Text="Marcar Público" />
                </div>
            </div>
        </div>
    </div>
    <!-- End Content-->

    <!-- Modal -->
    <div class="modal fade" id="Modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header text-center">
                    <h5 class="modal-title" id="exampleModalLabel">Informações</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row text-left">
                        <div class=" col-md-10">
                            <asp:Label runat="server" ID="lblTituloExplicativo" Text="O primeiro grupo existe por padrão. Para adicionar novos grupos favor clicar no botão Incluir Grupo."></asp:Label>
                        </div>
                        <br />
                        <br />
                        <br />
                        <div class="col-md-10">
                            <asp:Label runat="server" ID="lblTituloExplicativo2" Text="Selecione qual o campo a ser utilizado como filtro, o operador matematico e o valor."></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-close"></i>Fechar</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

