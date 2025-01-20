SELECT CodigoProduto,
       CodigoLoja,
       NomeProduto,
       PermiteCompra,
       QtdEstoque,
       QtdEstoqueMinimo,
       VlrPrecoCompra,
       VlrPrecoVenda
FROM (SELECT pe.ccodigo                AS "CodigoProduto",
             '01'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 2, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial01, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil01, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '02'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 3, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial02, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil02, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '03'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 4, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial03, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil03, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '04'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 5, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial04, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil04, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '05'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 6, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial05, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil05, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '06'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 7, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial06, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil06, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '07'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 8, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial07, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil07, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '08'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 9, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial08, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil08, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe
      UNION
      SELECT pe.ccodigo                AS "CodigoProduto",
             '09'                      AS "CodigoLoja",
             CASE
                 WHEN SUBSTRING(pe.ativocom, 10, 1) = 'X'
                     THEN 0
                 ELSE 1 END            AS "PermiteCompra",
             pe.cdesc                  AS "NomeProduto",
             COALESCE(pe.cfilial09, 0) AS "QtdEstoque",
             COALESCE(pe.cminfil09, 0) AS "QtdEstoqueMinimo",
             COALESCE(pe.ccusto, 0)    AS "VlrPrecoCompra",
             COALESCE(pe.cvenda, 0)    AS "VlrPrecoVenda"
      FROM alqui pe) pf
