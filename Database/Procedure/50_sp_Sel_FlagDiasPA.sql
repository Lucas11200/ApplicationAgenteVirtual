IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagDiasPA')
	DROP PROCEDURE sp_Sel_FlagDiasPA
	GO

CREATE PROCEDURE sp_Sel_FlagDiasPA(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	