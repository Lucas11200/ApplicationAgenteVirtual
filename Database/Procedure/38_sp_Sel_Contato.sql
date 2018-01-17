IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Contato')
	DROP PROCEDURE sp_Sel_Contato
	GO

CREATE PROCEDURE sp_Sel_Contato(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	