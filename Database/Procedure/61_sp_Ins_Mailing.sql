DECLARE @IDCampanha INT = 1, @Contador INT = 1, @Grupo INT, @Ordem INT, @ExclusivoRobo BIT

IF OBJECT_ID('tempdb..#TempCliente') IS NOT NULL
	DROP TABLE #TempCliente	

CREATE TABLE #TempCliente(
IDMailing				INT          
,IDCampanha				INT
,CreationTime			DATETIME
,StatusMailing			INT
,CustomerId				INT
,CPF					VARCHAR(11)
,Nome					VARCHAR(200)
,Valor					DECIMAL(18,2)
,ValorDesconto			DECIMAL(18,2)
,DataAcordoPagamento	DATETIME
,DiasAtraso				INT
,LinhaDigitavel			VARCHAR(48)) 

------------ Popular a tabela #TempCliente com todos clientes Ativos da Sky --------------
-------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#TempLinha') IS NOT NULL
	DROP TABLE #TempLinha

IF OBJECT_ID('tempdb..#TempGrupoCustomerID') IS NOT NULL
	DROP TABLE #TempGrupoCustomersID

IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
	DROP TABLE #TempClienteDeletar

IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
	DROP TABLE #TempClienteInserir

-- Cria tabela temp para deletar os valores que são diferentes (não respeitam o AND)
CREATE TABLE #TempClienteDeletar(CustomerId		INT NULL)
												    
CREATE TABLE #TempClienteInserir(CustomerId		INT NULL)
												    
CREATE TABLE #TempLinha(CustomerId				INT NULL)
												    
CREATE TABLE #TempGrupoCustomerID(CustomerId	INT NULL)

DECLARE @QTDGRUPO INT = (SELECT COUNT(1) AS QTDGRUPO FROM
								(SELECT 
								Grupo
								FROM FiltroGrupoCampanha
								WHERE IDCampanha = @IDCampanha
								GROUP BY Grupo) 
						AS TBL)

-- Enquanto contador for menor ou igual ao quantidade do grupo se mantém no while
WHILE @Contador <= @QTDGRUPO
BEGIN

	IF OBJECT_ID('tempdb..#TempGrupo') IS NOT NULL
		DROP TABLE #TempGrupo

	SELECT Grupo, IDCampanha, IDTipoFiltro, Operador, Valor, Condicao, Ordem, ExclusivoRobo, 0 AS Analisado
	INTO #TempGrupo 
	FROM   FiltroGrupoCampanha
	WHERE  IDCampanha	= @IDCampanha
	AND	   Grupo		= @Contador

	-- Enquanto houver linhas não analisadas se mantém no while
	WHILE EXISTS (SELECT 1 FROM #TempGrupo WHERE Analisado = 0)
		BEGIN
			DECLARE @IDTipoFiltro INT, @Operador VARCHAR(5), @Valor VARCHAR(200), @Condicao VARCHAR(200)
					
			SELECT TOP 1 
			@IDTipoFiltro	= IDTipoFiltro,
			@Operador		= RTRIM(LTRIM(Operador)),
			@Valor			= Valor,
			@Ordem			= Ordem,
			@Grupo			= Grupo,
			@ExclusivoRobo	= ExclusivoRobo
			FROM #TempGrupo 
			WHERE Analisado = 0 
			ORDER BY Grupo, Ordem
			

		   -- Se Tipo Filtro for Operação (1)
		   IF CONVERT(INT, @IDTipoFiltro) = 1 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Operação
						INSERT INTO #TempLinha Exec sp_Sel_OperacaoFiltro @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE 
					BEGIN
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
						
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar
															
							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Operação
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_OperacaoFiltro @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						END
						 
					-- Quando cair no Else é OR (0)
					ELSE 
						BEGIN	

							IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
							
							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Operação
							INSERT INTO #TempClienteInserir EXEC sp_Sel_OperacaoFiltro @Operador , @Valor

							-- Insere na #TempLinha os clientes que entram na condição Or do filtro Operação
							INSERT INTO #TempLinha							
							SELECT * FROM #TempClienteInserir 
							WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem
						END
				END							 
		   END 

		   -- Se Tipo Filtro for Valor Fatura (2)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 2 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Valor Fatura
						INSERT INTO #TempLinha Exec sp_Sel_ValorFatura @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN


							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Valor Fatura
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_ValorFatura @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Valor Fatura
						INSERT INTO #TempClienteInserir EXEC sp_Sel_ValorFatura @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Valor Fatura
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Desconto (3)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 3 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN						

						-- Insere na #TempLinha os usuário que atendem o filtro de Desconto
						INSERT INTO #TempLinha Exec sp_Sel_Desconto @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
							--Apaga os Dados da Tabela
								DELETE #TempClienteDeletar
													
							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Desconto
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_Desconto @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)															

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Desconto
						INSERT INTO #TempClienteInserir EXEC sp_Sel_Desconto @Operador , @Valor


						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Desconto
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
								
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		      -- Se Tipo Filtro for Data Vencimento (4)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 4 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Data Vencimento
						INSERT INTO #TempLinha Exec sp_Sel_DataVencimento @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Data Vencimento
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_DataVencimento @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Data Vencimento
						INSERT INTO #TempClienteInserir EXEC sp_Sel_DataVencimento @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Data Vencimento
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
																		
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		       -- Se Tipo Filtro for Data Início (5)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 5 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Data Início
						INSERT INTO #TempLinha Exec sp_Sel_DataInicio @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Data Início
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_DataInicio @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Data Início
						INSERT INTO #TempClienteInserir EXEC sp_Sel_DataInicio @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Data Início
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 
		   
		       -- Se Tipo Filtro for Data Fim (6)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 6 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Data Fim
						INSERT INTO #TempLinha Exec sp_Sel_DataFim @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
									DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Data Fim
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_DataFim @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
					
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
									DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro de Data Fim
						INSERT INTO #TempClienteInserir EXEC sp_Sel_DataFim @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Data Fim
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

				-- Se Tipo Filtro for Tempo Base (7)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 7 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Tempo Base
						INSERT INTO #TempLinha Exec sp_Sel_TempoBase @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
									DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Tempo Base
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_TempoBase @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
								

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
									DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Tempo Base
						INSERT INTO #TempClienteInserir EXEC sp_Sel_TempoBase @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Tempo Base
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)									
					
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   		-- Se Tipo Filtro for Passo (8)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 8 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Passo
						INSERT INTO #TempLinha Exec sp_Sel_Passo @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Passo
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_Passo @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Passo
						INSERT INTO #TempClienteInserir EXEC sp_Sel_Passo @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Passo
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

				 -- Se Tipo Filtro for Baixa (9)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 9 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Baixa
						INSERT INTO #TempLinha Exec sp_Sel_Baixa @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Baixa
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_Baixa @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Baixa
						INSERT INTO #TempClienteInserir EXEC sp_Sel_Baixa @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Baixa
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Data Baixa (10)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 10 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Data Baixa
						INSERT INTO #TempLinha Exec sp_Sel_DataBaixa @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Data Baixa
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_DataBaixa @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Data Baixa
						INSERT INTO #TempClienteInserir EXEC sp_Sel_DataBaixa @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Data Baixa
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
											
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Faixa Atraso (11)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 11 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Faixa Atraso
						INSERT INTO #TempLinha Exec sp_Sel_FaixaAtraso @Operador ,  @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Faixa Atraso
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FaixaAtraso @Operador ,  @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
						
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Faixa Atraso
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FaixaAtraso @Operador ,  @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Faixa Atraso
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
											
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		      -- Se Tipo Filtro for Estado (12)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 12 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Estado
						INSERT INTO #TempLinha Exec sp_Sel_Estado @Operador, @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Estado
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_Estado @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Estado
						INSERT INTO #TempClienteInserir EXEC sp_Sel_Estado @Operador , @Valor


						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Estado
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		       -- Se Tipo Filtro for Contato (13)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 13 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de CPC
						INSERT INTO #TempLinha Exec sp_Sel_Contato @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_Contato @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)													

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC
						INSERT INTO #TempClienteInserir EXEC sp_Sel_Contato @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro CPC
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		     -- Se Tipo Filtro for CPC (14)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 14 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de CPC
						INSERT INTO #TempLinha Exec sp_Sel_CPC @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
						
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_CPC @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
														
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC
						INSERT INTO #TempClienteInserir EXEC sp_Sel_CPC @Operador , @Valor


						-- Insere na #TempLinha os clientes que entram na condição Or do filtro CPC
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
													
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 
		   
		       -- Se Tipo Filtro for CPC Aproveitável (15)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 15 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de CPC Aproveitável
						INSERT INTO #TempLinha Exec sp_Sel_CPCAproveitavel @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC Aproveitável
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_CPCAproveitavel @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite	
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro CPC Aproveitável
						INSERT INTO #TempClienteInserir EXEC sp_Sel_CPCAproveitavel @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro CPC Aproveitável
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
											
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		      -- Se Tipo Filtro for Cliente Enriquecido (16)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 16 
		   BEGIN 
		    
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Cliente Enriquecido
						INSERT INTO #TempLinha Exec sp_Sel_ClienteEnriquecido @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Cliente Enriquecido
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_ClienteEnriquecido @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Cliente Enriquecido
						INSERT INTO #TempClienteInserir EXEC sp_Sel_ClienteEnriquecido @Operador , @Valor


						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Cliente Enriquecido
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
													
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		         -- Se Tipo Filtro for Possui Quebra (17)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 17 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui Quebra
						INSERT INTO #TempLinha Exec sp_Sel_PossuiQuebra @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Quebra
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiQuebra @Operador , @Valor


							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Quebra
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiQuebra @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui Quebra
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		     -- Se Tipo Filtro for Possui Endereço (18)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 18 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui Endereço
						INSERT INTO #TempLinha Exec sp_Sel_PossuiEndereco @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Endereço
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiEndereco @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
						
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Endereço
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiEndereco @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui Endereço
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
											
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Possui E-Mail (19)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 19 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui E-Mail
						INSERT INTO #TempLinha Exec sp_Sel_PossuiEmail @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui E-Mail
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiEmail @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
						
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui E-Mail
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiEmail @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui E-Mail
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Possui Possui Telefone (20)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 20 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui Telefone
						INSERT INTO #TempLinha Exec sp_Sel_PossuiTelefone @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Telefone
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiTelefone @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Telefone
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiTelefone @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui Telefone
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for  Possui Fixo (21)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 21 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui Fixo
						INSERT INTO #TempLinha Exec sp_Sel_PossuiFixo @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar					
								
							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Fixo
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiFixo @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir		
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Fixo
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiFixo @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui Fixo
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
											
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

			-- Se Tipo Filtro for Possui Possui Celular (22)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 22 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Possui Celular
						INSERT INTO #TempLinha Exec sp_Sel_PossuiCelular @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar	

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Celular
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_PossuiCelular @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
						
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Possui Celular
						INSERT INTO #TempClienteInserir EXEC sp_Sel_PossuiCelular @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Possui Celular
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   -- Se Tipo Filtro for  Vigência Acordo (23)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 23 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Vigência Acordo
						INSERT INTO #TempLinha Exec sp_Sel_VigenciaAcordo @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Vigência Acordo
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_VigenciaAcordo @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
						

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
												
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Vigência Acordo
						INSERT INTO #TempClienteInserir EXEC sp_Sel_VigenciaAcordo @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Vigência Acordo
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
							
													
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for  Flag Recusas (24)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 24 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Recusas
						INSERT INTO #TempLinha Exec sp_Sel_FlagRecusas @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Recusas
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagRecusas @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
												

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Recusas
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagRecusas @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Recusas
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
											
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   -- Se Tipo Filtro for  Flag Dias PA (25)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 25 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Dias PA
						INSERT INTO #TempLinha Exec sp_Sel_FlagDiasPA @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Dias PA
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagDiasPA @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Dias PA
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagDiasPA @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Dias PA
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
													
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for Possui Flag Ações (26)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 26 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Ações
						INSERT INTO #TempLinha Exec sp_Sel_FlagAcoes @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Ações
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagAcoes @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
									

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Ações
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagAcoes @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Ações
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for  Flag SMS (27)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 27 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag SMS
						INSERT INTO #TempLinha Exec sp_Sel_FlagSMS @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar
						

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagSMS @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir					
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagSMS @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag SMS
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for  Flag SMS Proventivo (28)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 28 
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag SMS Proventivo
						INSERT INTO #TempLinha Exec sp_Sel_FlagSMSProventivo @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS Proventivo
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagSMSProventivo @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
							

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS Proventivo
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagSMSProventivo @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag SMS Proventivo
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   -- Se Tipo Filtro for  Flag SMS Boleto (29)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 29
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag SMS Boleto
						INSERT INTO #TempLinha Exec sp_Sel_FlagSMSBoleto @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS Boleto
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagSMSBoleto @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag SMS Boleto
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagSMSBoleto @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag SMS Boleto
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

			-- Se Tipo Filtro for  Flag WhatsApp (30)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 30
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag WhatsApp
						INSERT INTO #TempLinha Exec sp_Sel_FlagWhatsApp @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar
						
							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag WhatsApp
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagWhatsApp @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag WhatsApp
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagWhatsApp @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag WhatsApp
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
												
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   	-- Se Tipo Filtro for  Flag E-Mail (31)	
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 31
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag E-Mail
						INSERT INTO #TempLinha Exec sp_Sel_FlagEmail @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag E-Mail
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagEmail @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										
														SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag E-Mail
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagEmail @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag E-Mail
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
										
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    	-- Se Tipo Filtro for  Flag URA (32)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 32
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag URA
						INSERT INTO #TempLinha Exec sp_Sel_FlagURA @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN
							
							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag URA
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagURA @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
										

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
						
						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag URA
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagURA @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag URA
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   	-- Se Tipo Filtro for  Agente Virtual (33)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 33
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Agente Virtual
						INSERT INTO #TempLinha Exec sp_Sel_AgenteVirtual @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Agente Virtual
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_AgenteVirtual @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
														

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
														
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Agente Virtual
						INSERT INTO #TempClienteInserir EXEC sp_Sel_AgenteVirtual @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Agente Virtual
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   -- Se Tipo Filtro for  Flag Alega Pagamento (34)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 34
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Alega Pagamento
						INSERT INTO #TempLinha Exec sp_Sel_FlagAlegaPagamento @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Alega Pagamento
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagAlegaPagamento @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)
							
						--Verica de a Tabela Temporária exite						
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Alega Pagamento
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagAlegaPagamento @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Alega Pagamento
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
									
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		   -- Se Tipo Filtro for  Flag Consta Pagamento (35)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 35
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Consta Pagamento
						INSERT INTO #TempLinha Exec sp_Sel_FlagConstaPagamento @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Consta Pagamento
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagConstaPagamento @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
														

							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
							DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Consta Pagamento
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagConstaPagamento @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Consta Pagamento
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
						
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 

		    -- Se Tipo Filtro for  Flag Suspeita de Fraude (36)
		   ELSE IF CONVERT(INT, @IDTipoFiltro) = 36
		   BEGIN 
				-- Se for primeira linha (ordem 1) insere na #TempLinha e adiciona condição(And/Or) para próxima linha 
				IF @ordem = 1 
					BEGIN
						
						-- Insere na #TempLinha os usuário que atendem o filtro de Flag Suspeita de Fraude
						INSERT INTO #TempLinha Exec sp_Sel_FlagSuspeitaFraude @Operador , @Valor

						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem

					END
					
				ELSE BEGIN
					
					--Se Condição for igual AND (1)
					IF CONVERT(INT, @Condicao) =1 
						BEGIN

							--Verica de a Tabela Temporária exite
							IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
								DELETE #TempClienteDeletar

							--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Suspeita de Fraude
							INSERT INTO #TempClienteDeletar EXEC sp_Sel_FlagSuspeitaFraude @Operador , @Valor

							--Deletando registros da #TempLinha que não atenderam a condição AND (quando existe tanto na #TempLinha quanto na #TempClienteDeletar)
							DELETE #TempLinha WHERE CustomerId NOT IN (SELECT CustomerId FROM #TempClienteDeletar)
							
							SELECT TOP 1 
							@Condicao		= Condicao
							FROM #TempGrupo 
							WHERE Analisado = 0 
							ORDER BY Grupo, Ordem

						 END
						 
					ELSE BEGIN	--Quando cair no Else é OR (0)

						--Verica de a Tabela Temporária exite
						IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
								DELETE #TempClienteInserir
						
						--Executa procedure que busca os CustomerId dos usuários que atendem o filtro Flag Suspeita de Fraude
						INSERT INTO #TempClienteInserir EXEC sp_Sel_FlagSuspeitaFraude @Operador , @Valor

						-- Insere na #TempLinha os clientes que entram na condição Or do filtro Flag Suspeita de Fraude
						INSERT INTO #TempLinha							
						SELECT * FROM #TempClienteInserir 
						WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)
					
							
						SELECT TOP 1 
						@Condicao		= Condicao
						FROM #TempGrupo 
						WHERE Analisado = 0 
						ORDER BY Grupo, Ordem
					END
				END							 
		   END 
		   		
		   -- Atualiza a linha para Analisada
			UPDATE #TempGrupo SET Analisado = 1 WHERE Grupo = @Grupo AND IDCampanha = @IDCampanha AND Ordem = @Ordem
	END

		-- Insere na #TempGrupoCustomerID os CustomerId que atenderam as condições And ou Or nas linhas do Grupo
		INSERT INTO #TempGrupoCustomerID							
		SELECT * FROM #TempLinha 
		WHERE CustomerId not in(SELECT CustomerId FROM #TempLinha)									
	
	SET @Contador += 1

END


--Inserir na tabela Mailing os usuários que atenderam as condições do Grupos/Linhas
INSERT INTO Mailing (IDCampanha, CreationTime, StatusMailing, CustomerId, CPF, Nome, Valor, ValorDesconto, DataAcordoPagamento, DiasAtraso, LinhaDigitavel)
SELECT @IDCampanha, CreationTime, StatusMailing, CustomerId, CPF, Nome, Valor, ValorDesconto, DataAcordoPagamento, DiasAtraso, LinhaDigitavel
FROM #TempCliente
WHERE CustomerId IN(SELECT CustomerId FROM #TempGrupoCustomerID)

--IF (@ExclusivoRobo = 1)
--BEGIN
--  Chama a procedure de negativar Priorite para PA não entrar em contato, somente o Robo
--  Para todos os clientes da tabela #TempGrupoCustomerID serão negativados

--END


 --Apagando Tabelas Temporárias,se criadas. 
IF OBJECT_ID('tempdb..#TempLinha') IS NOT NULL
	DROP TABLE #TempLinha

IF OBJECT_ID('tempdb..#TempGrupoCustomerID') IS NOT NULL
	DROP TABLE #TempGrupoCustomerID

IF OBJECT_ID('tempdb..#TempClienteDeletar') IS NOT NULL
	DROP TABLE #TempClienteDeletar

IF OBJECT_ID('tempdb..#TempClienteInserir') IS NOT NULL
	DROP TABLE #TempClienteInserir
	
IF OBJECT_ID('tempdb..#TempCliente') IS NOT NULL		
	DROP TABLE #TempCliente	
