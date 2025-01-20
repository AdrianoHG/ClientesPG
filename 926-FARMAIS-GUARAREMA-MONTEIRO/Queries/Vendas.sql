SELECT "CodigoLoja",
       "CodigoVenda",
       CONCAT("CodigoVenda", "CodigoLoja")                     AS "CodigoVendaUnico",
       "CodigoCaixa",
       "NroNota",
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
       CONCAT("CodigoFormaPagamento", ' - ', "FormaPagamento") AS "CodigoNomeFormaPagamento",
       "NomeEntregador",
       "CodigoEntregador",
       CONCAT("CodigoEntregador", ' - ', "NomeEntregador")     AS "CodigoNomeEntregador",
       CONCAT("CodigoPBM", ' - ', "NomePBM")                   AS "CodigoNomePBM",
       "CodigoPBM",
       "NomePBM"
FROM ( SELECT ven.unidadenegocioid                                          AS "CodigoLoja",
              ven.id                                                        AS "CodigoVenda",
              ven.id                                                        AS "CodigoVendaUnico",
              ven.caixaid                                                   AS "CodigoCaixa",
              ven.ccf                                                       AS "NroNota",
              p.codigo                                                      AS "CodigoProduto",
              CASE
                  WHEN en.id IS NOT NULL
                      THEN 'Delivery'
                      ELSE 'Balcão'
                  END                                                       AS "LocalVenda",
              CASE
                  WHEN vprod.status = 'D'
                      THEN 'Devolução'
                      ELSE 'Venda'
                  END                                                       AS "TipoVenda",
              ven.datahorafechamento                                        AS "DataHoraVenda",
              CAST(ven.datahorafechamento AS DATE)                          AS "DataVenda",
              CAST(ven.datahorafechamento AS TIME)                          AS "HoraVenda",
              CASE
                  WHEN COALESCE(e.quantidadeporembalagem, 1) = 0
                      THEN 1
                      ELSE COALESCE(e.quantidadeporembalagem, 1) END        AS "Fracao",
              p.unidade                                                     AS "UnidadeFracao",
              vprod.quantidade                                              AS "Quantidade",
              vprod.valorunitario                                           AS "VlrUnitario",
              vprod.valortotal                                              AS "VlrLiquido",
              (vprod.valortotal + (vprod.valordesconto * vprod.quantidade)) AS "VlrBruto",
              vprod.valordesconto * vprod.quantidade                        AS "VlrDesconto",
              (m.custo * (vprod.quantidade))                                AS "VlrCMV",
              COALESCE(io.usuarioid, ven.usuarioid)                         AS "CodigoVendedor",
              ven.pessoaid                                                  AS "CodigoCliente",
              ( SELECT f.nome
                FROM pagamentovenda               p2
                         LEFT JOIN formapagamento f
                                   ON f.id = p2.formapagamentoid
                WHERE p2.vendaid = ven.id
                  AND p2.unidadenegocioid = ven.unidadenegocioid
                ORDER BY p2.valor DESC
                LIMIT 1 )                                                   AS "FormaPagamento",
              ( SELECT f.id
                FROM pagamentovenda               p2
                         LEFT JOIN formapagamento f
                                   ON f.id = p2.formapagamentoid
                WHERE p2.vendaid = ven.id
                  AND p2.unidadenegocioid = ven.unidadenegocioid
                LIMIT 1 )                                                   AS "CodigoFormaPagamento",
              ( SELECT ent2.nome
                FROM entregaremessa           er
                         LEFT JOIN remessa    r
                                   ON r.id = er.remessaid
                         LEFT JOIN entregador ent
                                   ON ent.id = r.entregadorid
                         LEFT JOIN pessoa     ent2
                                   ON ent2.id = ent.pessoaid
                WHERE er.entregaid = en.id
                LIMIT 1 )                                                   AS "NomeEntregador",
              ( SELECT ent2.id
                FROM entregaremessa           er
                         LEFT JOIN remessa    r
                                   ON r.id = er.remessaid
                         LEFT JOIN entregador ent
                                   ON ent.id = r.entregadorid
                         LEFT JOIN pessoa     ent2
                                   ON ent2.id = ent.pessoaid
                WHERE er.entregaid = en.id
                LIMIT 1 )                                                   AS "CodigoEntregador",
              vprod.pbmid                                                   AS "CodigoPBM",
              pbm.nome                                                      AS "NomePBM"
       FROM itemvenda                         vprod
                LEFT JOIN venda               ven
                          ON ven.id = vprod.vendaid
                LEFT JOIN movimentacaoestoque m
                          ON vprod.movimentacaoestoqueid = m.id
                              AND vprod.unidadenegocioid = m.unidadenegocioid
                LEFT JOIN itemorcamento       io
                          ON io.id = vprod.itemorcamentoid
                LEFT JOIN embalagem           e
                          ON e.id = vprod.embalagemid
                LEFT JOIN produto             p
                          ON p.id = e.produtoid
                LEFT JOIN orcamento           o
                          ON o.id = ven.orcamentoid
                              AND o.unidadenegocioid = ven.unidadenegocioid
                LEFT JOIN orcamentopbm        iopbm
                          ON iopbm.orcamentoid = o.id
                LEFT JOIN pbm
                          ON pbm.id = iopbm.pbmid
                LEFT JOIN entrega             en
                          ON en.orcamentoid = o.id
                LEFT JOIN formapagamento      f
                          ON f.id = o.formapagamentoid
       WHERE CAST(ven.datahorafechamento AS DATE) >= (CURRENT_DATE - INTERVAL '25 month')
         AND ven.unidadenegocioid IN (50000404035, 119053, 119052)
         AND vprod.unidadenegocioid IN (50000404035, 119053, 119052)
         AND m.unidadenegocioid IN (50000404035, 119053, 119052)
         AND vprod.status = ('F') ) vvniepomefl
