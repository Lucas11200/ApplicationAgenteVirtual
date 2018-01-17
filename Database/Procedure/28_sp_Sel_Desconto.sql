IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Desconto')
	DROP PROCEDURE sp_Sel_Desconto
	GO

CREATE PROCEDURE sp_Sel_Desconto(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	DECLARE @Comando VARCHAR(MAX)


	SET @Comando= 'SELECT a.Id_Customer FROM [SKY].[db_SKYCarga].Sky.Ofertas a
					INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura b ON a.Id_Customer = b.Id_Customer
						WHERE a.ativo = 1 AND b.ativo = 1
							AND a.Oferta1 ' + @Operador + '''' + @Valor + ''''

	EXEC (@Comando)


	

