SELECT codigo AS "CodigoLoja",
       nome   AS "NomeLoja",
       cgc    AS "CNPJ",
       e.endereco,
       e.numero,
       e.bairro,
       e.cidade,
       e.uf,
       e.cep
FROM empresa e
