SELECT c.codigoempresa AS "CodigoLoja",
       c.nomefilial    AS "NomeLoja",
       ci.NomeCidade,
       ci.UF,
       v.CNPJ_da_Rede,
       c.Endereco,
       c.CNPJ,
       c.Numero,
       c.Bairro,
       c.Cep

FROM config                                     c
         LEFT JOIN view_gestao_na_veia_empresas v
                   ON v.Empresa = c.CodigoEmpresa
         LEFT JOIN Cadastro_Cidade              ci
                   ON ci.CodigoCidade = c.CodigoCidade
