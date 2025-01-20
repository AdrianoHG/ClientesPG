SELECT cb.CODIGO    AS "CodigoProduto",
       cb.COD_BARRA AS "CodigoBarras"
FROM COD_BARRAS              cb
         INNER JOIN PRODUTOS p
                    ON p.CODIGO = cb.CODIGO
