USE [AgenteVirtual_Sky]
GO
/****** Object:  StoredProcedure [dbo].[sp_Sel_Estado]    Script Date: 29/12/2017 11:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Sel_Estado](
    @Operador	VARCHAR(5),
	@Valor		VARCHAR(200)
)
AS   

	--Declara as Variaveis
	DECLARE @NomeEstado			VARCHAR (100)
	DECLARE @Sigla				VARCHAR (2)
	DECLARE @EstadoSemAcento	VARCHAR (100)
	DECLARE @ValorReal			VARCHAR (100)
	DECLARE @Comando			VARCHAR(MAX)

	--Verifica se a tabela existe
	--Se sim, dropa a tabela
    IF OBJECT_ID('tempdb..#TempEstado') IS NOT NULL
		DROP TABLE #TempEstado			

	--Cria a tabela com os Estado
	CREATE TABLE #TempEstado(
	NomeEstado			VARCHAR (100),
	Sigla				VARCHAR(100),
	EstadoSemAcento		VARCHAR (100)
	)
	
	--Insere na tabela de estados, todos os possiveis.
	INSERT INTO #TempEstado VALUES('ACRE','AC','ACRE')
	INSERT INTO #TempEstado VALUES('ALAGOAS','AL','	ALAGOAS')
	INSERT INTO #TempEstado VALUES('AMAPÁ','AP','AMAPA')
	INSERT INTO #TempEstado VALUES('AMAZONAS','AM','AMAZONAS')
	INSERT INTO #TempEstado VALUES('BAHIA','BA','BAHIA')
	INSERT INTO #TempEstado VALUES('CEARÁ','CE','CEARA')	
	INSERT INTO #TempEstado VALUES('DISTRITO FEDERAL','DF','DISTRITO FEDERAL')
	INSERT INTO #TempEstado VALUES('ESPÍRITO SANTO','ES','ESPIRITO SANTO')
	INSERT INTO #TempEstado VALUES('GOIÁS','GO','GOIAS')
	INSERT INTO #TempEstado VALUES('MARANHÃO','MA','MARANHAO')
	INSERT INTO #TempEstado VALUES('MATO GROSSO','MT','MATO GROSSO')
	INSERT INTO #TempEstado VALUES('MATO GROSSO DO SUL','MS','MATO GROSSO DO SUL')
	INSERT INTO #TempEstado VALUES('MINAS GERAIS','MG','MINAS GERAIS')
	INSERT INTO #TempEstado VALUES('PARÁ','PA','PARA')
	INSERT INTO #TempEstado VALUES('PARAÍBA','PB','PARAIBA')
	INSERT INTO #TempEstado VALUES('PARANÁ','PR','PARANA')
	INSERT INTO #TempEstado VALUES('PERNAMBUCO','PE','PERNAMBUCO')
	INSERT INTO #TempEstado VALUES('PIAUÍ','PI','PIAUI')
	INSERT INTO #TempEstado VALUES('RIO DE JANEIRO','RJ','RIO DE JANEIRO')
	INSERT INTO #TempEstado VALUES('RIO GRANDE DO NORTE','RN','RIO GRANDE DO NORTE')
	INSERT INTO #TempEstado VALUES('RIO GRANDE DO SUL','RS','RIO GRANDE DO SUL')
	INSERT INTO #TempEstado VALUES('RONDÔNIA','RO','RONDONIA')
	INSERT INTO #TempEstado VALUES('RORAIMA','RR','RORAIMA')
	INSERT INTO #TempEstado VALUES('SANTA CATARINA','SC','SANTA CATARINA')
	INSERT INTO #TempEstado VALUES('SÃO PAULO','SP','SAO PAULO')
	INSERT INTO #TempEstado VALUES('SERGIPE','SE','SERGIPE')
	INSERT INTO #TempEstado VALUES('TOCANTINS','TO','TOCANTINS')

	--Declara o cursor
	DECLARE CursorEstado CURSOR 
		FOR 
			--Select que o cursor percorrerá
			SELECT NomeEstado,Sigla,EstadoSemAcento FROM #TempEstado

	--Abre o cursor
	OPEN CursorEstado

		--Inicia a leitura da primeira linha definindo as variaveis @NomeEstado,@Sigla,@EstadoSemAcento respectivamente.
		FETCH NEXT FROM CursorEstado INTO @NomeEstado,@Sigla,@EstadoSemAcento
		
		WHILE @@FETCH_STATUS = 0 
			BEGIN
				IF (UPPER(RTRIM(LTRIM(@Valor))) = UPPER(RTRIM(LTRIM(@NomeEstado))) 
				OR UPPER(RTRIM(LTRIM(@Valor)))	= UPPER(RTRIM(LTRIM(@Sigla))) 
				OR LOWER(RTRIM(LTRIM(@Valor)))	= UPPER(RTRIM(LTRIM(@EstadoSemAcento)))) 
					BEGIN
						--Seta o @ValorReal com a @Sigla conforme o padrão do banco da SKY
						SET @ValorReal = @Sigla 
						--Para o cursor se o valor for setado
						BREAK 
					END				
				
				--Define a proxima linha para que o cursor leia conforme as variaveis respectivas :@NomeEstado,@Sigla,@EstadoSemAcento
				FETCH NEXT FROM CursorEstado INTO @NomeEstado,@Sigla,@EstadoSemAcento
			END

	--Fecha o cursor
	CLOSE CursorEstado

	DEALLOCATE CursorEstado

	--Seta a variavel @Comando com o SELECT proveniente a consulta no banco da SKY. 
	--Se concatena o conteudo das variaveis @Operador e @ValorReal a string de comando.
	SET @Comando = 'SELECT a.ID_Customer FROM  [SKY].[db_SKYCarga].sky.Endereco a 
					INNER JOIN [SKY].[db_SKYCarga].sky.Fatura b ON a.ID_Customer = b.ID_Customer
					WHERE b.Baixa = 0			
								AND b.Ativo = 1
								AND a.Estado '+ @Operador + ' '''+ @ValorReal +''''

	--Ececuta a o select na variavel @Comando
	EXECUTE(@Comando)



