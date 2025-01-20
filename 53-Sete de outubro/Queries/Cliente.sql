SELECT "CodigoCliente",
       "CodigoClienteVisual",
       "CodigoVisualNomeCliente",
       "NomeCliente",
       "CpfCnpj",
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
FROM ( SELECT CLI.CODIGO                                                            AS "CodigoCliente",
              cli.codigo                                                            AS "CodigoClienteVisual",
              CAST(cli.codigo AS INT) || CAST(' - ' AS VARCHAR(5)) || MAX(CLI.NOME) AS "CodigoVisualNomeCliente",
              MAX(CLI.cpf)       AS "CpfCnpj",
              MAX(CLI.NOME)                                                         AS "NomeCliente",
              MAX(CLI.TELEFONE)  AS "Telefone",
              MAX(CLI.CELULAR)   AS "Celular",
              MAX(CLI.DATA_NASC) AS "DataNascimento",
              MAX(CLI.SEXO)      AS "Sexo",
              NULL               AS "EstadoCivil",
              MAX(CLI.CEP)       AS "Cep",
              MAX(CLI.ENDERECO)  AS "Endereco",
              MAX(CLI.NUM_END)   AS "Numero",
              MAX(CLI.BAIRRO)    AS "Bairro",
              MAX(CLI.CIDADE)    AS "Cidade",
              MAX(CASE
                      WHEN CLI.UF = 'AC'
                          THEN 'ACRE'
                      WHEN CLI.UF = 'AL'
                          THEN 'ALAGOAS'
                      WHEN CLI.UF = 'AM'
                          THEN 'AMAZONAS'
                      WHEN CLI.UF = 'AP'
                          THEN 'AMAPA'
                      WHEN CLI.UF = 'BA'
                          THEN 'BAHIA'
                      WHEN CLI.UF = 'CE'
                          THEN 'CEARA'
                      WHEN CLI.UF = 'DF'
                          THEN 'DISTRITO FEDERAL'
                      WHEN CLI.UF = 'ES'
                          THEN 'ESPIRITO SANTO'
                      WHEN CLI.UF = 'GO'
                          THEN 'GOIAS'
                      WHEN CLI.UF = 'MA'
                          THEN 'MARANHAO'
                      WHEN CLI.UF = 'MG'
                          THEN 'MINAS GERAIS'
                      WHEN CLI.UF = 'MS'
                          THEN 'MATO GROSSO DO SUL'
                      WHEN CLI.UF = 'MT'
                          THEN 'MATO GROSSO'
                      WHEN CLI.UF = 'PA'
                          THEN 'PARA'
                      WHEN CLI.UF = 'PB'
                          THEN 'PARAIBA'
                      WHEN CLI.UF = 'PE'
                          THEN 'PERNAMBUCO'
                      WHEN CLI.UF = 'PI'
                          THEN 'PIAUI'
                      WHEN CLI.UF = 'PR'
                          THEN 'PARANA'
                      WHEN CLI.UF = 'RJ'
                          THEN 'RIO DE JANEIRO'
                      WHEN CLI.UF = 'RN'
                          THEN 'RIO GRANDE DO NORTE'
                      WHEN CLI.UF = 'RO'
                          THEN 'RONDONIA'
                      WHEN CLI.UF = 'RR'
                          THEN 'RORAIMA'
                      WHEN CLI.UF = 'RS'
                          THEN 'RIO GRANDE DO SUL'
                      WHEN CLI.UF = 'SC'
                          THEN 'SANTA CATARINA'
                      WHEN CLI.UF = 'SE'
                          THEN 'SERGIPE'
                      WHEN CLI.UF = 'SP'
                          THEN 'SAO PAULO'
                      WHEN CLI.UF = 'TO'
                          THEN 'TOCANTINS'
                  END
              )                  AS "Estado"
       FROM CLIENTES CLI
       WHERE CLI.STATUS = 'ATIVO'
       GROUP BY CLI.CODIGO ) C
