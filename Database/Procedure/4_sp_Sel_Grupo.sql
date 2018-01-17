IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Grupo')
	DROP PROCEDURE sp_Sel_Grupo
	GO

CREATE PROCEDURE sp_Sel_Grupo
AS   

	SELECT [IDGrupo], [Descricao] FROM [dbo].[Grupo]