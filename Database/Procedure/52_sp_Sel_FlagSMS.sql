IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagSMS')
	DROP PROCEDURE sp_Sel_FlagSMS
	GO

CREATE PROCEDURE sp_Sel_FlagSMS(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	