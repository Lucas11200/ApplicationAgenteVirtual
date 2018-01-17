IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Usuario')
	DROP PROCEDURE sp_Sel_Usuario
	GO

CREATE PROCEDURE sp_Sel_Usuario
AS   

	SELECT [IDUsuario], [UserName] FROM [dbo].[Usuario] ORDER BY [UserName]