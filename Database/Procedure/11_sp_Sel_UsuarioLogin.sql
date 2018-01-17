IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_UsuarioLogin')
	DROP PROCEDURE sp_Sel_UsuarioLogin
	GO

CREATE PROCEDURE sp_Sel_UsuarioLogin(
@Usuario VARCHAR(200)
)

AS   

	SELECT 	
	U.UserName,
	T.Descricao
	FROM Usuario U
	LEFT JOIN UsuarioGrupo UG ON U.IDUsuario = UG.IDUsuario
	LEFT JOIN Grupo G ON UG.IDGrupo = G.IDGrupo
	LEFT JOIN GrupoTela GT ON G.IDGrupo = GT.IDGrupo
	LEFT JOIN Tela T ON GT.IDTela = T.IDTela
	WHERE LOWER(UserName) = LOWER(@Usuario)
	ORDER BY T.Descricao
	