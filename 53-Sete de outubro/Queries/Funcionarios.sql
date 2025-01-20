SELECT "CodigoLoja",
       "CodigoFuncionario",
       "NomeFuncionario",
       CAST("CodigoFuncionario" AS INT) || CAST(' - ' AS VARCHAR(5)) || "NomeFuncionario" AS "CodigoNomeFuncionario",
       "Telefone",
       "Ativo"
FROM ( SELECT func.codigo    AS "CodigoFuncionario",
              func.nome      AS "NomeFuncionario",
              fe.cod_empresa AS "CodigoLoja",
              func.celular   AS "Telefone",
              func.status    AS "Ativo",
              func.SENHA
       FROM funciona                       func
                LEFT JOIN funciona_empresa fe
                          ON fe.cod_funciona = func.codigo ) ff
