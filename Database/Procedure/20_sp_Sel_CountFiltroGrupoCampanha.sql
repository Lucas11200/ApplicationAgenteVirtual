IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_CountFiltroGrupoCampanha')
	DROP PROCEDURE sp_Sel_CountFiltroGrupoCampanha
	GO

CREATE PROCEDURE sp_Sel_CountFiltroGrupoCampanha(
	@IDCampanha		INT
) AS   

	SELECT COUNT(1) AS QTDGRUPO FROM
	(SELECT 
	Grupo
	FROM FiltroGrupoCampanha
	WHERE IDCampanha = @IDCampanha
	GROUP BY Grupo) 
AS TBL