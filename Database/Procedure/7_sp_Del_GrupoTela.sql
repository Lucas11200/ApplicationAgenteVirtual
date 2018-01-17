IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Del_GrupoTela')
	DROP PROCEDURE sp_Del_GrupoTela
	GO

CREATE PROCEDURE sp_Del_GrupoTela(    
	@IDGrupo	INT
)
AS   

    SET NOCOUNT ON;

	DELETE GrupoTela WHERE IDGrupo = @IDGrupo