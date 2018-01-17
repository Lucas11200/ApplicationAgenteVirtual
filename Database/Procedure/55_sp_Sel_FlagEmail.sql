IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagEmail')
	DROP PROCEDURE sp_Sel_FlagEmail
	GO

CREATE PROCEDURE sp_Sel_FlagEmail(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	