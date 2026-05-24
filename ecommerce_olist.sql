-- Criando as tabelas principais do e-commerce baseadas no Olist
CREATE TABLE clientes (
    id_cliente VARCHAR(50) PRIMARY KEY,
    cidade_cliente VARCHAR(100), -- aqui usei _cliente no nome
    estado_cliente CHAR(2)
);
CREATE TABLE pedidos (
    id_pedido VARCHAR(50) PRIMARY KEY,
    id_cliente VARCHAR(50),
    status_pedido VARCHAR(30),
    data_compra DATETIME,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
CREATE TABLE itens_pedido (
    id_pedido VARCHAR(50),
    id_item INT,
    id_produto VARCHAR(50),
    preco DECIMAL(10,2),
    frete DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_item),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);
create table produtos (
    id_produto VARCHAR(50) PRIMARY KEY,
    categoria VARCHAR(50) -- aqui esqueci de colocar _produto, ficou diferente de clientes
);

-- Inserindo dados de teste para ver se as queries funcionam
INSERT INTO clientes VALUES ('c1', 'Sao Paulo', 'SP');
INSERT INTO clientes VALUES ('c2', 'Rio de Janeiro', 'RJ');
INSERT INTO clientes VALUES ('c3', 'Belo Horizonte', 'MG');
INSERT INTO clientes VALUES ('c4', 'Curitiba', 'PR');
INSERT INTO clientes VALUES ('c5', 'Manaus', 'AM');
INSERT INTO clientes VALUES ('c6', 'sao paulo', 'SP'); -- esqueci de padronizar a caixa alta aqui
INSERT INTO clientes VALUES ('c7', 'São Paulo', 'SP'); -- esse ficou com acento, vai dar ruim no group by depois
INSERT INTO produtos VALUES ('p1', 'utilidades_domesticas');
INSERT INTO produtos VALUES ('p2', 'beleza_saude');
INSERT INTO produtos VALUES ('p3', 'eletronicos');
INSERT INTO produtos VALUES ('p4', 'brinquedos');
INSERT INTO pedidos VALUES ('pe1', 'c1', 'delivered', '2025-01-10 14:30:00');
INSERT INTO pedidos VALUES ('pe2', 'c2', 'delivered', '2025-01-15 09:15:00');
INSERT INTO pedidos VALUES ('pe3', 'c3', 'delivered', '2025-02-02 18:22:00');
-- erro na data desse aqui, ficou pro futuro mas deixei pra testar o filtro
INSERT INTO pedidos VALUES ('pe4', 'c4', 'delivered', '2027-06-20 11:00:00');
INSERT INTO pedidos VALUES ('pe5', 'c5', 'shipped', '2025-02-25 16:40:00');
INSERT INTO pedidos VALUES ('pe6', 'c6', 'canceled', '2025-03-01 10:00:00');
INSERT INTO pedidos VALUES ('pe7', 'c1', 'delivered', '2025-03-05 15:30:00');
INSERT INTO itens_pedido VALUES ('pe1', 1, 'p1', 59.90, 15.43);
INSERT INTO itens_pedido VALUES ('pe1', 2, 'p1', 59.90, 15.43);
INSERT INTO itens_pedido VALUES ('pe2', 1, 'p2', 120.00, 22.10);
INSERT INTO itens_pedido VALUES ('pe3', 1, 'p3', 850.00, 0.00); -- frete gratis?
INSERT INTO itens_pedido VALUES ('pe4', 1, 'p4', 45.00, 12.00);
INSERT INTO itens_pedido VALUES ('pe5', 1, 'p1', 59.90, 18.00);
INSERT INTO itens_pedido VALUES ('pe7', 1, 'p3', 890.00, 45.12);

-- 1. Qual o total de vendas e frete por mês? (só pedidos entregues)
select
    FORMAT(a.data_compra, 'yyyy-MM') as mes, -- corrigido: era strftime do SQLite, nao funciona no SQL Server
    count(a.id_pedido) as total_pedidos,
    sum(b.preco) as faturamento,
    SUM(b.frete) as total_frete
from pedidos a
join itens_pedido b on a.id_pedido = b.id_pedido
where a.status_pedido = 'delivered'
  and a.data_compra < '2026-01-01' -- tirando aquela data errada do seed
group by FORMAT(a.data_compra, 'yyyy-MM')
order by mes;

-- 2. Quais estados mais compram e qual a média de gasto deles?
SELECT
    c.estado_cliente,
    COUNT(distinct p.id_pedido) as qtd_pedidos,
    SUM(i.preco) as total_gasto,
    SUM(i.preco) / COUNT(distinct p.id_pedido) as ticket_medio
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN itens_pedido i ON p.id_pedido = i.id_pedido
WHERE p.status_pedido = 'delivered'
GROUP BY c.estado_cliente
ORDER BY total_gasto DESC;

-- 3. Quais as categorias de produtos que mais faturam?
WITH categoria_preco AS (
    -- juntando as duas tabelas pra pegar o nome da categoria
    SELECT prod.categoria, it.preco
    FROM itens_pedido it
    JOIN produtos prod ON it.id_produto = prod.id_produto
)
SELECT
    categoria,
    COUNT(*) as unidades_vendidas,
    SUM(preco) as total_faturado
FROM categoria_preco
GROUP BY categoria
ORDER BY total_faturado DESC;
