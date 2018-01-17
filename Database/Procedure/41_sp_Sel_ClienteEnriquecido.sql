IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_ClienteEnriquecido')
	DROP PROCEDURE sp_Sel_ClienteEnriquecido
	GO

CREATE PROCEDURE sp_Sel_ClienteEnriquecido(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	