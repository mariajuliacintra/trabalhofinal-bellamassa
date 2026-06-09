-- CRUD
-- CREATE
INSERT INTO bellamassa.cliente (id_cliente, nome_completo, telefone)
VALUES (51, 'Luigi Rossi',    '(16) 991000001'),
       (52, 'Maria Oliveira', '(16) 991000002'),
       (53, 'João Pereira',   '(16) 991000003');
 
-- SELECT – todos os clientes
SELECT id_cliente, nome_completo, telefone
FROM bellamassa.cliente
ORDER BY nome_completo;
 
-- SELECT – busca por nome (parcial)
SELECT id_cliente, nome_completo, telefone
FROM bellamassa.cliente
WHERE nome_completo ILIKE '%luigi%';
 
-- UPDATE – atualizar telefone
UPDATE bellamassa.cliente
SET    telefone = '(16) 988009999'
WHERE  id_cliente = 51;

-- DELETE
DELETE FROM bellamassa.cliente
WHERE id_cliente = 51;