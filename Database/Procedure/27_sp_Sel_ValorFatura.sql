IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_ValorFatura')
	DROP PROCEDURE sp_Sel_ValorFatura
	GO

CREATE PROCEDURE sp_Sel_ValorFatura(
    @Operador	VARCHAR(5),
	@Valor		VARCHAR(200)
)
AS   

	DECLARE @Comando VARCHAR(MAX)
	DECLARE @ValorReal NUMERIC (15,2)

    --Tirando as virgulas e subistituindo por ponto
	SET @Valor= REPLACE(@Valor,',','.')
		
	IF TRY_CONVERT(NUMERIC(15,2),@Valor) IS NOT NULL
			BEGIN

				
				SET @Comando = 'SELECT ID_Customer FROM [SKY].[db_SKYCarga].sky.Fatura 
				WHERE Ativo = 1
					  AND ValorFatura '+ @Operador + ''''+ @Valor +''''

				EXEC(@Comando)

		END

