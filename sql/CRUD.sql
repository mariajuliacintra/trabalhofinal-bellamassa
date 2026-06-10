-- CRUD
-- CREATE
INSERT INTO bellamassa.cliente (id_cliente, nome_completo)
VALUES (51, 'Luigi Rossi'),
       (52, 'Maria Oliveira'),
       (53, 'João Pereira');
 
-- SELECT – todos os clientes
SELECT id_cliente, nome_completo
FROM bellamassa.cliente
ORDER BY nome_completo;
 
-- SELECT – busca por nome (parcial)
SELECT
    c.id_cliente,
    c.nome_completo,
    t.telefone
FROM bellamassa.cliente c
LEFT JOIN bellamassa.telefone t ON t.fk_id_cliente = c.id_cliente
WHERE c.nome_completo ILIKE '%luigi%'
ORDER BY c.nome_completo;
 
-- UPDATE – atualizar telefone
UPDATE bellamassa.telefone
SET    telefone = '(16) 988009999'
WHERE  fk_id_cliente = 51;

-- Acumula 5 % do valor total do pedido como pontos de fidelidade
UPDATE bellamassa.conta_fidelidade
SET    saldo = saldo + (
           SELECT valor_total * 0.05
           FROM   bellamassa.pedido
           WHERE  id_pedido = 1
       )
WHERE  fk_id_cliente = (
           SELECT fk_id_cliente
           FROM   bellamassa.pedido
           WHERE  id_pedido = 1
       );


-- DELETE
DELETE FROM bellamassa.cliente
WHERE id_cliente = 51;