WITH Pagamento AS ( SELECT pp.nomepagamento, pp.CodigoPagamento, vp.CodigoVenda
                    FROM venda_pagamento               vp
                             LEFT JOIN plano_pagamento pp
                                       ON pp.codigopagamento = vp.codigopagamento ),
     base AS ( SELECT ven.codigoempresa                                                 AS "CodigoLoja",
                      ven.codigovenda                                                   AS "CodigoVenda",
                      ven.cupom                                                         AS "NroNota",
                      ca.CodigoCaixa                                                    AS "CodigoCaixa",
                      vprod.codigoproduto                                               AS "CodigoProduto",
                      IIF(( SELECT TOP 1 ve.codigoentrega
                            FROM venda_entrega ve
                            WHERE ve.codigovenda = ven.codigovenda
                              AND ve.eliminado = 0 ) IS NOT NULL, 'Delivery', 'Balcão') AS "LocalVenda",
                      ven.datavenda                                                     AS "DataHoraVenda",
                      CAST(ven.datavenda AS DATE)                                       AS "DataVenda",
                      CAST(ven.datavenda AS TIME)                                       AS "HoraVenda",
                      CASE
                          WHEN COALESCE(vprod.fracao, 1) = 0
                              THEN 1
                              ELSE COALESCE(vprod.fracao, 1) END                        AS "Fracao",
                      vprod.unidade                                                     AS "UnidadeFracao",
                      vprod.quantidade                                                  AS "Quantidade",
                      vprod.precounitario                                               AS "VlrUnitario",
                      CAST(
                              CASE
                                  WHEN pbmconf.codigopbm IS NOT NULL
                                      THEN vprod.total + (pbmp.qtdeautorizada * pbmp.descontounitariopbm)
                                      ELSE vprod.total
                                  END AS DECIMAL(10, 2)
                      )                                                                 AS "VlrLiquido",
                      vprod.totaldesconto                                               AS "VlrDesconto",
                      vprod.precocusto * (vprod.quantidade)                             AS "VlrCMV",
                      vprod.codigofuncionario                                           AS "CodigoVendedor",
                      cli.CodigoCliente                                                 AS "CodigoCliente",
                      ( SELECT TOP 1 p2.NomePagamento
                        FROM Pagamento p2
                        WHERE p2.codigovenda = ven.codigovenda )                        AS "FormaPagamento",
                      ( SELECT TOP 1 p2.CodigoPagamento
                        FROM Pagamento p2
                        WHERE p2.codigovenda = ven.codigovenda )                        AS "CodigoFormaPagamento",
                      ( SELECT TOP 1 ent.CodigoCadastro
                        FROM venda_entrega                         ve
                                 LEFT JOIN venda_entrega_efetivada vee
                                           ON vee.codigoentrega = ve.codigoentrega
                                 LEFT JOIN venda_entrega_saida     ves
                                           ON ves.CodigoEntrega = vee.CodigoEntrega
                                 LEFT JOIN dbo.funcionario         func
                                           ON func.CodigoFuncionario = ves.CodigoFuncionario
                                 LEFT JOIN dbo.cadastro            ent
                                           ON func.codigocadastro = ent.codigocadastro
                        WHERE ve.codigovenda = ven.codigovenda
                          AND ve.eliminado = 0 )                                        AS "CodigoEntregador",
                      ( SELECT TOP 1 ent.Nome
                        FROM venda_entrega                         ve
                                 LEFT JOIN venda_entrega_efetivada vee
                                           ON vee.codigoentrega = ve.codigoentrega
                                 LEFT JOIN venda_entrega_saida     ves
                                           ON ves.CodigoEntrega = vee.CodigoEntrega
                                 LEFT JOIN dbo.funcionario         func
                                           ON func.CodigoFuncionario = ves.CodigoFuncionario
                                 LEFT JOIN dbo.cadastro            ent
                                           ON func.codigocadastro = ent.codigocadastro
                        WHERE ve.codigovenda = ven.codigovenda
                          AND ve.eliminado = 0 )                                        AS "NomeEntregador",
                      p.CodigoPBM                                                       AS "CodigoPBM",
                      p.NomePBM                                                         AS "NomePBM"
               FROM venda                                                          ven
                        LEFT JOIN Caixa_Abertura                                   ca
                                  ON ca.CodigoEmpresa = ven.CodigoEmpresa
                                      AND ca.CodigoAbertura = ven.CodigoAbertura
                        LEFT JOIN venda_produto                                    vprod
                                  ON ven.codigovenda = vprod.codigovenda
                        LEFT JOIN venda_pbm                                        pbm
                                  ON ven.codigovenda = pbm.codigovenda
                        LEFT JOIN PBM                                              p
                                  ON p.CodigoPBM = pbm.CodigoPBM
                        LEFT JOIN venda_produto_pbm                                pbmp
                                  ON vprod.codigovendaid = pbmp.codigovendaid
                        LEFT JOIN ( SELECT DISTINCT codigopbm FROM pbm_config_fp ) pbmconf
                                  ON pbm.codigopbm = pbmconf.codigopbm
                        LEFT JOIN config                                           loja
                                  ON loja.codigoempresa = ven.codigoempresa
                        LEFT JOIN cadastro                                         cad
                                  ON cad.codigocadastro = ven.codigocadastro
                        LEFT JOIN cliente                                          cli
                                  ON cad.codigocadastro = cli.codigocadastro
               WHERE CAST(ven.datavenda AS DATE) >= DATEADD(MONTH, -25, CAST(GETDATE() AS DATE))
                 AND ven.eliminado = 0
                 AND ven.CodigoAbertura IS NOT NULL
                 AND vprod.codigoproduto IS NOT NULL )
SELECT CodigoLoja,
       CodigoVenda,
       CAST(CAST(CodigoVenda AS VARCHAR(50)) + '' +
            CAST(CodigoLoja AS VARCHAR(50)) AS INTEGER)                   AS "CodigoVendaUnico",
       NroNota,
       CodigoCaixa,
       CodigoProduto,
       LocalVenda,
       DataVenda,
       HoraVenda,
       Fracao,
       UnidadeFracao,
       Quantidade,
       VlrUnitario,
       VlrLiquido,
       VlrDesconto,
       VlrLiquido + VlrDesconto                                           AS "VlrBruto",
       CASE
           WHEN vlrliquido < 0
               THEN 'Devolução'
               ELSE 'Venda'
           END                                                            AS "TipoVenda",
       VlrCMV,
       CodigoVendedor,
       CodigoCliente,
       FormaPagamento,
       CodigoFormaPagamento,
       CAST(CodigoFormaPagamento AS VARCHAR(10)) + ' - ' + FormaPagamento AS "CodigoNomeFormaPagamento",
       NomeEntregador,
       CodigoEntregador,
       CAST(CodigoEntregador AS VARCHAR(10)) + ' - ' + NomeEntregador     AS "CodigoNomeEntregador",
       CodigoPBM,
       NomePBM,
       CAST(CodigoPBM AS VARCHAR(10)) + ' - ' + NomePBM                   AS "CodigoNomePBM"
FROM base
