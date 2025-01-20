SELECT "CodigoLoja",
       "NomeRazaoSocialFornecedor",
       "CodigoCompra",
       "NroNF",
       "Cfop",
       "CodigoProduto",
       "TipoCompra",
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
FROM ( SELECT cp.empresa                                                           AS "CodigoLoja",
              TRIM(UPPER(cp.fornecedor)) AS "NomeRazaoSocialFornecedor",
              cp.id                                                                AS "CodigoCompra",
              cp.numero                                                            AS "NroNF",
              cp_pd.CFOP                                                           AS "Cfop",
              cp_pd.codigo                                                         AS "CodigoProduto",
              CASE
                  WHEN (cp.ORIGEM_TRANSF = 0 OR cp.ORIGEM_TRANSF IS NULL)
                      THEN 0
                      ELSE 1
                  END                                                              AS "TipoCompra",
              CAST(cp.entrada AS DATE)                                             AS "DataEmissaoNF",
              CASE
                  WHEN cp_pd.FRACAO = 0
                      THEN 1
                      ELSE cp_pd.FRACAO END                                        AS "Fracao",
              cp_pd.quantidade                                                     AS "Quantidade",
              cp_pd.prc_total / (cp_pd.QUANTIDADE * CASE
                                                        WHEN cp_pd.FRACAO = 0
                                                            THEN 1
                                                            ELSE cp_pd.FRACAO END) AS "VlrUnitario",
              cp_pd.valdesc                                                        AS "VlrDesconto",
              cp.REF_TRANSF                                                        AS "CodigoTransferencia",
              CASE WHEN cp.ORIGEM_TRANSF = 0 THEN NULL ELSE cp.ORIGEM_TRANSF END   AS "OrigemTransferencia",
              NULL                                                                 AS "DataTransferencia",
              CASE WHEN cp.destino_transf = 0 THEN NULL ELSE cp.destino_transf END AS "DestinoTransfencia",
              cp_pd.prc_total                                                      AS "VlrTotalLiquido",
              TRIM(UPPER(cp.fornecedor)) AS "NomeFornecedorFantasia"
       FROM notas_g                cp
                LEFT JOIN prd_nf_g cp_pd
                          ON cp.id = cp_pd.id_nota AND cp.empresa = cp_pd.empresa
       WHERE cp.entrada >= dateadd(-24 MONTH TO CURRENT_DATE) ) ccp
