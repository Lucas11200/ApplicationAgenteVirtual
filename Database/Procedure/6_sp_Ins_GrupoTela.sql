IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Ins_GrupoTela')
	DROP PROCEDURE sp_Ins_GrupoTela
	GO

CREATE PROCEDURE sp_Ins_GrupoTela(
    @IDGrupo	INT,
	@IDTela		INT
)
AS   
    SET NOCOUNT ON;

	INSERT INTO GrupoTela VALUES (@IDGrupo, @IDTela)	