IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_Operacao')
	DROP PROCEDURE sp_Sel_OperacaoFiltro
	GO

CREATE PROCEDURE sp_Sel_OperacaoFiltro(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   

   DECLARE @Comando varchar(max)
   
   
	SET @Comando =	'SELECT id_Customer FROM [Sky].[db_SKYCarga].Sky.Fatura AS a
						WHERE  a.ativo=1 
							AND	   a.id_Operacao'+ @Operador + ''''+ @Valor +''''				
	

	EXECUTE(@Comando)

