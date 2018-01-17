IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Ins_UsuarioGrupo')
	DROP PROCEDURE sp_Ins_UsuarioGrupo
	GO

CREATE PROCEDURE sp_Ins_UsuarioGrupo(
	@UserName	VARCHAR(200),
    @IDGrupo	INT
)
AS   
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT IDUsuario, UserName FROM Usuario WHERE LOWER(UserName) = LOWER(@UserName))
	BEGIN
		INSERT INTO Usuario VALUES (LOWER(@UserName))	

		DECLARE @IDUsuario INT 
	
		SELECT @IDUsuario = SCOPE_IDENTITY()

		INSERT INTO UsuarioGrupo VALUES (@IDUsuario, @IDGrupo)

		SELECT 0, ''
	END
	ELSE
	BEGIN
		SELECT 1, 'Usuário já está cadastrado'
	END

	