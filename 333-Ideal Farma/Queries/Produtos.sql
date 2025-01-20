SELECT CodigoProduto,
       NomeProduto,
       CodigoNomeProduto,
       CodigoBarras,
       NomeGrupo,
       CodigoGrupo,
       CodigoCategoria,
       NomeCategoria,
       DataCadastro,
       Ativo,
       CodigoLaboratorio,
       NomeLaboratorio,
       PrincipioAtivo,
       CONCAT(CodigoGrupo, ' - ', NomeGrupo)             AS CodigoNomeGrupo,
       CONCAT(CodigoCategoria, ' - ', NomeCategoria)     AS CodigoNomeCategoria,
       CONCAT(CodigoLaboratorio, ' - ', NomeLaboratorio) AS CodigoNomeLaboratorio
FROM (SELECT prod.ccodigo                            AS "CodigoProduto",
             prod.cdesc                              AS "NomeProduto",
             CONCAT(prod.ccodigo, ' - ', prod.cdesc) AS "CodigoNomeProduto",
             prod.ean13                              AS "CodigoBarras",
             pgrupo.nome                             AS "NomeGrupo",
             d.codcat                                AS "CodigoGrupo",
             d.codigo                                AS "CodigoCategoria",
             d.nome                                  AS "NomeCategoria",
             CAST(prod.ccadast AS DATE)              AS "DataCadastro",
             CASE
                 WHEN prod.sr_deleted <> 'T'
                     THEN 1
                 ELSE 0
                 END                                 AS "Ativo",
             prod.ccodlab                            AS "CodigoLaboratorio",
             (SELECT l.nome
              FROM lab l
              WHERE l.codigo = prod.ccodlab
              LIMIT 1)                               AS "NomeLaboratorio",
             pri.descprin                            AS "PrincipioAtivo"
      FROM alqui prod
               LEFT JOIN departs d
                         ON prod.ccoddep = d.codigo
               LEFT JOIN catego pgrupo
                         ON d.codcat = pgrupo.codigo
               LEFT JOIN prinativ pri ON pri.codiprin = prod.codiprin) pdp
GROUP BY CodigoProduto
