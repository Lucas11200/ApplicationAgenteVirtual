IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_TipoFiltro')
	DROP PROCEDURE sp_Sel_TipoFiltro
	GO

CREATE PROCEDURE sp_Sel_TipoFiltro
AS   

	SELECT	[IDTipoFiltro],[Descricao]
	FROM	[dbo].[TipoFiltro]	