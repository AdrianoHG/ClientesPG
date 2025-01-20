SELECT CodigoProduto,
       CodigoBarras
FROM ( SELECT prod.codigoproduto AS "CodigoProduto",
              prod.codigobarra   AS "CodigoBarras"
       FROM produto prod
       UNION ALL
       SELECT p.CodigoProduto                         AS "CodigoProduto",
              COALESCE(p2.CodigoBarra, p.CodigoBarra) AS "CodigoBarras"
       FROM Produto                           p
                LEFT JOIN Produto_CodigoBarra p2
                          ON p2.CodigoProduto = p.CodigoProduto ) CPCBCPCB
