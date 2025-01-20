SELECT CodigoLoja,
       NomeRazaoSocialFornecedor,
       CodigoCompra,
       NroNF,
       CodigoProduto,
       TipoCompra,
       Cfop,
       DataEmissaoNF,
       Fracao,
       Quantidade,
       VlrUnitario,
       VlrDesconto,
       CodigoTransferencia,
       OrigemTransferencia,
       DataTransferencia,
       DestinoTransfencia,
       VlrTotalLiquido,
       NomeFornecedorFantasia
FROM ( SELECT cp.codigoempresa                                               AS "CodigoLoja",
              RTRIM(LTRIM(UPPER(COALESCE(cad.Nome, cad.NomeFantasia)))) AS "NomeRazaoSocialFornecedor",
              cp.codigocompra                                                AS "CodigoCompra",
              cp.numeronota                                                  AS "NroNF",
              cp_pd.codigoproduto                                            AS "CodigoProduto",
              cp_pd.CFOP                                                     AS "Cfop",
              cp.tipocompra                                                  AS "TipoCompra",
              CAST(cp.datanota AS DATE)                                      AS "DataEmissaoNF",
              cp_pd.fracaovenda                                              AS "Fracao",
              cp_pd.quantidade                                               AS "Quantidade",
              ((cp_pd.total + cp_pd.valorst + cp_pd.totalipi + cp_pd.totaloutros + cp_pd.totalfrete +
                cp_pd.totalfcpst + cp_pd.totaldifal) -
               cp_pd.totaldesconto) / (cp_pd.Quantidade * cp_pd.FracaoVenda) AS "VlrUnitario",
              cp_pd.totaldesconto                                            AS "VlrDesconto",
              transe.codigotransferencia                                     AS "CodigoTransferencia",
              transe.codigoempresa                                           AS "OrigemTransferencia",
              transe.datasolicitacao                                         AS "DataTransferencia",
              transe.codigoempresadestino                                    AS "DestinoTransfencia",
              ((cp_pd.total + cp_pd.valorst + cp_pd.totalipi + cp_pd.totaloutros + cp_pd.totalfrete +
                cp_pd.totalfcpst + cp_pd.totaldifal) -
               cp_pd.totaldesconto)                                          AS "VlrTotalLiquido",
              cad.nomefantasia                                               AS "NomeFornecedorFantasia"
       FROM compra                                       cp
                LEFT JOIN compra_produto                 cp_pd
                          ON cp.codigocompra = cp_pd.codigocompra
                LEFT JOIN estoque_transferencia_operacao transo
                          ON transo.codigolancamento = cp.codigolancamento
                LEFT JOIN estoque_transferencia          transe
                          ON transe.codigotransferencia = transo.codigotransferencia
                LEFT JOIN fornecedor                     forn
                          ON forn.codigocadastro = cp.codigocadastro
                LEFT JOIN cadastro                       cad
                          ON cad.codigocadastro = cp.codigocadastro
       WHERE cp.eliminado = 0
         AND transe.Operacao IS NULL
         AND cp.datanota >= DATEADD(MONTH, -24, CAST(GETDATE() AS DATE))
       UNION ALL
       SELECT CASE
                  WHEN et.operacao = 1
                      THEN et.CodigoEmpresa
                      ELSE et.CodigoEmpresaDestino
                  END                          AS "CodigoLoja",
              CASE
                  WHEN et.operacao = 1
                      THEN RTRIM(LTRIM(UPPER(forn2.NomeFilial)))
                      ELSE RTRIM(LTRIM(UPPER(forn.NomeFilial)))
                  END                          AS "NomeRazaoSocialFornecedor",
              et.CodigoTransferencia           AS "CodigoCompra",
              et.CodigoTransferencia           AS "NroNF",
              etp.CodigoProduto                AS "CodigoProduto",
              NULL                             AS "Cfop",
              CAST(1 AS TINYINT)               AS "TipoCompra",
              CAST(et.DataSolicitacao AS DATE) AS "DataEmissaoNF",
              1                                AS "Fracao",
              etp.QuantidadeSolicitada         AS "Quantidade",
              etp.PrecoCusto                   AS "VlrUnitario",
              0                                AS "VlrDesconto",
              et.CodigoTransferencia           AS "CodigoTransferencia",
              CASE
                  WHEN et.operacao = 1
                      THEN et.CodigoEmpresaDestino
                      ELSE et.CodigoEmpresa
                  END                          AS "OrigemTransferencia",
              et.datasolicitacao               AS "DataTransferencia",
              CASE
                  WHEN et.operacao = 1
                      THEN et.CodigoEmpresa
                      ELSE et.CodigoEmpresaDestino
                  END                          AS "DestinoTransfencia",
              etp.TotalCusto                   AS "VlrTotalLiquido",
              CASE
                  WHEN et.operacao = 1
                      THEN RTRIM(LTRIM(UPPER(forn2.NomeFilial)))
                      ELSE RTRIM(LTRIM(UPPER(forn.NomeFilial)))
                  END                          AS "NomeFornecedorFantasia"
       FROM Estoque_Transferencia                        et
                INNER JOIN Estoque_Transferencia_Produto etp
                           ON etp.CodigoTransferencia = et.CodigoTransferencia
                LEFT JOIN  config                        forn
                           ON forn.CodigoEmpresa = et.CodigoEmpresa
                LEFT JOIN  config                        forn2
                           ON forn2.CodigoEmpresa = et.CodigoEmpresaDestino
       WHERE DataSolicitacao >= DATEADD(MONTH, -24, CAST(GETDATE() AS DATE))
         AND et.Eliminado = 0 ) ccpttfc
