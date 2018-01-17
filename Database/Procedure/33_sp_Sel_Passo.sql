IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Passo')
	DROP PROCEDURE sp_Sel_Passo
	GO

CREATE PROCEDURE sp_Sel_Passo(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200) 
)
AS         

	DECLARE @Comando VARCHAR(MAX)
	DECLARE @ValorReal NUMERIC (15,2)				

		SET @Comando = 'SELECT ID_Customer FROM [SKY].[db_SKYCarga].sky.Fatura 
		WHERE Ativo = 1
			  AND Passo '+ @Operador + ''''+ @Valor +''''

		EXEC(@Comando)



		

