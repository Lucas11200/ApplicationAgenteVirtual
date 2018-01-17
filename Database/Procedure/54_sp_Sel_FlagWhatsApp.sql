IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagWhatsApp')
	DROP PROCEDURE sp_Sel_FlagWhatsApp
	GO

CREATE PROCEDURE sp_Sel_FlagWhatsApp(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	