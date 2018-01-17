IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Upt_Grupo')
	DROP PROCEDURE sp_Upt_Grupo
	GO

CREATE PROCEDURE sp_Upt_Grupo(
    @Descricao	VARCHAR(200),
	@IDGrupo	INT
)
AS   

    SET NOCOUNT ON;

	UPDATE Grupo SET Descricao = @Descricao WHERE IDGrupo = @IDGrupo
