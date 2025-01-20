SELECT f.id     AS "CodigoLoja",
       f.nome   AS "NomeLoja",
       f.codigo AS "NumeroUnidade",
       f.cnpj,
       f.cidade,
       f.estado,
       f.endereco,
       f.numero,
       f.cep,
       f.bairro
FROM unidadenegocio f
WHERE f.id IN (50000404035, 119053, 119052)
