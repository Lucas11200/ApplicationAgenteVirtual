IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Ins_HorarioAcionamento')
	DROP PROCEDURE sp_Ins_HorarioAcionamento
	GO

CREATE PROCEDURE sp_Ins_HorarioAcionamento(
	@IDHorarioAcionamento	INT = NULL,
	@IDCampanha				INT,
	@HoraInicio				VARCHAR(5),
	@HoraFim				VARCHAR(5),
	@VigenciaInicio			DATETIME,
	@VigenciaFim			DATETIME,
	@DiaSemana				INT,
	@CustoExtraDia			DECIMAL
)
AS   
    SET NOCOUNT ON;

	IF (@IDHorarioAcionamento > 0)
	BEGIN
		UPDATE HorarioAcionamento SET	IDCampanha		= @IDCampanha,
										HoraInicio		= @HoraInicio,
										HoraFim			= @HoraFim,
										VigenciaInicio	= @VigenciaInicio,
										VigenciaFim		= @VigenciaFim,
										DiaSemana		= @DiaSemana,
										CustoExtraDia	= @CustoExtraDia
		WHERE IDHorarioAcionamento = @IDHorarioAcionamento	
	END
	ELSE
	BEGIN
		INSERT INTO HorarioAcionamento VALUES (@IDCampanha, @HoraInicio, @HoraFim, @VigenciaInicio, @VigenciaFim, @DiaSemana, @CustoExtraDia)
	END
		

	