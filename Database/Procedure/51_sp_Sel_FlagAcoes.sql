IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_FlagAcoes')
	DROP PROCEDURE sp_Sel_FlagAcoes
	GO

CREATE PROCEDURE sp_Sel_FlagAcoes(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	