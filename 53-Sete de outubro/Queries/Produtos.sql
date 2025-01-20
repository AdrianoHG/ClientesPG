SELECT "CodigoProduto",
       "NomeProduto",
       "CodigoNomeProduto",
       "CodigoBarras",
       "NomeGrupo",
       "CodigoGrupo",
       "NomeCategoria",
       "CodigoCategoria",
       "DataCadastro",
       "Ativo",
       "CodigoLaboratorio",
       "NomeLaboratorio",
       "PrincipioAtivo",
       "CodigoGrupo" || CAST(' - ' AS VARCHAR(5)) || "NomeGrupo"             AS "CodigoNomeGrupo",
       "CodigoCategoria" || CAST(' - ' AS VARCHAR(5)) || "NomeCategoria"     AS "CodigoNomeCategoria",
       "CodigoLaboratorio" || CAST(' - ' AS VARCHAR(5)) || "NomeLaboratorio" AS "CodigoNomeLaboratorio"
FROM ( SELECT prod.codigo                                 AS "CodigoProduto",
              prod.descricao                              AS "NomeProduto",
              CAST(CAST(prod.codigo AS INTEGER) AS VARCHAR(20)) || CAST(' - ' AS VARCHAR(5)) ||
              prod.descricao                              AS "CodigoNomeProduto",
              prod.cod_barra                              AS "CodigoBarras",
              prod.GRUPO                                  AS "NomeGrupo",
              ( SELECT MAX(g.CODIGO)
                FROM GRUPO g
                WHERE g.descricao = prod.grupo )          AS "CodigoGrupo",
              prod.CLASSIFICACAO                          AS "NomeCategoria",
              ( SELECT MAX(cl.codigo)
                FROM CLASSIFICACAO cl
                WHERE cl.DESCRICAO = prod.CLASSIFICACAO ) AS "CodigoCategoria",
              CAST(prod.datacadastro AS DATE) AS "DataCadastro",
              CASE
                  WHEN prod.status = 'ATIVO'
                      THEN 1
                      ELSE 0
                  END                                     AS "Ativo",
              ( SELECT MAX(f.CODIGO)
                FROM fabricante f
                WHERE f.descricao = prod.fabricante )     AS "CodigoLaboratorio",
              prod.fabricante                             AS "NomeLaboratorio",
              prod.PRINCATIVO                             AS "PrincipioAtivo"
       FROM produtos prod ) ppcc
