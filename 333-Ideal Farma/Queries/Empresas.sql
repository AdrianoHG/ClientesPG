SELECT f.filial   AS "CodigoLoja",
       f.nomefant AS "NomeLoja",
       f.rsocial  AS "RazaoSocial",
       f.cgc      AS "Cnpj"
FROM filial f
WHERE f.ativa = 'X'
  AND f.nomefant IS NOT NULL
