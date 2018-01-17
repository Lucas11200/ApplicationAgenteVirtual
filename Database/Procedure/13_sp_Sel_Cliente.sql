IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Cliente')
	DROP PROCEDURE sp_Sel_Cliente
	GO

CREATE PROCEDURE sp_Sel_Cliente
AS   

	SELECT [IDCliente], [Descricao] FROM [dbo].[Cliente]