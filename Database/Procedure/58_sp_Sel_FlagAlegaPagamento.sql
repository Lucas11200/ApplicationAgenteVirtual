IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagAlegaPagamento')
	DROP PROCEDURE sp_Sel_FlagAlegaPagamento
	GO

CREATE PROCEDURE sp_Sel_FlagAlegaPagamento(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	