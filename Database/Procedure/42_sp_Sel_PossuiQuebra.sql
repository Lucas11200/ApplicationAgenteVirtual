IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_PossuiQuebra')
	DROP PROCEDURE sp_Sel_PossuiQuebra
	GO

CREATE PROCEDURE sp_Sel_PossuiQuebra(
    @Operador	VARCHAR(5),
	@Valor	VARCHAR(200)
)
AS   
    
	

	