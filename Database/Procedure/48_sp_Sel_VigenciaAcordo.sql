IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_VigenciaAcordo')
	DROP PROCEDURE sp_Sel_VigenciaAcordo
	GO

CREATE PROCEDURE sp_Sel_VigenciaAcordo(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	