SELECT CodigoProduto,
       NomeProduto,
       CodigoNomeProduto,
       CodigoBarras,
       NomeGrupo,
       CodigoGrupo,
       NomeCategoria,
       CodigoCategoria,
       DataCadastro,
       Ativo,
       CodigoLaboratorio,
       NomeLaboratorio,
       PrincipioAtivo,
       CAST("CodigoGrupo" AS VARCHAR(10)) + ' - ' + "NomeGrupo"             AS CodigoNomeGrupo,
       CAST("CodigoCategoria" AS VARCHAR(10)) + ' - ' + "NomeCategoria"     AS CodigoNomeCategoria,
       CAST("CodigoLaboratorio" AS VARCHAR(10)) + ' - ' + "NomeLaboratorio" AS CodigoNomeLaboratorio
FROM ( SELECT prod.codigoproduto                                                 AS "CodigoProduto",
              prod.nomeproduto                                                   AS "NomeProduto",
              CAST(prod.CodigoProduto AS VARCHAR(10)) + ' - ' + prod.NomeProduto AS "CodigoNomeProduto",
              prod.codigobarra                                                   AS "CodigoBarras",
              pgrupo.nomegrupo                                                   AS "NomeGrupo",
              pgrupo.codigogrupo                                                 AS "CodigoGrupo",
              se.codigosessao                                                    AS "CodigoCategoria",
              Se.Nomesessao                                                      AS "NomeCategoria",
              CAST(prod.datacadastro AS DATE)                                    AS "DataCadastro",
              CASE
                  WHEN prod.eliminado = 0
                      THEN 1
                      ELSE 0
                  END                                                            AS "Ativo",
              pf.CodigoFabricante                                                AS "CodigoLaboratorio",
              pf.nomefabricante                                                  AS "NomeLaboratorio",
              form.NomeFormula                                                   AS "PrincipioAtivo"
       FROM produto                          prod
                LEFT JOIN Produto_Formula    form
                          ON form.CodigoFormula = prod.CodigoFormula
                LEFT JOIN produto_grupo      pgrupo
                          ON prod.codigogrupo = pgrupo.codigogrupo
                LEFT JOIN produto_sessao     se
                          ON prod.codigosessao = se.codigosessao
                LEFT JOIN produto_fabricante pf
                          ON pf.codigofabricante = prod.codigofabricante ) ppsp
