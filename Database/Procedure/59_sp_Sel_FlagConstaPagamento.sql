IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagConstaPagamento')
	DROP PROCEDURE sp_Sel_FlagConstaPagamento
	GO

CREATE PROCEDURE sp_Sel_FlagConstaPagamento(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	