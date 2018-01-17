IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Del_UsuarioGrupo')
	DROP PROCEDURE sp_Del_UsuarioGrupo
	GO

CREATE PROCEDURE sp_Del_UsuarioGrupo(    
	@IDUsuario	INT
)
AS   

    SET NOCOUNT ON;

	DELETE UsuarioGrupo WHERE IDUsuario = @IDUsuario

	DELETE Usuario WHERE IDUsuario = @IDUsuario