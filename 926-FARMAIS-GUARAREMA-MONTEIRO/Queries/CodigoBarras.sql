SELECT p.codigo        AS "CodigoProduto",
       e2.codigobarras AS "CodigoBarras"
FROM embalagem              e2
         INNER JOIN produto p
                    ON p.id = e2.produtoid
