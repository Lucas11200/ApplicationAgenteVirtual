IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FiltroGrupoCampanha')
	DROP PROCEDURE sp_Sel_FiltroGrupoCampanha
	GO

CREATE PROCEDURE sp_Sel_FiltroGrupoCampanha(
	@IDCampanha		INT,
	@Grupo			INT
) AS   

	SELECT		
		IDTipoFiltro
		,Operador
		,Valor
		,Condicao
		,ExclusivoRobo s
	FROM 
	FiltroGrupoCampanha 
	WHERE	IDCampanha = @IDCampanha
	AND		Grupo = @Grupo
	ORDER BY Ordem
