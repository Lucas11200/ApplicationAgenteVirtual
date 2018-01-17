IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Campanha')
	DROP PROCEDURE sp_Sel_Campanha
	GO

CREATE PROCEDURE sp_Sel_Campanha(
	@IDOperacao	INT = NULL
)
AS   

	SELECT	[IDCampanha], [Descricao],[IDOperacao], [Telefone]
	FROM	[dbo].[Campanha]
	WHERE	(IDOperacao = @IDOperacao OR @IDOperacao IS NULL)