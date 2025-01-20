SELECT RTRIM(LTRIM(UPPER(COALESCE(cad.Nome, cad.NomeFantasia)))) AS "RazaoSocial",
       MAX(cad.NomeFantasia)                                     AS "NomeFantasia",
       MAX(cad.CPFCNPJ)                                          AS "Cnpj",
       MAX(cad.CodigoCadastro)                                   AS "CodigoFornecedor"
FROM compra                 cp
         LEFT JOIN cadastro cad
                   ON cad.codigocadastro = cp.codigocadastro
GROUP BY RTRIM(LTRIM(UPPER(COALESCE(cad.Nome, cad.NomeFantasia))))
UNION ALL
SELECT RTRIM(LTRIM(UPPER(f.NomeFilial))) AS "RazaoSocial",
       MAX(f.NomeFilial)                 AS "NomeFantasia",
       MAX(f.CNPJ)                       AS "Cnpj",
       MAX(f.CodigoEmpresa)              AS "CodigoFornecedor"
FROM config f
GROUP BY RTRIM(LTRIM(UPPER(f.NomeFilial)))
