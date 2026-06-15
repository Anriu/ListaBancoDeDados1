-- Banco 2

-- Tabela de tamanhos das pizzas
CREATE TABLE tamanhos(
    codigo SMALLINT NOT NULL,
    nome CHAR(10) NOT NULL,

    -- Chave primária
    CONSTRAINT pk_tamanhos
        PRIMARY KEY (codigo)
);

-- Tabela de pizzas
CREATE TABLE pizza(
    codigo INTEGER NOT NULL,
    nome CHAR(30) NOT NULL,

    -- Chave primária
    CONSTRAINT pk_pizza
        PRIMARY KEY (codigo)
);

-- Tabela de bairros
CREATE TABLE bairros(
    codigo INTEGER NOT NULL,
    nome CHAR(25) NOT NULL,
    populacao INTEGER,

    -- Chave primária
    CONSTRAINT pk_bairros
        PRIMARY KEY (codigo)
);

-- Tabela de clientes
CREATE TABLE clientes(
    fone VARCHAR(8) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    bairro INTEGER,
    endereco VARCHAR(60),
    sexo CHAR(1),
    nascimento DATE,

    -- Chave primária
    CONSTRAINT pk_clientes
        PRIMARY KEY (fone),

    -- Chave estrangeira para bairros
    CONSTRAINT fk_clientes_bairros
        FOREIGN KEY (bairro)
        REFERENCES bairros(codigo)
);

-- Tabela de pedidos
CREATE TABLE pedidos(
    numero INTEGER NOT NULL,
    cliente VARCHAR(8) NOT NULL,
    diahora TIMESTAMP,

    -- Chave primária
    CONSTRAINT pk_pedidos
        PRIMARY KEY (numero),

    -- Chave estrangeira para clientes
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (cliente)
        REFERENCES clientes(fone)
);

-- Tabela de itens dos pedidos
CREATE TABLE itens_pedidos(
    pizza INTEGER NOT NULL,
    tamanho SMALLINT NOT NULL,
    pedido INTEGER NOT NULL,
    quantidade SMALLINT NOT NULL,
    valorunitario DECIMAL(4,2),

    -- Chave primária composta
    CONSTRAINT pk_itens_pedidos
        PRIMARY KEY (pizza, tamanho, pedido),

    -- Chave estrangeira para pedidos
    CONSTRAINT fk_itens_pedidos_pedidos
        FOREIGN KEY (pedido)
        REFERENCES pedidos(numero),

    -- Chave estrangeira para tamanhos
    CONSTRAINT fk_itens_pedidos_tamanhos
        FOREIGN KEY (tamanho)
        REFERENCES tamanhos(codigo),

    -- Chave estrangeira para pizzas
    CONSTRAINT fk_itens_pedidos_pizza
        FOREIGN KEY (pizza)
        REFERENCES pizza(codigo)
);

-- Questão 26
SELECT codigo, nome
FROM pizza
ORDER BY nome ASC;

-- Questão 27
SELECT nome
FROM clientes
WHERE nome ILIKE '%w%';

-- Questão 28
DELETE FROM pizza 
WHERE nome ILIKE '%CALABRESA%' 
   OR nome ILIKE '%CALABREZA%';
   
-- Questão 29
SELECT numero, diahora 
FROM pedidos 
WHERE diahora BETWEEN '2026-01-01 00:00:00' AND '2026-12-31 23:59:59';

-- Questão 30
SELECT nome, populacao
FROM bairros
WHERE populacao < 50000;

-- Questão 31
SELECT nome, fone
FROM clientes
WHERE sexo = 'F' 
	AND EXTRACT(YEAR FROM nascimento) BETWEEN 1980 and 1989;	
	
-- Questão 32
SELECT COUNT(DISTINCT nome) AS total_tamanhos
FROM tamanhos;

-- Questão 33
SELECT * 
FROM itens_pedidos
WHERE quantidade = 1
	OR quantidade > 5;
	
-- Questão 34
SELECT c.nome AS cliente, b.nome AS bairro
FROM clientes c
JOIN bairros b ON c.bairro = b.codigo;

-- Questão 35
SELECT ip.pedido AS numero_pedido, p.nome AS nome_pizza, ip.quantidade
FROM itens_pedidos ip
JOIN pizza p ON ip.pizza = p.codigo;

-- Questão 36
SELECT 
    ip.pedido AS numero_pedido, 
    c.nome AS nome_cliente, 
    p.nome AS nome_pizza, 
    t.nome AS tamanho_pizza
FROM itens_pedidos ip
JOIN pizza p ON ip.pizza = p.codigo
JOIN tamanhos t ON ip.tamanho = t.codigo
JOIN pedidos ped ON ip.pedido = ped.numero
JOIN clientes c ON ped.cliente = c.fone;


-- Questão 37
SELECT pedido, SUM(quantidade * valorunitario) AS valor_total_pedido
FROM itens_pedidos
GROUP BY pedido;

-- Questão 38
SELECT b.nome AS bairro, COUNT(c.fone) AS total_clientes
FROM bairros b
LEFT JOIN clientes c ON b.codigo = c.bairro
GROUP BY b.nome;

-- Questão 39
SELECT p.nome AS pizza_nome
FROM pizza p
JOIN itens_pedidos ip ON p.codigo = ip.pizza
GROUP BY p.nome
HAVING SUM(ip.quantidade) > 50;

-- Questão 40
SELECT c.nome AS nome_cliente, p.diahora AS dia_hora
FROM pedidos p
JOIN clientes c ON p.cliente = c.fone
WHERE EXTRACT(DAY FROM p.diahora) = EXTRACT(DAY FROM c.nascimento)
	AND EXTRACT(MONTH FROM p.diahora) = EXTRACT(MONTH FROM c.nascimento);

-- Questão 41
SELECT p.nome AS nome_pizza, COUNT(ip.pizza) AS total_vezes_pedida
FROM pizza p
LEFT JOIN itens_pedidos ip ON p.codigo = ip.pizza
GROUP BY p.nome;

-- Questão 42
SELECT DISTINCT c.nome AS nome_cliente
FROM clientes c
JOIN bairros b ON c.bairro = b.codigo
JOIN pedidos p ON c.fone = p.cliente
WHERE b.nome ILIKE 'Centro'
	AND EXTRACT(DOW FROM p.diahora) = 0;

-- Questão 43
SELECT c.nome
FROM clientes c
JOIN pedidos p ON c.fone = p.cliente
JOIN itens_pedidos ip ON p.numero = ip.pedido
GROUP BY p.numero, c.nome
ORDER BY SUM(ip.quantidade * ip.valorunitario) DESC
LIMIT 1;

-- Questão 44
SELECT DISTINCT b.nome AS nome_bairro
FROM bairros b
JOIN clientes c ON b.codigo = c.bairro
JOIN pedidos p ON TRIM(c.fone) = TRIM(p.cliente)
JOIN itens_pedidos ip ON p.numero = ip.pedido
JOIN tamanhos t ON ip.tamanho = t.codigo
WHERE TRIM(t.nome) ILIKE 'Gigante'
   OR TRIM(t.nome) ILIKE 'Super';

-- Questão 45
SELECT c.nome AS nome_clientes
FROM bairros b
JOIN clientes c ON b.codigo = c.bairro
LEFT JOIN pedidos p ON TRIM(c.fone) = TRIM(p.cliente)
WHERE b.populacao > 200000
  AND p.numero IS NULL;


-- Questão 46
SELECT pedido, pizza
FROM itens_pedidos ip
WHERE valorunitario < (
    SELECT AVG(valorunitario)
    FROM itens_pedidos
    WHERE pizza = ip.pizza
);

-- Questão 47
SELECT b.nome
FROM bairros b
JOIN clientes c ON b.codigo = c.bairro
JOIN pedidos p ON TRIM(c.fone) = TRIM(p.cliente)
JOIN itens_pedidos ip ON p.numero = ip.pedido
GROUP BY b.codigo, b.nome
ORDER BY SUM(ip.quantidade * ip.valorunitario) DESC
LIMIT 1;

-- Questão 48
SELECT pi.nome
FROM pizza pi
JOIN itens_pedidos ip ON pi.codigo = ip.pizza
GROUP BY pi.codigo, pi.nome
HAVING MIN(ip.valorunitario) > (
    SELECT AVG(valorunitario) 
    FROM itens_pedidos
);

-- Questão 49
SELECT DISTINCT b.nome
FROM bairros b
JOIN clientes c ON b.codigo = c.bairro
JOIN pedidos p ON TRIM(c.fone) = TRIM(p.cliente)
WHERE c.sexo = 'M'
  AND CAST(EXTRACT(DAY FROM p.diahora) AS INTEGER) % 2 <> 0;
  
-- Questão 50
SELECT c.nome, SUM(ip.quantidade) AS quantidade_total
FROM clientes c
JOIN pedidos p ON TRIM(c.fone) = TRIM(p.cliente)
JOIN itens_pedidos ip ON p.numero = ip.pedido
GROUP BY c.fone, c.nome
ORDER BY quantidade_total DESC
LIMIT 3;



-- Inserções para teste

-- Bairros
INSERT INTO bairros (codigo, nome, populacao)
VALUES (1, 'Centro', 15000);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (2, 'Altos do Irecê', 4500);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (3, 'Paraíso', 8200);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (4, 'Morada do Sol', 6100);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (5, 'Novo Horizonte', 7400);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (6, 'São Francisco', 9300);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (7, 'Boa Vista', 5200);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (8, 'Vila Aurora', 3800);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (9, 'Vivendas', 2900);

INSERT INTO bairros (codigo, nome, populacao)
VALUES (10, 'Baixão de Sinésia', 4100);

-- Tamanho das pizzas
INSERT INTO tamanhos (codigo, nome)
VALUES (1, 'Pequena');

INSERT INTO tamanhos (codigo, nome)
VALUES (2, 'Media');

INSERT INTO tamanhos (codigo, nome)
VALUES (3, 'Grande');

INSERT INTO tamanhos (codigo, nome)
VALUES (4, 'Familia');

INSERT INTO tamanhos (codigo, nome)
VALUES (5, 'Meio-Metro');

INSERT INTO tamanhos (codigo, nome)
VALUES (6, 'Festa');

INSERT INTO tamanhos (codigo, nome)
VALUES (7, 'Gigante');

INSERT INTO tamanhos (codigo, nome)
VALUES (8, 'Super');

-- Clientes
INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210001', 'Carlos Silva', 1, 'Rua Direita, 45', 'M', '1985-04-12');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210002', 'Ana Souza', 2, 'Av. Principal, 102', 'F', '1990-08-22');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210003', 'Marcos Pontes', 1, 'Rua Sete, 12', 'M', '1978-11-30');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210004', 'Julia Lima', 3, 'Alameda Flores, 55', 'F', '1995-03-15');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210005', 'Roberto Costa', 5, 'Rua das Oliveiras, 90', 'M', '1982-06-18');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210006', 'Maria Oliveira', 4, 'Av. Central, 1200', 'F', '1965-09-05');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210007', 'Fernando Reis', 8, 'Travessa Norte, 8', 'M', '1988-01-25');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210008', 'Patricia Gomes', 3, 'Rua Augusta, 410', 'F', '1992-07-14');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210009', 'Ricardo Alves', 6, 'Rua Bahia, 33', 'M', '1974-12-01');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210010', 'Camila Rocha', 10, 'Av. do Sol, 500', 'F', '1999-05-20');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210011', 'Wanderson Rocha', 1, 'Rua Das Flores, 22', 'M', '1993-10-05');

INSERT INTO clientes (fone, nome, bairro, endereco, sexo, nascimento)
VALUES ('33210012', 'Matheus William', 3, 'Av. Santos Dumont, 88', 'M', '1987-02-14');

INSERT INTO clientes (fone, nome, endereco, sexo, nascimento, bairro)
VALUES ('99991111', 'Maria Santos', 'Rua Padrão, 0', 'F', '1990-05-15', 1);

-- Sabores Pizza
INSERT INTO pizza (codigo, nome)
VALUES (1, 'Calabresa');

INSERT INTO pizza (codigo, nome)
VALUES (2, 'Frango com Catupiry');

INSERT INTO pizza (codigo, nome)
VALUES (3, 'Marguerita');

INSERT INTO pizza (codigo, nome)
VALUES (4, 'Quatro Queijos');

INSERT INTO pizza (codigo, nome)
VALUES (5, 'Portuguesa');

INSERT INTO pizza (codigo, nome)
VALUES (6, 'Mussarela');

INSERT INTO pizza (codigo, nome)
VALUES (7, 'Chocolate com Morango');

INSERT INTO pizza (codigo, nome)
VALUES (8, 'Rucula com Tomate Seco');

INSERT INTO pizza (codigo, nome)
VALUES (9, 'Baiana');

INSERT INTO pizza (codigo, nome)
VALUES (10, 'Vegetariana');


-- Pedidos
INSERT INTO pedidos (numero, cliente, diahora)
VALUES (101, '33210001', '2026-06-15 19:00:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (102, '33210002', '2026-06-15 19:15:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (103, '33210004', '2026-06-15 19:30:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (104, '33210001', '2026-06-15 20:02:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (105, '33210005', '2026-06-15 20:10:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (106, '33210008', '2026-06-15 20:45:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (107, '33210003', '2026-06-15 21:00:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (108, '33210010', '2026-06-15 21:15:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (109, '33210007', '2026-06-15 21:40:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (110, '33210002', '2026-06-15 22:05:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (111, '33210001', '2026-06-15 22:10:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (112, '33210002', '2026-06-15 22:15:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (113, '33210003', '2026-06-15 22:20:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (201, '33210001', '2026-06-15 22:30:00');

INSERT INTO pedidos (numero, cliente, diahora)
VALUES (202, '33210002', '2026-06-15 22:45:00');


-- Itens pedidos
INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 4, 101, 2, 45.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (3, 4, 101, 1, 42.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (2, 3, 102, 1, 38.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (5, 5, 103, 1, 55.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (4, 4, 104, 1, 48.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (6, 4, 105, 2, 35.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (7, 1, 106, 1, 25.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 4, 107, 1, 45.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (10, 3, 108, 1, 40.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (8, 4, 109, 1, 52.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 3, 111, 20, 45.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 3, 112, 25, 45.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 3, 113, 10, 45.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (1, 7, 201, 1, 65.00);

INSERT INTO itens_pedidos (pizza, tamanho, pedido, quantidade, valorunitario)
VALUES (2, 8, 202, 1, 80.00);
