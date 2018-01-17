IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_CPCAproveitavel')
	DROP PROCEDURE sp_Sel_CPCAproveitavel
	GO

CREATE PROCEDURE sp_Sel_CPCAproveitavel(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	