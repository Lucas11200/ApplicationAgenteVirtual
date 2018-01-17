IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_CPC')
	DROP PROCEDURE sp_Sel_CPC
	GO

CREATE PROCEDURE sp_Sel_CPC(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	