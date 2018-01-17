IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_DataBaixa')
	DROP PROCEDURE sp_Sel_DataBaixa
	GO

CREATE PROCEDURE sp_Sel_DataBaixa(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   

    DECLARE @Comando VARCHAR(MAX)

		IF TRY_CONVERT(DATETIME,@Valor) IS NOT NULL
			BEGIN

				SET @Comando = 'SELECT * FROM Mailing WHERE CreationTime '+ @Operador + ' '''+ @Valor +''''

				EXECUTE(@Comando)

		END