DECLARE @IDCampanha INT = 1, @Contador INT = 1, @Grupo INT, @Ordem INT

DECLARE @QTDGRUPO INT = (SELECT COUNT(1) AS QTDGRUPO FROM
								(SELECT 
								Grupo
								FROM FiltroGrupoCampanha
								WHERE IDCampanha = @IDCampanha
								GROUP BY Grupo) 
						AS TBL)

DECLARE @Query AS VARCHAR(MAX);

SET @Query = 'WHERE '

WHILE @Contador <= @QTDGRUPO
BEGIN
	IF OBJECT_ID('tempdb..#TempGrupo') IS NOT NULL
		/*Then it exists*/
		DROP TABLE #TempGrupo

	--(Grupo, IDCampanha, IDTipoFiltro, Operador, Valor, Condicao, Ordem, Analisado) 
	SELECT Grupo, IDCampanha, IDTipoFiltro, Operador, Valor, Condicao, Ordem, 0 AS Analisado
	INTO #TempGrupo 
	FROM   FiltroGrupoCampanha
	WHERE  IDCampanha	= @IDCampanha
	AND	   Grupo		= @Contador

	SET @Query = CONCAT(@Query, '( ')

	WHILE EXISTS (SELECT 1 FROM #TempGrupo WHERE Analisado = 0)
	BEGIN
		DECLARE @IDTipoFiltro VARCHAR(200), @Operador VARCHAR(5), @Valor VARCHAR(200), @Condicao VARCHAR(200)
				
		SELECT TOP 1 
		@IDTipoFiltro	= IDTipoFiltro,
		@Operador		= Operador,
		@Valor			= Valor,
		@Condicao		= Condicao,
		@Ordem			= Ordem,
		@Grupo			= Grupo
		FROM #TempGrupo 
		WHERE Analisado = 0 
		ORDER BY Grupo, Ordem

		SET @Query = @Query + @IDTipoFiltro + ' '
		SET @Query = @Query + @Operador + ' '
		SET @Query = @Query + @Valor + ' '
						
		SET @Query = @Query + CASE 
			WHEN @Condicao = '1' THEN ' AND '
			WHEN @Condicao = '0' THEN ' OR ' 
			ELSE '' 			
			END 

		UPDATE #TempGrupo SET Analisado = 1 WHERE Grupo = @Grupo AND IDCampanha = @IDCampanha AND Ordem = @Ordem
	END

	SET @Query = CONCAT(@Query, ')')

	IF (@Contador < @QTDGRUPO)
	BEGIN
		SET @Query = @Query + ' OR '
	END

	SET @Contador += 1
END;


SELECT @Query


