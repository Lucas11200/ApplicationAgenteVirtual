IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Ins_Grupo')
	DROP PROCEDURE sp_Ins_Grupo
	GO

CREATE PROCEDURE sp_Ins_Grupo(
    @Descricao VARCHAR(200)
)
AS   

    SET NOCOUNT ON;

	INSERT INTO Grupo VALUES (@Descricao)
	