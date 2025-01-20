SELECT CodigoLoja,
       NomeRazaoSocialFornecedor,
       CodigoCompra,
       NroNF,
       Cfop,
       CodigoProduto,
       TipoCompra,
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
FROM (SELECT cp.filial                                         AS "CodigoLoja",
             TRIM(UPPER(COALESCE(forn.fornom, forn.forfan)))   AS "NomeRazaoSocialFornecedor",
             cp.ndc                                            AS "CodigoCompra",
             cp.nfatura                                        AS "NroNF",
             cp_pd.cfopprod                                    AS "Cfop",
             cp_pd.codiprod                                    AS "CodigoProduto",
             0                                                 AS "TipoCompra",
             CAST(cp.demite AS DATE)                           AS "DataEmissaoNF",
             COALESCE(prod.qtembind, 1)                        AS "Fracao",
             cp_pd.quanprod                                    AS "Quantidade",
             (((cp_pd.quanprod * cp_pd.valoprod) - COALESCE(cp_pd.vdesc, 0))
                 + COALESCE(cp_pd.valosubs, 0) + COALESCE(cp_pd.vipi, 0)
                 + COALESCE(cp_pd.voutro, 0)) / cp_pd.quanprod AS "VlrUnitario",
             COALESCE(cp_pd.vdesc, 0)                          AS "VlrDesconto",
             NULL                                              AS "CodigoTransferencia",
             NULL                                              AS "OrigemTransferencia",
             NULL                                              AS "DataTransferencia",
             NULL                                              AS "DestinoTransfencia",
             ((cp_pd.quanprod * cp_pd.valoprod) - COALESCE(cp_pd.vdesc, 0))
                 + COALESCE(cp_pd.valosubs, 0) + COALESCE(cp_pd.vipi, 0)
                 + COALESCE(cp_pd.voutro, 0)                   AS "VlrTotalLiquido",
             forn.forfan                                       AS "NomeFornecedorFantasia"
      FROM alqent cp
               LEFT JOIN notapro cp_pd
                         ON cp.codinota = cp_pd.codinota
               LEFT JOIN alqui prod ON prod.ccodigo = cp_pd.codiprod
               LEFT JOIN forarq forn ON forn.forcod = cp.forn
      WHERE CAST(cp.demite AS DATE) >= CAST(ADDDATE(NOW(), INTERVAL -24 MONTH) AS DATE)
        AND cp.entrsaid = 'E'
        AND cp.statnota <> '2') ccppf
