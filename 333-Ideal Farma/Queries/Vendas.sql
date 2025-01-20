SELECT CodigoLoja,
       CodigoVenda,
       CONCAT(CodigoVenda, CodigoLoja)                     AS "CodigoVendaUnico",
       CodigoCaixa,
       NroNota,
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
       VlrBruto,
       TipoVenda,
       VlrCMV,
       CodigoVendedor,
       CodigoCliente,
       FormaPagamento,
       CodigoFormaPagamento,
       CONCAT(CodigoFormaPagamento, ' - ', FormaPagamento) AS "CodigoNomeFormaPagamento",
       NomeEntregador,
       CodigoEntregador,
       CONCAT(CodigoEntregador, ' - ', NomeEntregador)     AS "CodigoNomeEntregador",
       CONCAT(CodigoPBM, ' - ', NomePBM)                   AS "CodigoNomePBM",
       CodigoPBM,
       NomePBM
FROM (SELECT COALESCE(m.loc, 01)                  AS "CodigoLoja",
             m.ndc                                AS "CodigoVenda",
             m.caixa                              AS "CodigoCaixa",
             m.ndc                                AS "CodigoVendaUnico",
             m.ndc                                AS "NroNota",
             m.codigo                             AS "CodigoProduto",
             CASE
                 WHEN ent.ndc IS NOT NULL THEN 'Delivery'
                 ELSE 'Balcão'
                 END                              AS "LocalVenda",
             CASE
                 WHEN m.oper = 'A' THEN 'Devolução'
                 ELSE 'Venda'
                 END                              AS "TipoVenda",
             CAST(m.data AS DATE)                 AS "DataVenda",
             CAST(m.hora AS TIME)                 AS "HoraVenda",
             COALESCE(prod.qtembind, 1)           AS "Fracao",
             prod.cunida                          AS "UnidadeFracao",
             CASE
                 WHEN m.oper = 'A' THEN m.qt * (-1)
                 ELSE m.qt
                 END                              AS "Quantidade",
             CASE
                 WHEN m.oper = 'A' THEN
                     ((COALESCE(m.valor2, 0) * m.qt) +
                      COALESCE(COALESCE(COALESCE(m.valor1, m.valor5), m.valor6), 0)) * (-1)
                 ELSE ((COALESCE(m.valor2, 0)) +
                       COALESCE(COALESCE(COALESCE(m.valor1, m.valor5), m.valor6), 0)) / m.qt
                 END                              AS "VlrUnitario",
             CASE
                 WHEN m.oper = 'A' THEN ((m.valor2 * m.qt) - COALESCE(m.valor1, 0)) * (-1)
                 ELSE (COALESCE(m.valor2, 0) - (COALESCE(COALESCE(m.valor1, 0), 0)))
                 END                              AS "VlrLiquido",
             CASE
                 WHEN m.oper = 'A' THEN
                     ((COALESCE(m.valor2, 0) * m.qt) +
                      COALESCE(COALESCE(COALESCE(m.valor1, m.valor5), m.valor6), 0)) * (-1)
                 ELSE (COALESCE(m.valor2, 0)) +
                      COALESCE(COALESCE(COALESCE(m.valor1, m.valor5), m.valor6), 0)
                 END                              AS "VlrBruto",
             CASE
                 WHEN m.oper = 'A' THEN COALESCE(m.valor1, 0) * (-1)
                 ELSE COALESCE(COALESCE(COALESCE(m.valor1, m.valor5), m.valor6), 0)
                 END                              AS "VlrDesconto",
             CASE
                 WHEN m.oper = 'A' THEN (prod.ccusto1 * m.qt) * (-1)
                 ELSE COALESCE(prod.ccusto1, 0) * m.qt
                 END                              AS "VlrCMV",
             m.resp                               AS "CodigoVendedor",
             COALESCE(balcao.codcli, ent.cliente) AS "CodigoCliente",
             NULL                                 AS "FormaPagamento",
             ent.entregador                       AS "CodigoEntregador",
             entregador.nome                      AS "NomeEntregador",
             NULL                                 AS "CodigoFormaPagamento",
             pbm.codipbms                         AS "CodigoPBM",
             pbm.descpbms                         AS "NomePBM"
      FROM mov m
               INNER JOIN alqui prod
                          ON prod.ccodigo = m.codigo
               LEFT JOIN vecli balcao
                         ON balcao.ndc = m.ndc
                             AND m.codigo = balcao.codigo
                             AND balcao.data = m.data
                             AND balcao.hora = m.hora
                             AND balcao.ordeprod = RIGHT(m.dadotrib, 3)
                             AND balcao.sr_deleted <> 'T'
               LEFT JOIN histent ent
                         ON ent.ndc = m.ndc
                             AND m.data = ent.data
                             AND m.loc = ent.filial
                             AND ent.sr_deleted <> 'T'
               LEFT JOIN vendedor entregador ON entregador.codigo = ent.entregador
               LEFT JOIN contpbms vpbm
                         ON vpbm.numectrl = m.ndc AND vpbm.sr_deleted <> 'T' AND vpbm.codifili = m.loc
                             AND vpbm.datavend = m.data
               LEFT JOIN pbm pbm ON pbm.codipbms = vpbm.codipbms
      WHERE m.oper IN ('E', 'A')
        AND CAST(m.data AS DATE) >= CAST(ADDDATE(NOW(), INTERVAL -25 MONTH) AS DATE)
        AND m.ndc IS NOT NULL
        AND m.resp IS NOT NULL
        AND m.codigo NOT IN ('-------', '---P---')) mvnvp


/*-- Indices para otimizacao de vendas
 -- Índice para a tabela 'mov' nas colunas usadas na cláusula WHERE e JOIN
 CREATE INDEX idx_mov_oper_data_loc_ndc_resp_codigo ON mov (oper, data, loc, ndc, resp, codigo);
 -- Índice para a tabela 'alqui' na coluna 'ccodigo'
 -- Se 'ccodigo' for uma chave primária, esse índice já existe e não é necessário criá-lo.
 CREATE INDEX idx_alqui_ccodigo ON alqui (ccodigo);
 -- Índice para a tabela 'vecli' nas colunas usadas na cláusula JOIN
 CREATE INDEX idx_vecli_ndc_codigo_data_hora ON vecli (ndc, codigo, data, hora);
 -- Índice para a tabela 'histent' nas colunas usadas na cláusula JOIN
 CREATE INDEX idx_histent_ndc_data_filial ON histent (ndc, data, filial);
 -- Índice para a tabela 'vendedor' na coluna 'codigo'
 -- Se 'codigo' for uma chave primária, esse índice já existe e não é necessário criá-lo.
 CREATE INDEX idx_vendedor_codigo ON vendedor (codigo);
 CREATE INDEX idx_vpbm ON contpbms (numectrl);
 CREATE INDEX idx_codipbm ON contpbms (codipbms);
 CREATE INDEX idx_codipbm2 ON pbm (codipbms);*/
