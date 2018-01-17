IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_PossuiEmail')
	DROP PROCEDURE sp_Sel_PossuiEmail
	GO

CREATE PROCEDURE sp_Sel_PossuiEmail( 
	@Operador VARCHAR (5),   
	@Valor	VARCHAR(200)
)
AS   
   
	--Declara variável
	 DECLARE @Comando VARCHAR(200)
	
	--Apaga as tabelas Temporárias
	IF OBJECT_ID('tempdb..#TempEmailA') IS NOT NULL
				DROP TABLE #TempEmailA
	
	IF OBJECT_ID('tempdb..#TempEmailB') IS NOT NULL
				DROP TABLE #TempEmailB
	
	IF OBJECT_ID('tempdb..#TempSemEmail') IS NOT NULL
			DROP TABLE #TempSemEmail
	 
	--Verifica se o parametro recebido é igual à SIM  
	IF(LTRIM(RTRIM(UPPER(@Valor))) = 'SIM' )
		BEGIN
			
			--Alimenta a tabela #TempEmailA com todos clientes que estão Ativos e Possuem E-Mail	
			SELECT DISTINCT a.ID_Customer INTO #TempEmailA
				FROM [SKY].[db_SKYCarga].Sky.Email AS a 
					INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
						WHERE a.BlackList = 0 AND b.Ativo = 1
			
			--Atribui o Comando a variavel @Comando
			 SET @Comando = 'SELECT ID_Customer FROM #TempEmailA'
			
			--Executa a Variavel @Comando
			 EXECUTE (@Comando)
				
	END
	
	--Verifica se o parametro recebido é igual à NÃO  	
	ELSE IF(LTRIM(RTRIM(UPPER(@Valor))) = 'NÃO' )
		BEGIN	
				--Alimenta a tabela #TempEmailA com todos clientes que estão Ativos e Possuem E-Mail							
				SELECT DISTINCT a.ID_Customer INTO #TempEmailB
					FROM [SKY].[db_SKYCarga].Sky.Email AS a 
						INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
							WHERE a.BlackList = 0 AND b.Ativo = 1		
								
				--Alimenta a tabela #TempSemEmail com todos clientes que estão Ativos 	
				SELECT  DISTINCT ID_Customer INTO #TempSemEmail FROM [SKY].[db_SKYCarga].Sky.Fatura WHERE Ativo = 1
				
				--Remove o usuários que possuem email da #TempSemEmail
				DELETE #TempSemEmail WHERE ID_Customer  IN (SELECT ID_Customer FROM #TempEmailB)
				
				--Atribui o Comando a variavel @Comando
				SET @Comando = 'SELECT ID_Customer FROM #TempSemEmail'

				--Executa a Variavel @Comando
				EXECUTE (@Comando)
	END	
	
	--Apaga as tabelas Temporárias
	IF OBJECT_ID('tempdb..#TempEmailA') IS NOT NULL
			DROP TABLE #TempEmailA

	IF OBJECT_ID('tempdb..#TempEmailB') IS NOT NULL
				DROP TABLE #TempEmailB
	
	IF OBJECT_ID('tempdb..#TempSemEmail') IS NOT NULL
			DROP TABLE #TempSemEmail


			





	

		

