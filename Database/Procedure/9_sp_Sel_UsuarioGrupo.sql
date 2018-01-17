IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_UsuarioGrupo')
	DROP PROCEDURE sp_Sel_UsuarioGrupo
	GO

CREATE PROCEDURE sp_Sel_UsuarioGrupo

AS   

	SELECT 
	U.IDUsuario		AS IDUsuario, 
	U.UserName		AS UserName, 
	G.Descricao		AS Grupo
	FROM Usuario U 
	INNER JOIN UsuarioGrupo UG ON U.IDUsuario = UG.IDUsuario 
	INNER JOIN Grupo G ON UG.IDGrupo = G.IDGrupo