-- Banco 1

--Tabala de Empresa

CREATE TABLE empresas(
    codigo INTEGER NOT NULL,
    nome VARCHAR(30) NOT NULL,
    endereco VARCHAR(40) NOT NULL,
    fone VARCHAR(14) NOT NULL,

    -- Chave primária
    CONSTRAINT pk_empresas
    PRIMARY KEY (codigo)
);

--Tabela de Pilotos
CREATE TABLE pilotos(
    breve INTEGER NOT NULL,
    nome CHAR(30) NOT NULL,
    sexo CHAR(1) NOT NULL,
    nascimento DATE NOT NULL,
    fone CHAR(14) NOT NULL,

    --Chave primária
    CONSTRAINT pk_pilotos
    PRIMARY KEY(breve)
);

CREATE TABLE cidades(
    codigo INTEGER NOT NULL,
    nome CHAR(15) NOT NULL,
    populacao DOUBLE PRECISION NOT NULL,

    --Chave primária
    CONSTRAINT pk_cidades
    PRIMARY KEY(codigo)
);

--Tabela de aviões
CREATE TABLE avioes(
    codigo INTEGER NOT NULL,
    modelo CHAR(20) NOT NULL,
    capacidade SMALLINT NOT NULL,

    --Para chaves estrangeiras
    empresas INTEGER NOT NULL,

    -- Chave primária
    CONSTRAINT pk_avioes
    PRIMARY KEY (codigo),

    -- Chave estrangeira para empresas
    CONSTRAINT fk_avioes_empresas
    FOREIGN KEY (empresas)
    REFERENCES empresas(codigo)
);

--Tabela de voos
CREATE TABLE voos(
    codigo INTEGER NOT NULL,
    saida TIMESTAMPTZ NOT NULL,
    chegada TIMESTAMPTZ NOT NULL,

    --Para chaves estrangeiras
    destino INTEGER NOT NULL,
    origem INTEGER NOT NULL,
    avioes INTEGER NOT NULL,
    pilotos INTEGER NOT NULL,

    -- Chave primária
    CONSTRAINT pk_voos
        PRIMARY KEY (codigo),

    -- Chave estrangeira para origem usando a chave da tabela cidades
    CONSTRAINT fk1_voos_origem
        FOREIGN KEY (origem)
        REFERENCES cidades(codigo),

    -- Chave estrangeira para destino usando a chave da tabela cidades
    CONSTRAINT fk2_voos_destino
        FOREIGN KEY (destino)
        REFERENCES cidades(codigo),

    -- Chave estrangeira para avioes
    CONSTRAINT fk3_voos_aviao
        FOREIGN KEY (avioes)
        REFERENCES avioes(codigo),

    -- Chave estrangeira para pilotos
    CONSTRAINT fk4_voos_piloto
        FOREIGN KEY (pilotos)
        REFERENCES pilotos(breve)
);


-- Questão 01
SELECT * FROM empresas;

-- Questão 02
SELECT modelo 
FROM avioes 
WHERE modelo ILIKE 'Boeing%';

-- Questão 03
SELECT nome, fone 
FROM empresas 
WHERE fone IS NOT NULL;

-- Questão 04
SELECT codigo, modelo 
FROM avioes 
WHERE capacidade BETWEEN 150 AND 250;

-- Questão 05
SELECT nome, nascimento 
FROM pilotos 
WHERE sexo = 'M' 
  AND nascimento > '1990-12-31';

-- Questão 06
SELECT nome 
FROM pilotos 
WHERE nome ILIKE '%a_';

-- Questão 07
SELECT nome, populacao 
FROM cidades 
ORDER BY populacao DESC;

-- Questão 08
SELECT COUNT(*) 
FROM avioes 
WHERE capacidade > 300;

-- Questão 09
SELECT a.modelo, e.nome 
FROM avioes a 
JOIN empresas e ON a.empresas = e.codigo;

-- Questão 10
SELECT p.nome, v.saida 
FROM pilotos p 
JOIN voos v ON p.breve = v.pilotos;

-- Questão 11
SELECT 
    v.codigo,
    c1.nome AS origem,
    c2.nome AS destino 
FROM voos v 
JOIN cidades c1 ON v.origem = c1.codigo 
JOIN cidades c2 ON v.destino = c2.codigo;

-- Questão 12
SELECT e.nome, COUNT(*) 
FROM empresas e 
JOIN avioes a ON a.empresas = e.codigo 
GROUP BY e.nome;

-- Questão 13
SELECT modelo, ROUND(AVG(capacidade), 2) AS capacidade_media 
FROM avioes 
WHERE capacidade > 100 
GROUP BY modelo;

-- Questão 14
SELECT c.nome AS cidade, COUNT(*) AS quantidade_voos 
FROM voos v 
JOIN cidades c ON v.origem = c.codigo 
GROUP BY c.nome;

-- Questão 15
SELECT p.nome 
FROM pilotos p 
JOIN voos v ON p.breve = v.pilotos 
WHERE EXTRACT(MONTH FROM v.saida) IN (6, 7, 12);

-- Questão 16
SELECT c.nome, COUNT(*) AS quantidade_voos 
FROM cidades c 
JOIN voos v ON c.codigo = v.origem 
GROUP BY c.nome;

-- Questão 17
SELECT DISTINCT p.nome 
FROM pilotos p 
JOIN voos v ON p.breve = v.pilotos 
JOIN avioes a ON v.avioes = a.codigo 
JOIN empresas e ON a.empresas = e.codigo 
WHERE e.nome = 'LATAM';

-- Questão 18
SELECT nome 
FROM pilotos 
WHERE nascimento = (
    SELECT MIN(nascimento) 
    FROM pilotos
);

-- Questão 19
SELECT e.nome
FROM empresas e
JOIN avioes a ON e.codigo = a.empresas
GROUP BY e.codigo, e.nome
HAVING COUNT(*) > (
    SELECT AVG(qtd)
    FROM (
        SELECT COUNT(*) AS qtd
        FROM avioes
        GROUP BY empresas
    ) AS medias
);

-- Questão 20
SELECT c.nome
FROM cidades c
JOIN voos v ON c.codigo = v.destino
JOIN pilotos p ON p.breve = v.pilotos
GROUP BY c.codigo, c.nome
HAVING COUNT(CASE WHEN p.sexo = 'M' THEN 1 END) = 0;

-- Questão 21
SELECT a.modelo, a.capacidade
FROM avioes a
WHERE a.capacidade > (
    SELECT AVG(a2.capacidade)
    FROM avioes a2
    WHERE a2.empresas = a.empresas
);

-- Questão 22
SELECT p.nome
FROM pilotos p
WHERE NOT EXISTS (
    SELECT 1 
    FROM voos v 
    WHERE v.pilotos = p.breve
);

-- Questão 23
SELECT c.nome
FROM cidades c
WHERE NOT EXISTS (
    SELECT 1 
    FROM voos v 
    WHERE v.destino = c.codigo
)
ORDER BY c.populacao DESC
LIMIT 1;

-- Questão 24
SELECT v.codigo, p.nome AS piloto
FROM voos v
JOIN pilotos p ON v.pilotos = p.breve
WHERE (v.chegada - v.saida) > (
    SELECT AVG(chegada - saida) 
    FROM voos
);

-- Questão 25
SELECT p.nome
FROM pilotos p
JOIN voos v ON p.breve = v.pilotos
GROUP BY p.breve, p.nome
ORDER BY SUM(v.chegada - v.saida) DESC
LIMIT 1;




-- Inserções para teste:
-- Empresas
INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (1, 'Azul', 'Av. Central 100', '74999990001');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (2, 'Gol', 'Rua Bahia 200', '74999990002');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (3, 'LATAM', 'Av. Brasil 300', '74999990003');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (4, 'Avianca', 'Rua Sul 400', '74999990004');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (5, 'Passaredo', 'Rua Norte 500', '74999990005');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (6, 'Voepass', 'Av. Leste 600', '74999990006');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (7, 'Air Europa', 'Rua Oeste 700', '74999990007');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (8, 'TAP', 'Av. Portugal 800', '74999990008');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (9, 'American Air', 'Rua EUA 900', '74999990009');

INSERT INTO empresas (codigo, nome, endereco, fone) 
VALUES (10, 'Air France', 'Av. Paris 1000', '74999990100');

-- Pilotos
INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1001, 'Carlos Silva', 'M', '1980-03-12', '74911110001');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1002, 'Ana Souza', 'F', '1985-07-20', '74911110002');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1003, 'Joao Santos', 'M', '1978-09-15', '74911110003');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1004, 'Mariana Lima', 'F', '1990-01-10', '74911110004');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1005, 'Pedro Rocha', 'M', '1982-05-18', '74911110005');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1006, 'Julia Alves', 'F', '1991-08-30', '74911110006');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1007, 'Lucas Costa', 'M', '1987-11-22', '74911110007');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1008, 'Fernanda Reis', 'F', '1984-06-14', '74911110008');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1009, 'Rafael Gomes', 'M', '1979-04-09', '74911110009');

INSERT INTO pilotos (breve, nome, sexo, nascimento, fone) 
VALUES (1010, 'Patricia Melo', 'F', '1988-12-25', '74911110010');

-- Aviões
INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (1, 'Boeing 737', 180, 1);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (2, 'Boeing 747', 416, 2);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (3, 'Airbus A320', 150, 3);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (4, 'Airbus A330', 300, 4);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (5, 'Boeing 777', 396, 5);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (6, 'Embraer E190', 114, 6);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (7, 'ATR 72', 70, 7);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (8, 'Boeing 787', 242, 8);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (9, 'Airbus A350', 350, 9);

INSERT INTO avioes (codigo, modelo, capacity, empresas) 
VALUES (10, 'Boeing 767', 269, 10);

-- Voos
INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (1, '2026-06-01 08:00:00-03', '2026-06-01 10:00:00-03', 2, 1, 1, 1001);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (2, '2026-06-02 09:00:00-03', '2026-06-02 11:15:00-03', 3, 2, 2, 1002);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (3, '2026-06-03 07:30:00-03', '2026-06-03 09:45:00-03', 4, 3, 3, 1003);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (4, '2026-06-04 13:00:00-03', '2026-06-04 15:20:00-03', 5, 4, 4, 1004);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (5, '2026-06-05 14:10:00-03', '2026-06-05 16:30:00-03', 6, 5, 5, 1005);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (6, '2026-06-06 06:00:00-03', '2026-06-06 08:05:00-03', 7, 6, 6, 1006);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (7, '2026-06-07 10:45:00-03', '2026-06-07 13:00:00-03', 8, 7, 7, 1007);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (8, '2026-06-08 16:20:00-03', '2026-06-08 18:50:00-03', 9, 8, 8, 1008);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (9, '2026-06-09 18:30:00-03', '2026-06-09 21:10:00-03', 10, 9, 9, 1009);

INSERT INTO voos (codigo, saida, chegada, destino, origem, avioes, pilotos) 
VALUES (10, '2026-06-10 05:50:00-03', '2026-06-10 08:20:00-03', 1, 10, 10, 1010);