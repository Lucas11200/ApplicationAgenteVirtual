IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_PossuiCelular')
	DROP PROCEDURE sp_Sel_PossuiCelular
	GO

CREATE PROCEDURE sp_Sel_PossuiCelular(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
		--Declara vari�vel
	 DECLARE @Comando VARCHAR(200)
	
	--Apaga as tabelas Tempor�rias
	IF OBJECT_ID('tempdb..#TempTelA') IS NOT NULL
				DROP TABLE #TempTelA
	
	IF OBJECT_ID('tempdb..#TempTelB') IS NOT NULL
				DROP TABLE #TempTelB
	
	IF OBJECT_ID('tempdb..#TempSemTel') IS NOT NULL
			DROP TABLE #TempSemTel
	 
	--Verifica se o parametro recebido � igual � SIM  
	IF(LTRIM(RTRIM(UPPER(@Valor))) = 'SIM' )
		BEGIN
			
			--Alimenta a tabela #TempTelA com todos clientes que est�o Ativos e Possuem Telefone Celular	
			SELECT DISTINCT a.ID_Customer INTO #TempTelA
				FROM [SKY].[db_SKYCarga].Sky.Telefone AS a 
					INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
						WHERE a.BlackList = 0 AND b.Ativo = 1 AND a.ID_TelefoneTipo = 2 --celular
			

			--Atribui o Comando a variavel @Comando
			 SET @Comando = 'SELECT ID_Customer FROM #TempTelA'
			
			--Executa a Variavel @Comando
			 EXECUTE (@Comando)
				
	END
	
	--Verifica se o parametro recebido � igual � N�O  	
	ELSE IF(LTRIM(RTRIM(UPPER(@Valor))) = 'N�O' )
		BEGIN	
				--Alimenta a tabela #TempTelA com todos clientes que est�o Ativos e Possuem Telefone Celular					
				SELECT DISTINCT a.ID_Customer INTO #TempTelB
					FROM [SKY].[db_SKYCarga].Sky.Telefone AS a 
						INNER JOIN [SKY].[db_SKYCarga].Sky.Fatura AS b ON a.ID_Customer = b.ID_Customer 
							WHERE a.BlackList = 0 AND b.Ativo = 1 AND a.ID_TelefoneTipo = 2 --celular
								
				--Alimenta a tabela #TempSemTel com todos clientes que est�o Ativos 	
				SELECT  DISTINCT ID_Customer INTO #TempSemTel FROM [SKY].[db_SKYCarga].Sky.Fatura WHERE Ativo = 1
				
				--Remove o usu�rios que possuem Telefone Fixo da #TempSemTel
				DELETE #TempSemTel WHERE ID_Customer  IN (SELECT ID_Customer FROM #TempTelB)
				
				--Atribui o Comando a variavel @Comando
				SET @Comando = 'SELECT ID_Customer FROM #TempSemTel'

				--Executa a Variavel @Comando
				EXECUTE (@Comando)
	END	
	
	--Apaga as tabelas Tempor�rias
	IF OBJECT_ID('tempdb..#TempTelA') IS NOT NULL
			DROP TABLE #TempTelA

	IF OBJECT_ID('tempdb..#TempTelB') IS NOT NULL
				DROP TABLE #TempTelB
	
	IF OBJECT_ID('tempdb..#TempSemTel') IS NOT NULL
			DROP TABLE #TempSemTel
	
	

	exec sp_Sel_PossuiCelular '=','sim'

