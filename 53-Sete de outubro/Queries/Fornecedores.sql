SELECT "RazaoSocial",
       MAX("NomeFantasia")     AS "NomeFantasia",
       MAX("Cnpj")             AS "Cnpj",
       MAX("CodigoFornecedor") AS "CodigoFornecedor"
FROM ( SELECT TRIM(UPPER(COALESCE(forn.NOME, forn.NOME_FANTASIA))) AS "RazaoSocial",
              MAX(forn.NOME_FANTASIA)                              AS "NomeFantasia",
              MAX(forn.CGC)                                        AS "Cnpj",
              MAX(forn.CODIGO)                                     AS "CodigoFornecedor"
       FROM FORNECE forn
       GROUP BY TRIM(UPPER(COALESCE(forn.NOME, forn.NOME_FANTASIA)))
       UNION ALL
       SELECT TRIM(UPPER(COALESCE(f.NOME, f.FANTASIA))) AS "RazaoSocial",
              MAX(f.FANTASIA)                           AS "NomeFantasia",
              MAX(f.CGC)                                AS "Cnpj",
              MAX(f.CODIGO)                             AS "CodigoFornecedor"
       FROM empresa f
       GROUP BY TRIM(UPPER(COALESCE(f.NOME, f.FANTASIA))) ) ff
GROUP BY "RazaoSocial"
