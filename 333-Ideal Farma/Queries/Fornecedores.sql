SELECT TRIM(UPPER(COALESCE(forn.fornom, forn.forfan))) AS "RazaoSocial",
       MAX(forn.forfan)                                AS "NomeFantasia",
       MAX(forn.forcgc)                                AS "Cnpj",
       MAX(forn.forcod)                                AS "CodigoFornecedor"
FROM forarq forn
GROUP BY TRIM(UPPER(COALESCE(forn.fornom, forn.forfan)))
UNION ALL
SELECT TRIM(UPPER(COALESCE(f.rsocial, f.nomefant))) AS "RazaoSocial",
       MAX(f.nomefant)                              AS "NomeFantasia",
       MAX(f.cgc)                                   AS "Cnpj",
       MAX(f.codigo)                                AS "CodigoFornecedor"
FROM filial f
WHERE f.ativa = 'X'
GROUP BY TRIM(UPPER(COALESCE(f.rsocial, f.nomefant)))
