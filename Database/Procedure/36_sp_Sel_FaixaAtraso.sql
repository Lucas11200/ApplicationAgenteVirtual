IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FaixaAtraso')
	DROP PROCEDURE sp_Sel_FaixaAtraso
	GO

CREATE PROCEDURE sp_Sel_FaixaAtraso(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	