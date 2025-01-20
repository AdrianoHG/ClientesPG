SELECT "CodigoProduto",
       "CodigoLoja",
       "NomeProduto",
       "PermiteCompra",
       "QtdEstoque",
       "QtdEstoqueMinimo",
       "VlrPrecoCompra",
       "VlrPrecoVenda"
FROM ( SELECT "CodigoProduto",
              "CodigoLoja",
              "NomeProduto",
              "PermiteCompra",
              SUM("QtdEstoque")       AS "QtdEstoque",
              SUM("QtdEstoqueMinimo") AS "QtdEstoqueMinimo",
              AVG("VlrPrecoCompra")   AS "VlrPrecoCompra",
              AVG("VlrPrecoVenda")    AS "VlrPrecoVenda"
       FROM ( SELECT p.codigo                                        AS "CodigoProduto",
                     pe.unidadenegocioid                             AS "CodigoLoja",
                     p.descricao                                     AS "NomeProduto",
                     CASE WHEN s.produtoid IS NULL THEN 1 ELSE 0 END AS "PermiteCompra",
                     pe.estoque                                      AS "QtdEstoque",
                     e2.estoqueminimo                                AS "QtdEstoqueMinimo",
                     e.precoreferencial                              AS "VlrPrecoCompra",
                     e.precovenda                                    AS "VlrPrecoVenda"
              FROM estoque                                           pe
                       LEFT JOIN embalagem                           e
                                 ON e.id = pe.embalagemid AND e.embalagemcontidaid IS NULL
                       LEFT JOIN produto                             p
                                 ON p.id = e.produtoid
                       LEFT JOIN estoqueminimoprodutounidadenegocio  e2
                                 ON e2.unidadenegocioid = pe.unidadenegocioid
                                     AND p.id = e2.produtoid
                       LEFT JOIN suspendecompraprodutounidadenegocio s
                                 ON s.produtoid = p.id AND pe.unidadenegocioid = s.unidadenegocioid
                       LEFT JOIN unidadenegocio                      f
                                 ON f.id = pe.unidadenegocioid
              WHERE pe.unidadenegocioid IN (50000404035, 119053, 119052) ) v
       GROUP BY "CodigoProduto", "CodigoLoja", "NomeProduto", "PermiteCompra" ) a
