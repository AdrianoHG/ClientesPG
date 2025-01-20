WITH Clientes AS ( SELECT p.id                                AS "CodigoCliente",
                          p.id                                AS "CodigoClienteVisual",
                          MAX(COALESCE(p.cpf, p.cnpj))        AS "CpfCnpj",
                          MAX(p.nome)                         AS "NomeCliente",
                          MAX(tel.contato)                    AS "Telefone",
                          MAX(cel.contato)                    AS "Celular",
                          MAX(CAST(p.datanascimento AS DATE)) AS "DataNascimento",
                          MAX(p.sexo)                         AS "Sexo",
                          MAX(p.estadocivil)                  AS "EstadoCivil",
                          MAX(l.cep)                          AS "Cep",
                          MAX(l.nome)                         AS "Endereco",
                          MAX(e.numero)                       AS "Numero",
                          MAX(b.nome)                         AS "Bairro",
                          MAX(cid.nome)                       AS "Cidade",
                          MAX(e2.nome)                        AS "Estado"
                   FROM pessoa                   p
                            LEFT JOIN cliente    cli
                                      ON p.id = cli.pessoaid
                            LEFT JOIN contato    tel
                                      ON tel.pessoaid = p.id AND tel.principal = TRUE
                            LEFT JOIN contato    cel
                                      ON cel.pessoaid = p.id AND cel.principal = FALSE
                            LEFT JOIN endereco   e
                                      ON e.pessoaid = p.id
                            LEFT JOIN logradouro l
                                      ON l.id = e.logradouroid
                            LEFT JOIN bairro     b
                                      ON b.id = l.bairroid
                            LEFT JOIN cidade     cid
                                      ON cid.id = b.cidadeid
                            LEFT JOIN estado     e2
                                      ON e2.id = cid.estadoid
                   GROUP BY p.id )
SELECT "CodigoCliente",
       "CodigoClienteVisual",
       CONCAT("CodigoClienteVisual", ' - ', "NomeCliente") AS "CodigoVisualNomeCliente",
       "CpfCnpj",
       "NomeCliente",
       "Telefone",
       "Celular",
       "DataNascimento",
       "Sexo",
       "EstadoCivil",
       "Cep",
       "Endereco",
       "Numero",
       "Bairro",
       "Cidade",
       "Estado"
FROM Clientes
