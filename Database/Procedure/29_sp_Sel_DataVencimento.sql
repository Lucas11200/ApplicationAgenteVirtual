IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_DataVencimento')
	DROP PROCEDURE sp_Sel_DataVencimento
	GO

CREATE PROCEDURE sp_Sel_DataVencimento(
    @Operador	VARCHAR(5),
	@Valor		VARCHAR(200)
)
AS   

	DECLARE @Comando VARCHAR(MAX)

		IF TRY_CONVERT(DATETIME,@Valor) IS NOT NULL
			BEGIN

				SET @Comando = 'SELECT ID_Customer FROM [SKY].[db_SKYCarga].sky.Fatura 
				WHERE Ativo = 1 
							AND DataVencimento '+ @Operador + ' '''+ @Valor +''''

				EXECUTE(@Comando)
				
		END
		
