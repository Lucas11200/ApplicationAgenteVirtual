IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagURA')
	DROP PROCEDURE sp_Sel_FlagURA
	GO

CREATE PROCEDURE sp_Sel_FlagURA(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	