IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Ins_FiltroGrupoCampanha')
	DROP PROCEDURE sp_Ins_FiltroGrupoCampanha
	GO

CREATE PROCEDURE sp_Ins_FiltroGrupoCampanha(		
	@IDCampanha					INT,
	@Grupo						INT,
	@IDTipoFiltro				INT,
	@Operador					VARCHAR(5),
	@Valor						VARCHAR(200),
	@Condicao					VARCHAR(200) = NULL,
	@Ordem						INT,
	@Usuario					VARCHAR(200),
	@ExclusivoRobo				BIT
)
AS   
    SET NOCOUNT ON;

	DECLARE @Campanha VARCHAR(200) =	(SELECT TOP 1 Descricao FROM Campanha WHERE IDCampanha = @IDCampanha)
	DECLARE @TipoFiltro VARCHAR(200) =	(SELECT TOP 1 Descricao FROM TipoFiltro WHERE IDTipoFiltro = @IDTipoFiltro)
		
	INSERT INTO FiltroGrupoCampanha VALUES (@IDCampanha, @Grupo, @IDTipoFiltro, @Operador, @Valor, @Condicao, @Ordem, @ExclusivoRobo)
		
	INSERT INTO FiltroGrupoCampanhaHistorico VALUES (@IDCampanha, @Campanha, @Grupo, @TipoFiltro, @Operador, @Valor, @Condicao, @Ordem, @Usuario, GETDATE(), @ExclusivoRobo)