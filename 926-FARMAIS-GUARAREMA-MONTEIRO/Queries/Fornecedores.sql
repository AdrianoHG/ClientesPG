SELECT DISTINCT ON ("RazaoSocial") "RazaoSocial",
                                   "NomeFantasia",
                                   "Cnpj",
                                   "CodigoFornecedor"
FROM ( SELECT TRIM(UPPER(COALESCE(p.razaosocial, p.nome))) AS "RazaoSocial",
              MAX(p.nome)                                  AS "NomeFantasia",
              MAX(p.cnpj)                                  AS "Cnpj",
              MAX(p.id)                                    AS "CodigoFornecedor"
       FROM fornecedor      forn
                JOIN pessoa p
                     ON p.id = forn.pessoaid
       GROUP BY TRIM(UPPER(COALESCE(p.razaosocial, p.nome)))
       UNION ALL
       SELECT TRIM(UPPER(COALESCE(f.razaosocial, f.nome))) AS "RazaoSocial",
              MAX(f.nome)                                  AS "NomeFantasia",
              MAX(f.cnpj)                                  AS "Cnpj",
              MAX(f.id)                                    AS "CodigoFornecedor"
       FROM unidadenegocio f
       GROUP BY TRIM(UPPER(COALESCE(f.razaosocial, f.nome))) ) fpf
