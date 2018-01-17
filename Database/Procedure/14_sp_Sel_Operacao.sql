IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Operacao')
	DROP PROCEDURE sp_Sel_Operacao
	GO

CREATE PROCEDURE sp_Sel_Operacao(
	@IDCliente	INT = NULL
)
AS   

	SELECT	[IDOperacao], [Descricao], [IDCliente]
	FROM	[dbo].[Operacao]
	WHERE	(IDCliente = @IDCliente OR @IDCliente IS NULL)