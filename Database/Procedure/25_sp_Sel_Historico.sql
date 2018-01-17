IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Historico')
	DROP PROCEDURE sp_Sel_Historico
	GO

CREATE PROCEDURE sp_Sel_Historico(
	@IDCampanha INT,
	@DataInicio DATE ,
	@DataFim	DATE ,
	@Usuario	VARCHAR(200)
)
AS   

	SELECT 
	Usuario,
	CONVERT(CHAR,CAST(DataCriacao AS DATE),103) AS DataCriacao,
	Grupo,
	TipoFiltro,
	Operador,
	Valor,
	ExclusivoRobo	
	FROM [dbo].[FiltroGrupoCampanhaHistorico]
	WHERE LOWER(Usuario) = LOWER(@Usuario)
	AND (CAST(DataCriacao AS DATE) >= @dataInicio AND CAST(DataCriacao AS DATE) <= @dataFim)
	AND IDCampanha = @IDCampanha
	ORDER BY DataCriacao