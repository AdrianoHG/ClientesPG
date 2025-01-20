SELECT CodigoLoja,
       CodigoFuncionario,
       NomeFuncionario,
       CONCAT(CodigoFuncionario, ' - ',
              NomeFuncionario) AS CodigoNomeFuncionario,
       Telefone,
       Ativo
FROM (SELECT func.codigo AS "CodigoFuncionario",
             func.nome   AS "NomeFuncionario",
             f.filial    AS "CodigoLoja",
             1           AS "Ativo",
             NULL        AS "Telefone"
      FROM vendedor func
               LEFT JOIN filial f ON f.filial = func.filialemp
      WHERE f.ativa = 'X') ff
