IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Tela')
	DROP PROCEDURE sp_Sel_Tela
	GO

CREATE PROCEDURE sp_Sel_Tela
AS   

	SELECT [IDTela], [Descricao] FROM [dbo].[Tela]