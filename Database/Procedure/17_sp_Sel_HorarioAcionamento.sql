IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Sel_HorarioAcionamento')
	DROP PROCEDURE sp_Sel_HorarioAcionamento
	GO

CREATE PROCEDURE sp_Sel_HorarioAcionamento(
	@IDCampanha		INT
)
AS   

	SELECT	[IDHorarioAcionamento],
			[IDCampanha],
			[HoraInicio],
			[HoraFim],
			[VigenciaInicio],
			[VigenciaFim],
			[DiaSemana],
			[CustoExtraDia]
	FROM	[dbo].[HorarioAcionamento]
	WHERE	IDCampanha = @IDCampanha
	ORDER BY DiaSemana 