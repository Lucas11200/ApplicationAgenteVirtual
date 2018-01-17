IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Baixa')
	DROP PROCEDURE sp_Sel_Baixa
	GO

CREATE PROCEDURE sp_Sel_Baixa(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	