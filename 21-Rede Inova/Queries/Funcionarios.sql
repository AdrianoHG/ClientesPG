SELECT "CodigoLoja",
       "CodigoFuncionario",
       "NomeFuncionario",
       CAST("CodigoFuncionario" AS VARCHAR(10)) + ' - ' + "NomeFuncionario" AS "CodigoNomeFuncionario",
       NULL                                                                 AS "Telefone",
       "Ativo"
FROM ( SELECT func.codigofuncionario AS "CodigoFuncionario",
              cad.nome               AS "NomeFuncionario",
              cad.codigoempresa      AS "CodigoLoja",
              func.ativo             AS "Ativo"
       FROM dbo.funcionario                     func
                INNER JOIN dbo.cadastro         cad
                           ON func.codigocadastro = cad.codigocadastro
                LEFT JOIN  dbo.funcionario_tipo tipo
                           ON func.codigotipo = tipo.codigotipo ) fct
