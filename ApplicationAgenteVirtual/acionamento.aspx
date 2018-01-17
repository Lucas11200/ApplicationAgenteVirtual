<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="acionamento.aspx.cs" Inherits="ApplicationAgenteVirtual.acionamento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="navbar" >
        <div runat="server" id="divAcionamento">
            <br />
            <br />
            <div style="margin-left: 120px;">
                <div class="table table-responsive">
                    <table>
                        <tr>
                            <td style="width: 15%; background-color: #F44336;"></td>
                            <td style="background-color: #F44336; font-weight: bold; padding-left: 3%; border: 1px solid #808080;">Início</td>
                            <td style="background-color: #F44336; font-weight: bold; padding-left: 3%; border: 1px solid #808080;">Fim</td>
                            <td style="background-color: #F44336; font-weight: bold; padding-left: 3%; border: 1px solid #808080;">Vigência Inicial</td>
                            <td style="background-color: #F44336; font-weight: bold; padding-left: 3%; border: 1px solid #808080;">Vigência Final</td>
                            <td style="width: 15%; background-color: #F44336;"></td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento1" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Segunda</td>
                            <td>
                                <%--<input id="txtHoraInicio1" name="txtHoraInicio1" type="time" value="08:00" /></td>--%>
                                <asp:TextBox ID="txtHoraInicio1" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim1" name="txtHoraFim1" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim1" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio1" name="txtVigenciaInicio1" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio1" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim1" name="txtVigenciaFim1" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim1" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia1" runat="server" Text="0,00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento2" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Terça</td>
                            <td>
                                <%--<input id="txtHoraInicio2" name="txtHoraInicio2" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio2" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim2" name="txtHoraFim2" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim2" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio2" name="txtVigenciaInicio2" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio2" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim2" name="txtVigenciaFim2" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim2" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia2" runat="server" Text="0,00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento3" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Quarta</td>
                            <td>
                                <%--<input id="txtHoraInicio3" name="txtHoraInicio3" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio3" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim3" name="txtHoraFim3" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim3" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio3" name="txtVigenciaInicio3" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio3" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim3" name="txtVigenciaFim3" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim3" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia3" runat="server" Text="0,00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento4" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Quinta</td>
                            <td>
                                <%--<input id="txtHoraInicio4" name="txtHoraInicio4" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio4" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim4" name="txtHoraFim4" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim4" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio4" name="txtVigenciaInicio4" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio4" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim4" name="txtVigenciaFim4" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim4" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia4" runat="server" Text="0,00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento5" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Sexta</td>
                            <td>
                                <%--<input id="txtHoraInicio5" name="txtHoraInicio5" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio5" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim5" name="txtHoraFim5" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim5" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio5" name="txtVigenciaInicio5" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio5" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim5" name="txtVigenciaFim5" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim5" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia5" runat="server" Text="0,00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento6" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Sabado</td>
                            <td>
                                <%--<input id="txtHoraInicio6" name="txtHoraInicio6" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio6" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim6" name="txtHoraFim6" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim6" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio6" name="txtVigenciaInicio6" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio6" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim6" name="txtVigenciaFim6" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim6" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia6" runat="server" Text="0,00"></asp:Label>

                            </td>
                        </tr>
                        <tr>
                            <asp:HiddenField runat="server" ID="hdnIDHorarioAcionamento7" ClientIDMode="Static" />
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">Domingo</td>
                            <td>
                                <%--<input id="txtHoraInicio7" name="txtHoraInicio7" type="time" value="08:00" />--%>
                                <asp:TextBox ID="txtHoraInicio7" runat="server" type="time" value="08:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtHoraFim7" name="txtHoraFim7" type="time" value="18:00" />--%>
                                <asp:TextBox ID="txtHoraFim7" runat="server" type="time" value="18:00"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaInicio7" name="txtVigenciaInicio7" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaInicio7" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td>
                                <%--<input id="txtVigenciaFim7" name="txtVigenciaFim7" onkeydown="return false" type="date" />--%>
                                <asp:TextBox ID="txtVigenciaFim7" runat="server" type="date"></asp:TextBox>
                            </td>
                            <td style="padding-left: 3%; width: 15%; background-color: #F44336; font-weight: bold; border: 1px solid #808080;">R$<asp:Label ID="lblCustoExtraDia7" runat="server" Text="237,00"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <br />
            <br />
            <div class="row">

                <div style="padding-top: 1%; float: right;" class="col-lg-12 text-center">
                    <asp:Button runat="server" ID="btnSalvarAcionamento" OnClick="btnSalvarAcionamento_Click" Text="Salvar Acionamento" CssClass="btn btn-danger" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
