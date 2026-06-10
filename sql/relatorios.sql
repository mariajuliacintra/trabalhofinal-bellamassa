--Relatórios
-- ------------------------------------------------------------
-- 1. Clientes que possuem conta fidelidade com saldo positivo
-- ------------------------------------------------------------
SELECT c.id_cliente,
       c.nome_completo,
       t.telefone,
       cf.saldo
FROM   bellamassa.cliente c
JOIN   bellamassa.conta_fidelidade cf ON cf.fk_id_cliente = c.id_cliente
LEFT JOIN bellamassa.telefone t       ON t.fk_id_cliente  = c.id_cliente
WHERE  cf.saldo > 0
ORDER  BY cf.saldo DESC;


-- ------------------------------------------------------------
-- 2. Pedidos realizados em maio de 2026, com nome do cliente
-- ------------------------------------------------------------
SELECT p.id_pedido,
       c.nome_completo  AS cliente,
       p.data_hora,
       p.valor_total
FROM   bellamassa.pedido p
JOIN   bellamassa.cliente c ON c.id_cliente = p.fk_id_cliente
WHERE  p.data_hora BETWEEN '2026-05-01' AND '2026-05-31 23:59:59'
ORDER  BY p.data_hora ASC;


-- ------------------------------------------------------------
-- 3. Itens de pedido cujo preço unitário é maior que R$ 40,00
-- ------------------------------------------------------------
SELECT c.nome_completo        AS cliente,
       p.id_pedido,
       pr.nome_produto,
       pp.quantidade,
       pp.preco_unitario,
       (pp.quantidade * pp.preco_unitario) AS subtotal
FROM   bellamassa.pedido_produto pp
JOIN   bellamassa.produto pr ON pr.id_produto  = pp.id_produto
JOIN   bellamassa.pedido  p  ON p.id_pedido    = pp.id_pedido
JOIN   bellamassa.cliente c  ON c.id_cliente   = p.fk_id_cliente
WHERE  pp.preco_unitario > 40.00
ORDER  BY subtotal DESC;


-- ------------------------------------------------------------
-- 4. Pedidos que ainda NÃO foram atribuídos a um motoboy
-- ------------------------------------------------------------
SELECT p.id_pedido,
       c.nome_completo AS cliente,
       t.telefone,
       p.data_hora,
       p.valor_total
FROM   bellamassa.pedido p
JOIN   bellamassa.cliente c  ON c.id_cliente    = p.fk_id_cliente
LEFT JOIN bellamassa.telefone t ON t.fk_id_cliente = c.id_cliente
WHERE  p.cpf_motoboy IS NULL
ORDER  BY p.data_hora ASC;

-- ------------------------------------------------------------
-- 5. Histórico de entregas por motoboy (apenas pedidos entregues)
-- ------------------------------------------------------------
SELECT m.nome_motoboy,
       m.cpf,
       COUNT(p.id_pedido)      AS total_entregas,
       SUM(p.valor_total)      AS faturamento_total
FROM   bellamassa.pedido p
JOIN   bellamassa.motoboy m ON m.cpf = p.cpf_motoboy
JOIN   bellamassa.cliente c ON c.id_cliente = p.fk_id_cliente
WHERE  p.cpf_motoboy IS NOT NULL
GROUP  BY m.nome_motoboy, m.cpf
ORDER  BY total_entregas DESC;


-- ------------------------------------------------------------
-- 6. Endereços de entrega dos clientes que já fizeram pedidos
-- ------------------------------------------------------------
SELECT DISTINCT
       c.nome_completo AS cliente,
       e.rua,
       e.numero,
       e.bairro,
       e.cep
FROM   bellamassa.cliente c
JOIN   bellamassa.endereco e ON e.fk_id_cliente = c.id_cliente
JOIN   bellamassa.pedido   p ON p.fk_id_cliente = c.id_cliente
WHERE  e.bairro IS NOT NULL
ORDER  BY c.nome_completo, e.bairro;


-- ------------------------------------------------------------
-- 7. Produtos do tipo 'Pizza' presentes em algum pedido
-- ------------------------------------------------------------
SELECT pr.id_produto,
       pr.nome_produto,
       pr.preco_base,
       SUM(pp.quantidade) AS total_pedido
FROM   bellamassa.produto pr
JOIN   bellamassa.pedido_produto pp ON pp.id_produto = pr.id_produto
WHERE  pr.tipo = 'Pizza'
GROUP  BY pr.id_produto, pr.nome_produto, pr.preco_base
ORDER  BY total_pedido DESC, pr.preco_base DESC;


-- ------------------------------------------------------------
-- 8. Clientes VIP com pedidos acima de R$ 80,00
-- ------------------------------------------------------------
SELECT c.nome_completo AS cliente,
       cf.saldo        AS pontos_fidelidade,
       p.id_pedido,
       p.data_hora,
       p.valor_total
FROM   bellamassa.cliente c
JOIN   bellamassa.conta_fidelidade cf ON cf.fk_id_cliente = c.id_cliente
JOIN   bellamassa.pedido           p  ON p.fk_id_cliente  = c.id_cliente
WHERE  p.valor_total > 80.00
ORDER  BY p.valor_total DESC, cf.saldo DESC;


-- ------------------------------------------------------------
-- 9. Nota fiscal resumida de cada pedido
-- ------------------------------------------------------------
SELECT p.id_pedido,
       p.data_hora,
       c.nome_completo                                         AS cliente,
       e.rua || ', ' || e.numero || ' – ' || e.bairro         AS endereco_entrega,
       pr.nome_produto,
       pp.quantidade,
       pp.preco_unitario,
       (pp.quantidade * pp.preco_unitario)                     AS subtotal,
       COALESCE(m.nome_motoboy, 'Aguardando motoboy')          AS motoboy
FROM   bellamassa.pedido p
JOIN   bellamassa.cliente         c   ON c.id_cliente    = p.fk_id_cliente
LEFT   JOIN bellamassa.endereco   e   ON e.fk_id_cliente = c.id_cliente
JOIN   bellamassa.pedido_produto  pp  ON pp.id_pedido    = p.id_pedido
JOIN   bellamassa.produto         pr  ON pr.id_produto   = pp.id_produto
LEFT   JOIN bellamassa.motoboy    m   ON m.cpf            = p.cpf_motoboy
WHERE  p.id_pedido IS NOT NULL
ORDER  BY p.id_pedido ASC, subtotal DESC;


-- ------------------------------------------------------------
-- 10. Ranking de clientes por valor total gasto
-- ------------------------------------------------------------
SELECT c.id_cliente,
       c.nome_completo              AS cliente,
       COUNT(p.id_pedido)           AS qtd_pedidos,
       SUM(p.valor_total)           AS total_gasto,
       AVG(p.valor_total)           AS ticket_medio
FROM   bellamassa.cliente c
JOIN   bellamassa.pedido  p ON p.fk_id_cliente = c.id_cliente
WHERE  p.valor_total IS NOT NULL
GROUP  BY c.id_cliente, c.nome_completo
ORDER  BY total_gasto DESC;