WITH compras AS ( SELECT n.unidadenegocioid                           AS "CodigoLoja",
                         TRIM(UPPER(COALESCE(p.razaosocial, p.nome))) AS "NomeRazaoSocialFornecedor",
                         n.id                                         AS "CodigoCompra",
                         n.numero                                     AS "NroNF",
                         prod.codigo                                  AS "CodigoProduto",
                         0                                            AS "TipoCompra",
                         CAST(n.datahoraemissao AS DATE)              AS "DataEmissaoNF",
                         COALESCE(e.quantidadeporembalagem, 1)        AS "Fracao",
                         i.quantidade                                 AS "Quantidade",
                         i.valorunitario                              AS "VlrUnitario",
                         i.desconto                                   AS "VlrDesconto",
                         NULL                                         AS "CodigoTransferencia",
                         NULL                                         AS "OrigemTransferencia",
                         NULL                                         AS "DataTransferencia",
                         NULL                                         AS "DestinoTransfencia",
                         (i.valortotal + i.ipivalor + i.rateiofrete + i.icmsstvalor - i.icmsdesoneradovalor -
                          i.rateiodesconto + i.icmsstfcpvalor)        AS "VlrTotalLiquido",
                         p.nome                                       AS "NomeFornecedorFantasia",
                         i.cfop                                       AS "Cfop"
                  FROM notafiscal                   n
                           LEFT JOIN itemnotafiscal i
                                     ON notafiscalid = n.id
                           LEFT JOIN embalagem      e
                                     ON e.id = i.embalagemid
                           LEFT JOIN produto        prod
                                     ON prod.id = e.produtoid
                           LEFT JOIN fornecedor     forn
                                     ON forn.id = n.fornecedorid
                           LEFT JOIN pessoa         p
                                     ON p.id = forn.pessoaid
                           LEFT JOIN unidadenegocio u
                                     ON n.unidadenegocioid = u.id
                  WHERE n.unidadenegocioid IN (50000404035, 119053, 119052)
                    AND CAST(n.datahoraemissao AS DATE) >= (CURRENT_DATE - INTERVAL '24 month')
                    AND n.status IN ('C')
                  UNION ALL
                  SELECT t.unidadenegociodestinoid                    AS "CodigoLoja",
                         TRIM(UPPER(COALESCE(p.razaosocial, p.nome))) AS "NomeRazaoSocialFornecedor",
                         t.id                                         AS "CodigoCompra",
                         t.id                                         AS "NroNF",
                         prod.codigo                                  AS "CodigoProduto",
                         CAST(1 AS BIGINT)                            AS "TipoCompra",
                         CAST(t.datahora AS DATE)                     AS "DataEmissaoNF",
                         COALESCE(e.quantidadeporembalagem, 1)        AS "Fracao",
                         i2.quantidade                                AS "Quantidade",
                         i2.valorunitario                             AS "VlrUnitario",
                         0                                            AS "VlrDesconto",
                         t.id                                         AS "CodigoTransferencia",
                         t.unidadenegocioorigemid                     AS "OrigemTransferencia",
                         t.datahora                                   AS "DataTransferencia",
                         t.unidadenegociodestinoid                    AS "DestinoTransfencia",
                         i2.valortotal                                AS "VlrTotalLiquido",
                         p.nome                                       AS "NomeFornecedorFantasia",
                         NULL                                         AS "Cfop"
                  FROM transferencia                   t
                           LEFT JOIN itemtransferencia i2
                                     ON i2.transferenciaid = t.id
                           LEFT JOIN embalagem         e
                                     ON e.id = i2.embalagemid
                           LEFT JOIN produto           prod
                                     ON prod.id = e.produtoid
                           LEFT JOIN fabricante        forn
                                     ON forn.id = prod.fabricanteid
                           LEFT JOIN pessoa            p
                                     ON p.id = forn.pessoaid
                  WHERE CAST(t.datahora AS DATE) >= (CURRENT_DATE - INTERVAL '24 month') )
SELECT "CodigoLoja",
       "NomeRazaoSocialFornecedor",
       "CodigoCompra",
       "NroNF",
       "CodigoProduto",
       "TipoCompra",
       "Cfop",
       "DataEmissaoNF",
       "Fracao",
       "Quantidade",
       "VlrUnitario",
       "VlrDesconto",
       "CodigoTransferencia",
       "OrigemTransferencia",
       "DataTransferencia",
       "DestinoTransfencia",
       "VlrTotalLiquido",
       "NomeFornecedorFantasia"
FROM compras c
