IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_TempoBase')
	DROP PROCEDURE sp_Sel_TempoBase
	GO

CREATE PROCEDURE sp_Sel_TempoBase(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	