SELECT "CodigoLoja",
       "CodigoVenda",
       CAST("CodigoLoja" AS INTEGER) || CAST("CodigoVenda" AS INTEGER)                      AS "CodigoVendaUnico",
       "NroNota",
       "CodigoCaixa",
       "CodigoProduto",
       "LocalVenda",
       "DataVenda",
       "HoraVenda",
       "Fracao",
       "UnidadeFracao",
       "Quantidade",
       "VlrUnitario",
       "VlrLiquido",
       "VlrDesconto",
       "VlrBruto",
       "TipoVenda",
       "VlrCMV",
       "CodigoVendedor",
       "CodigoCliente",
       "FormaPagamento",
       "CodigoFormaPagamento",
       "CodigoFormaPagamento" || CAST(' - ' AS VARCHAR(5)) || "FormaPagamento"              AS "CodigoNomeFormaPagamento",
       "NomeEntregador",
       "CodigoEntregador",
       CAST("CodigoEntregador" AS INTEGER) || CAST(' - ' AS VARCHAR(5)) || "NomeEntregador" AS "CodigoNomeEntregador",
       "CodigoPBM",
       "NomePBM",
       CAST("CodigoPBM" AS INTEGER) || CAST(' - ' AS VARCHAR(5)) || "NomePBM"               AS "CodigoNomePBM"
FROM (SELECT VEN.EMPRESA                                           AS "CodigoLoja",
             VEN.VENDA                                             AS "CodigoVenda",
             VEN.VENDA                                             AS "CodigoVendaUnico",
             VEN.CUPOM                                             AS "NroNota",
             c.NRCAIXA                                             AS "CodigoCaixa",
             VPROD.PRODUTO                                         AS "CodigoProduto",
             CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN 'Delivery'
                 ELSE 'Balcão'
                 END
                                                                   AS "LocalVenda",
             'Venda'                                               AS "TipoVenda",
             VEN.DATA || CAST(' ' AS VARCHAR(5)) || VEN.HORA       AS "DataHoraVenda",
             CAST(VEN.DATA AS DATE)                                AS "DataVenda",
             CAST(VEN.HORA AS TIME)                                AS "HoraVenda",
             CASE
                 WHEN COALESCE(P.FRACAO, 1) = 0
                     THEN 1
                 ELSE COALESCE(P.FRACAO, 1) END                    AS "Fracao",
             P.UNIDADE                                             AS "UnidadeFracao",
             VPROD.QUANTI                                          AS "Quantidade",
             ROUND(VPROD.PRECOVENDA, 2)                            AS "VlrUnitario",
             ROUND(VPROD.TOTAL_VENDA, 2)                           AS "VlrLiquido",
             ROUND(VPROD.TOTAL_VENDA_BRUTO, 2)                     AS "VlrBruto",
             ROUND(VPROD.TOTAL_VENDA_BRUTO - VPROD.TOTAL_VENDA, 2) AS "VlrDesconto",
             ROUND((VPROD.CUSTO_CONTABIL * VPROD.QUANTI), 2)       AS "VlrCMV",
             VPROD.OPERADOR                                        AS "CodigoVendedor",
             VEN.CLIENTE                                           AS "CodigoCliente",
             CASE
                 WHEN c.DINHEIRO > 0
                     THEN 'Dinheiro'
                 WHEN c.CARTAO > 0
                     THEN 'Cartao'
                 WHEN c.APRAZO > 0
                     THEN 'A prazo'
                 WHEN c.DINHEIRO > 0
                     THEN 'Dinheiro'
                 WHEN c.CHEQUE > 0
                     THEN 'Cheque'
                 WHEN c.CONVENIO > 0
                     THEN 'Convenio'
                 WHEN c.OUTROS > 0
                     THEN 'Outros'
                 ELSE 'Outros'
                 END                                               AS "FormaPagamento",
             0                                                     AS "CodigoFormaPagamento",
             CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN ent.nome
                     else null end                     AS "NomeEntregador",
            CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN ent.codigo
                     else null end                  AS "CodigoEntregador",
             VPROD.SEQ,
             CASE
                 WHEN VEN.NOME_PBM IS NOT NULL THEN 0
                 ELSE NULL
                 END                                               AS "CodigoPBM",
             c.PBM                                                 AS "NomePBM"
      FROM VENDAS VEN
               JOIN VENDIDOS VPROD
                    ON VEN.VENDA = VPROD.VENDA AND VEN.EMPRESA = VPROD.EMPRESA
               INNER JOIN PRODUTOS P
                          ON P.CODIGO = VPROD.PRODUTO
               INNER JOIN caixa c
                          ON c.VENDA = VEN.VENDA AND c.EMPRESA = VEN.EMPRESA
                          LEFT JOIN ENTREGAS e
                                          ON e.venda = c.venda AND e.empresa = c.empresa
                                left JOIN FUNCIONA ENT
                                           ON ENT.CODIGO = E.ENTREGADOR
      WHERE CAST(VEN.DATA AS DATE) >= dateadd(-25 MONTH TO CURRENT_DATE)
      UNION
      SELECT VEN.EMPRESA                                                      AS "CodigoLoja",
             VEN.VENDA                                                        AS "CodigoVenda",
             VEN.VENDA                                                        AS "CodigoVendaUnico",
             VEN.CUPOM                                                        AS "NroNota",
             c.NRCAIXA                                                        AS "CodigoCaixa",
             VPROD.PRODUTO                                                    AS "CodigoProduto",
   CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN 'Delivery'
                 ELSE 'Balcão'
                 END
                                                                   AS "LocalVenda",
             'Devolução'                                                      AS "TipoVenda",
             VEN.DATA || CAST(' ' AS VARCHAR(5)) || VEN.HORA                  AS "DataHoraVenda",
             CAST(D.DATA AS DATE)                                             AS "DataVenda",
             CAST(VEN.HORA AS TIME)                                           AS "HoraVenda",
             CASE
                 WHEN COALESCE(P.FRACAO, 1) = 0
                     THEN 1
                 ELSE COALESCE(P.FRACAO, 1) END                               AS "Fracao",
             P.UNIDADE                                                        AS "UnidadeFracao",
             DPROD.QUANTI * (-1)                                              AS "Quantidade",
             ROUND(DPROD.PRECO * (-1), 2)                                     AS "VlrUnitario",
             ROUND((DPROD.PRECO * DPROD.QUANTI) * (-1), 2)                    AS "VlrLiquido",
             ROUND(((DPROD.PRECO * DPROD.QUANTI) + DPROD.DESCONTO) * (-1), 2) AS "VlrBruto",
             ROUND((DPROD.DESCONTO) * (-1), 2)                                AS "VlrDesconto",
             ROUND((DPROD.CUSTO) * DPROD.QUANTI * (-1), 2)                    AS "VlrCMV",
             VPROD.OPERADOR                                                   AS "CodigoVendedor",
             VEN.CLIENTE                                                      AS "CodigoCliente",
             CASE
                 WHEN c.DINHEIRO > 0
                     THEN 'Dinheiro'
                 WHEN c.CARTAO > 0
                     THEN 'Cartao'
                 WHEN c.APRAZO > 0
                     THEN 'A prazo'
                 WHEN c.DINHEIRO > 0
                     THEN 'Dinheiro'
                 WHEN c.CHEQUE > 0
                     THEN 'Cheque'
                 WHEN c.CONVENIO > 0
                     THEN 'Convenio'
                 WHEN c.OUTROS > 0
                     THEN 'Outros'
                 ELSE 'Outros'
                 END                                                          AS "FormaPagamento",
             0                                                                AS "CodigoFormaPagamento",
             CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN ent.nome
                     else null end                     AS "NomeEntregador",
            CASE
                 WHEN c.teleentrega = 'SIM'
                     THEN ent.codigo
                     else null end                  AS "CodigoEntregador",
             VPROD.SEQ,
             CASE
                 WHEN VEN.NOME_PBM IS NOT NULL THEN 0
                 ELSE NULL
                 END                                                          AS "CodigoPBM",
             c.PBM                                                            AS "NomePBM"
      FROM DEVOLVE D
               INNER JOIN DEVOLVIDOS DPROD
                          ON DPROD.VENDA = D.VENDA AND DPROD.EMPRESA = D.EMPRESA
               JOIN VENDAS VEN
                    ON D.ID_VENDA = VEN.VENDA AND D.EMP_VENDA = VEN.EMPRESA
               JOIN VENDIDOS VPROD
                    ON VEN.VENDA = VPROD.VENDA AND VEN.EMPRESA = VPROD.EMPRESA AND DPROD.SEQ_VENDIDOS = VPROD.SEQ
               INNER JOIN PRODUTOS P
                          ON P.CODIGO = VPROD.PRODUTO
               INNER JOIN caixa c
                          ON c.VENDA = VEN.VENDA AND c.EMPRESA = VEN.EMPRESA
                                                    LEFT JOIN ENTREGAS e
                                          ON e.venda = c.venda AND e.empresa = c.empresa
                                left JOIN FUNCIONA ENT
                                           ON ENT.CODIGO = E.ENTREGADOR
      WHERE CAST(D.DATA AS DATE) >= dateadd(-25 month TO CURRENT_DATE)) V
