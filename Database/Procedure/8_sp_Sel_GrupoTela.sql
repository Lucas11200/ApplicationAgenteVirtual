IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_GrupoTela')
	DROP PROCEDURE sp_Sel_GrupoTela
	GO

CREATE PROCEDURE sp_Sel_GrupoTela(
@IDGrupo	INT
)

AS   

	SELECT [IDGrupo], [IDTela] FROM [dbo].[GrupoTela] WHERE IDGrupo = @IDGrupo