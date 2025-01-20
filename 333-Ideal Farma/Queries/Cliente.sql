SELECT CodigoCliente,
       CodigoClienteVisual,
       CodigoVisualNomeCliente,
       NomeCliente,
       Telefone,
       Celular,
       CpfCnpj,
       DataNascimento,
       Sexo,
       EstadoCivil,
       Cep,
       Endereco,
       Numero,
       Bairro,
       Cidade,
       Estado
FROM (SELECT CAST(c2.codigo AS UNSIGNED INTEGER)                              AS "CodigoCliente",
             CAST(c2.codigo AS UNSIGNED INTEGER)                              AS "CodigoClienteVisual",
             CONCAT(CAST(c2.codigo AS UNSIGNED INTEGER), ' - ', MAX(c2.nome)) AS "CodigoVisualNomeCliente",
             MAX(c2.nome)                                                     AS "NomeCliente",
             MAX(c2.tel)                                                      AS "Telefone",
             MAX(c2.telcontato)                                               AS "Celular",
             MAX(c2.cpf)                                                      AS "CpfCnpj",
             MAX(c2.dtnasc)                                                   AS "DataNascimento",
             MAX(c2.sexo)                                                     AS "Sexo",
             NULL                                                             AS "EstadoCivil",
             MAX(c2.cep)                                                      AS "Cep",
             MAX(c2.endereco)                                                 AS "Endereco",
             NULL                                                             AS "Numero",
             MAX(c2.bairro)                                                   AS "Bairro",
             MAX(c2.cidade)                                                   AS "Cidade",
             MAX(c2.estado)                                                   AS "Estado"
      FROM clientes c2
      WHERE c2.codigo IS NOT NULL
        AND c2.nome IS NOT NULL
      GROUP BY c2.codigo) cf
GROUP BY CodigoCliente;
