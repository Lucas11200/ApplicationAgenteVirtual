IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagSMSBoleto')
	DROP PROCEDURE sp_Sel_FlagSMSBoleto
	GO

CREATE PROCEDURE sp_Sel_FlagSMSBoleto(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	