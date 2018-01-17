IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Del_Grupo')
	DROP PROCEDURE sp_Del_Grupo
	GO

CREATE PROCEDURE sp_Del_Grupo(    
	@IDGrupo	INT
)
AS   

    SET NOCOUNT ON;

	DECLARE @Validacao BIT

	SET @Validacao = CASE WHEN EXISTS(SELECT 1 FROM UsuarioGrupo WHERE IDGrupo = @IDGrupo)
					 THEN 1
					 ELSE 0
					 END

	IF (@Validacao = 1)
	BEGIN
		SELECT 'true'
	END
	ELSE
	BEGIN
		DELETE GrupoTela WHERE IDGrupo = @IDGrupo

		DELETE Grupo WHERE IDGrupo = @IDGrupo

		SELECT 'false'
	END
	
	