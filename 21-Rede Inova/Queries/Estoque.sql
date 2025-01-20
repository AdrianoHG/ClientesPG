SELECT "CodigoProduto",
       "CodigoLoja",
       "NomeProduto",
       "PermiteCompra",
       "QtdEstoque",
       "QtdEstoqueMinimo",
       "VlrPrecoCompra",
       "VlrPrecoVenda"
FROM ( SELECT pe.codigoproduto                                                        AS "CodigoProduto",
              pe.codigoempresa                                                        AS "CodigoLoja",
              prod.nomeproduto                                                        AS "NomeProduto",
              CASE WHEN pe.CompoePedidoCompra = 'True' THEN 1 ELSE 0 END              AS "PermiteCompra",
              pe.estoque                                                              AS "QtdEstoque",
              pe.estoqueminimo                                                        AS "QtdEstoqueMinimo",
              CASE WHEN pe.PrecoCompra = 0 THEN pe.PrecoCusto ELSE pe.PrecoCompra END AS "VlrPrecoCompra",
              pe.precovenda                                                           AS "VlrPrecoVenda"
       FROM produto_estoque       pe
                LEFT JOIN produto prod
                          ON
                              prod.codigoproduto = pe.codigoproduto
       WHERE pe.ativo = 1 ) pp


/*SELECT pe.codigoproduto                                                               AS "CodigoProduto",
       prod.codigobarra                                                               AS "CodigoBarras",
       CASE WHEN pe.PrecoCompra = 0 THEN pe.PrecoCusto ELSE pe.PrecoCompra END        AS "VlrPrecoCompra",
       pe.precovenda                                                                  AS "VlrPrecoVenda",
       100 - (CASE
                  WHEN pe.PrecoCompra = 0
                      THEN CASE WHEN pe.PrecoCusto = 0 THEN 1 ELSE pe.PrecoCusto END
                      ELSE pe.PrecoCompra END * 100) / CASE
                                                           WHEN pe.PrecoVenda = 0
                                                               THEN 1
                                                               ELSE pe.PrecoVenda END AS "Markup"
FROM produto_estoque       pe
         LEFT JOIN produto prod
                   ON
                       prod.codigoproduto = pe.codigoproduto*/
