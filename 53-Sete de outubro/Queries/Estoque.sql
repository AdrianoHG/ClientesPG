SELECT "CodigoProduto",
       "CodigoLoja",
       "NomeProduto",
       "PermiteCompra",
       "QtdEstoque",
       "QtdEstoqueMinimo",
       "VlrPrecoCompra",
       "VlrPrecoVenda"
FROM ( SELECT pe.codigo                                      AS "CodigoProduto",
              pe.empresa                                     AS "CodigoLoja",
              p.descricao                                    AS "NomeProduto",
              CASE WHEN pe.comprar = 'SIM' THEN 1 ELSE 0 END AS "PermiteCompra",
              pe.est_atual                                   AS "QtdEstoque",
              pe.est_minimo                                  AS "QtdEstoqueMinimo",
              p.PRC_LIQ_ULT_ENTRADA / p.FRACAO               AS "VlrPrecoCompra",
              p.prc_venda                                    AS "VlrPrecoVenda"
       FROM estoques               pe
                LEFT JOIN produtos p
                          ON p.codigo = pe.codigo ) pp
