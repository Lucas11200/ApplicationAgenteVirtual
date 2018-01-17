IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Del_FiltroGrupoCampanha')
	DROP PROCEDURE sp_Del_FiltroGrupoCampanha
	GO

CREATE PROCEDURE sp_Del_FiltroGrupoCampanha(    
	@IDCampanha		INT
)
AS   

    SET NOCOUNT ON;

	DELETE FiltroGrupoCampanha WHERE IDCampanha = @IDCampanha