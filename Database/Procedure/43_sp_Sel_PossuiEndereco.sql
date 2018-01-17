IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_PossuiEndereco')
	DROP PROCEDURE sp_Sel_PossuiEndereco
	GO

CREATE PROCEDURE sp_Sel_PossuiEndereco(
	@Operador VARCHAR(5),
   	@Valor	VARCHAR(200)
)
AS   
    
	--Declara vari�vel
	 DECLARE @Comando VARCHAR(200)
	
	--Apaga as tabelas Tempor�rias
	IF OBJECT_ID('tempdb..#TempEnderecoA') IS NOT NULL
				DROP TABLE #TempEnderecoA
	
	IF OBJECT_ID('tempdb..#TempEnderecoB') IS NOT NULL
				DROP TABLE #TempEnderecoB
	
	IF OBJECT_ID('tempdb..#TempSemEndereco') IS NOT NULL
			DROP TABLE #TempSemEndereco
	 
	--Verifica se o parametro recebido � igual � SIM  
	IF(LTRIM(RTRIM(UPPER(@Valor))) = 'SIM' )
		BEGIN
			
			--Alimenta a tabela #TempEnderecoA com todos clientes que est�o Ativos e Possuem Endere�o
			SELECT DISTINCT a.ID_Customer INTO #TempEnderecoA
				FROM [SKY].[db_SKYCarga].Sky.Endereco AS a 
					INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
						WHERE a.BlackList = 0 AND b.Ativo = 1
			
			--Atribui o Comando a variavel @Comando
			 SET @Comando = 'SELECT ID_Customer FROM #TempEnderecoA'
			
			--Executa a Variavel @Comando
			 EXECUTE (@Comando)
				
	END
	
	--Verifica se o parametro recebido � igual � N�O  	
	ELSE IF(LTRIM(RTRIM(UPPER(@Valor))) = 'N�O' )
		BEGIN	
				--Alimenta a tabela #TempEnderecoA com todos clientes que est�o Ativos e Possuem Endere�o				
				SELECT DISTINCT a.ID_Customer INTO #TempEnderecoB
					FROM [SKY].[db_SKYCarga].Sky.Endereco AS a 
						INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
							WHERE a.BlackList = 0 AND b.Ativo = 1		
								
				--Alimenta a tabela #TempSemEndereco com todos clientes que est�o Ativos 	
				SELECT  DISTINCT ID_Customer INTO #TempSemEndereco FROM [SKY].[db_SKYCarga].Sky.Fatura WHERE Ativo = 1
				
				--Remove o usu�rios que possuem Endere�o da #TempSemEndereco
				DELETE #TempSemEndereco WHERE ID_Customer  IN (SELECT ID_Customer FROM #TempEnderecoB)
				
				--Atribui o Comando a variavel @Comando
				SET @Comando = 'SELECT ID_Customer FROM #TempSemEndereco'

				--Executa a Variavel @Comando
				EXECUTE (@Comando)
	END	
	
	--Apaga as tabelas Tempor�rias
	IF OBJECT_ID('tempdb..#TempEnderecoA') IS NOT NULL
			DROP TABLE #TempEnderecoA

	IF OBJECT_ID('tempdb..#TempEnderecoB') IS NOT NULL
				DROP TABLE #TempEnderecoB
	
	IF OBJECT_ID('tempdb..#TempSemEndereco') IS NOT NULL
			DROP TABLE #TempSemEndereco
	


