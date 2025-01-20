WITH Clientes AS ( SELECT cli.CodigoCliente       AS "CodigoCliente",
                          cli.CodigoCliente       AS "CodigoClienteVisual",
                          MAX(cad.nome)           AS "NomeCliente",
                          MAX(cad.CPFCNPJ)        AS "CpfCnpj",
                          MAX(CASE
                                  WHEN con_tipo.NomeTipo IN ('Telefone')
                                      THEN con.Identificacao
                                      ELSE NULL
                              END) AS "Telefone",
                          MAX(CASE
                                  WHEN con_tipo.NomeTipo IN ('Celular')
                                      THEN con.Identificacao
                                      ELSE NULL
                              END) AS "Celular",
                          MAX(cad.DataNascimento) AS "DataNascimento",
                          MAX(cad.Sexo)           AS "Sexo",
                          NULL                    AS "EstadoCivil",
                          MAX(ende.Cep)           AS "Cep",
                          MAX(ende.Endereco)      AS "Endereco",
                          MAX(ende.Numero)        AS "Numero",
                          MAX(ende.Bairro)        AS "Bairro",
                          MAX(cid.NomeCidade)     AS "Cidade",
                          MAX(uf.NomeUF)          AS "Estado"
                   FROM cadastro                            cad
                            LEFT JOIN cliente               cli
                                      ON cad.codigocadastro = cli.codigocadastro
                            LEFT JOIN cadastro_contato      con
                                      ON con.codigocadastro = cad.codigocadastro
                            LEFT JOIN cadastro_contato_tipo con_tipo
                                      ON con.codigotipo = con_tipo.codigotipo
                            LEFT JOIN Cadastro_Endereco     ende
                                      ON ende.CodigoCadastro = cad.CodigoCadastro
                            LEFT JOIN Cadastro_Cidade       cid
                                      ON cid.CodigoCidade = ende.CodigoCidade
                            LEFT JOIN cadastro_cidade_uf    uf
                                      ON uf.UF = cid.UF
                   GROUP BY cli.CodigoCliente )
SELECT CodigoCliente,
       CodigoClienteVisual,
       CAST(CodigoClienteVisual AS VARCHAR(25)) + ' - ' + NomeCliente AS "CodigoVisualNomeCliente",
       CpfCnpj,
       NomeCliente,
       Telefone,
       Celular,
       DataNascimento,
       Sexo,
       EstadoCivil,
       Cep,
       Endereco,
       Numero,
       Bairro,
       Cidade,
       Estado
FROM Clientes
