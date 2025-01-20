SELECT DISTINCT ON ("CodigoProduto") "CodigoProduto",
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
                                     CONCAT("CodigoGrupo", ' - ', "NomeGrupo")             AS "CodigoNomeGrupo",
                                     CONCAT("CodigoCategoria", ' - ', "NomeCategoria")     AS "CodigoNomeCategoria",
                                     CONCAT("CodigoLaboratorio", ' - ', "NomeLaboratorio") AS "CodigoNomeLaboratorio"
FROM ( SELECT prod.codigo                                AS "CodigoProduto",
              prod.descricao                             AS "NomeProduto",
              CONCAT(prod.codigo, ' - ', prod.descricao) AS "CodigoNomeProduto",
              ( SELECT e2.codigobarras
                FROM embalagem e2
                WHERE prod.id = e2.produtoid
                LIMIT 1 )                                AS "CodigoBarras",
              CASE
                  WHEN c3.profundidade = 2
                      THEN c3.nome
                  WHEN c4.profundidade = 2
                      THEN c4.nome
                  WHEN c2.profundidade = 2
                      THEN c2.nome
                      ELSE c3.nome END                   AS "NomeGrupo",
              CASE
                  WHEN c3.profundidade = 2
                      THEN c3.id
                  WHEN c4.profundidade = 2
                      THEN c4.id
                  WHEN c2.profundidade = 2
                      THEN c2.id
                      ELSE c3.id END                     AS "CodigoGrupo",
              c2.id                                      AS "CodigoCategoria",
              c2.nome                                    AS "NomeCategoria",
              CAST(prod.datahorainclusao AS DATE)        AS "DataCadastro",
              CASE
                  WHEN prod.status = 'A'
                      THEN 1
                      ELSE 0
                  END                                    AS "Ativo",
              p.id                                       AS "CodigoLaboratorio",
              p.nome                                     AS "NomeLaboratorio",
              p2.nome                                    AS "PrincipioAtivo"
       FROM produto                                  prod
                LEFT JOIN fabricante                 f
                          ON f.id = prod.fabricanteid
                LEFT JOIN pessoa                     p
                          ON p.id = f.pessoaid
                LEFT JOIN classificacaoproduto       c
                          ON c.produtoid = prod.id
                LEFT JOIN v_classificacaoplanificada vc
                          ON vc.classificacaodescendenteid = c.classificacaoid
                LEFT JOIN classificacao              c2
                          ON c2.id = vc.classificacaodescendenteid
                LEFT JOIN classificacao              c3
                          ON c3.id = c2.classificacaopaiid
                LEFT JOIN classificacao              c4
                          ON c4.id = c3.classificacaopaiid
                LEFT JOIN principioativo             p2
                          ON p2.id = prod.principioativoid
       WHERE vc.classificacaoancestralid = 27325 ) pfpcvc2c3c4
