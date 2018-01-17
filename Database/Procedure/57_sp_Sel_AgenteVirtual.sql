IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_AgenteVirtual')
	DROP PROCEDURE sp_Sel_AgenteVirtual
	GO

CREATE PROCEDURE sp_Sel_AgenteVirtual(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	