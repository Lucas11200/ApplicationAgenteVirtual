IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagSuspeitaFraude')
	DROP PROCEDURE sp_Sel_FlagSuspeitaFraude
	GO

CREATE PROCEDURE sp_Sel_FlagSuspeitaFraude(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	