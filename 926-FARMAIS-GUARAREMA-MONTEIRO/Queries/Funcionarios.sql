SELECT "CodigoLoja",
       "CodigoFuncionario",
       "NomeFuncionario",
       CONCAT("CodigoFuncionario", ' - ', "NomeFuncionario") AS "CodigoNomeFuncionario",
       "Telefone",
       "Ativo"
FROM ( SELECT func.id               AS "CodigoFuncionario",
              func.apelido          AS "NomeFuncionario",
              func.unidadenegocioid AS "CodigoLoja",
              NULL                  AS "Telefone",
              func.status           AS "Ativo"
       FROM usuario func ) f
