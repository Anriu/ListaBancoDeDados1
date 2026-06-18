-- Banco 3 - Veterinaria

-- Tabela medicos_veterinarios
CREATE TABLE medicos_veterinarios(
	codigo INTEGER NOT NULL,
	nome CHAR(40) NOT NULL,
	telefone CHAR(14) NULL,

	-- Chave primaria
	CONSTRAINT pk_medicos_veterinarios
		PRIMARY KEY(codigo)
);

-- Tabela proprietarios
CREATE TABLE proprietarios(
	codigo INTEGER NOT NULL,
	nome CHAR(30) NOT NULL,
	endereco CHAR(40) NULL,
	telefone DECIMAL(10,0) NULL, 

	-- Chave primaria
	CONSTRAINT pk_proprietarios
		PRIMARY KEY(codigo)
);

-- Tabela cores
CREATE TABLE cores(
	codigo SMALLINT NOT NULL, 
	nome CHAR(20) NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_cores
		PRIMARY KEY(codigo)
);

-- Tabela racas
CREATE TABLE racas(
	codigo SMALLINT NOT NULL,
	nome CHAR(30) NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_racas
		PRIMARY KEY(codigo)
);

-- Tabela medicamentos
CREATE TABLE medicamentos(
	codigo INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	preco DECIMAL(5,2) NULL,
	
	-- Chave primaria
	CONSTRAINT pk_medicamentos
		PRIMARY KEY(codigo)
);

-- Tabela animais
CREATE TABLE animais(
	codigo INTEGER NOT NULL,
	nome CHAR(20) NOT NULL,
	nascimento DATE NOT NULL, 

	-- Para chaves estrangeiras
	cor SMALLINT NOT NULL,
	raca SMALLINT NOT NULL,
	proprietario INTEGER NOT NULL,
	
	-- Chave primaria
	CONSTRAINT pk_animais
		PRIMARY KEY(codigo),

	-- Chaves estrangeiras
	CONSTRAINT fk_animais_cor
		FOREIGN KEY (cor)
		REFERENCES cores(codigo),

	CONSTRAINT fk_animais_raca
		FOREIGN KEY (raca)
		REFERENCES racas(codigo),

	CONSTRAINT fk_animais_proprietario
		FOREIGN KEY (proprietario)
		REFERENCES proprietarios(codigo)
);

-- Tabela atendimentos
CREATE TABLE atendimentos(
	codigo INTEGER NOT NULL,
	data_hora TIMESTAMP NOT NULL, 
	descricao TEXT NULL,
	preco DECIMAL(6,2) NULL,

	-- Para chaves estrangeiras
	animal INTEGER NULL,
	medico INTEGER NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_atendimentos
		PRIMARY KEY(codigo),

	-- Chaves estrangeiras
	CONSTRAINT fk_atendimentos_animal
		FOREIGN KEY (animal)
		REFERENCES animais(codigo),
	
	CONSTRAINT fk_atendimentos_medico_veterinario
		FOREIGN KEY (medico)
		REFERENCES medicos_veterinarios(codigo)
);

-- Tabela prescricoes
CREATE TABLE prescricoes(
	medicamento INTEGER NOT NULL,
	atendimento INTEGER NOT NULL,
	quantidade SMALLINT NOT NULL, 
	
	-- Chave primaria
	CONSTRAINT pk_prescricoes
        PRIMARY KEY (medicamento, atendimento),

	-- Chaves estrangeiras
	CONSTRAINT fk_prescricoes_medicamento
        FOREIGN KEY (medicamento)
        REFERENCES medicamentos(codigo),

	CONSTRAINT fk_prescricoes_atendimento
        FOREIGN KEY (atendimento)
        REFERENCES atendimentos(codigo)
);

-- Questao 51
SELECT *
FROM medicos_veterinarios
ORDER BY nome ASC;

-- Questao 52
SELECT nome, preco
FROM medicamentos
WHERE preco BETWEEN 20.00 and 100.00;

-- Questao 53
SELECT nome
FROM animais
WHERE TRIM(nome) ILIKE 'R%'
	OR TRIM(nome) ILIKE '%O';
	
-- Questao 54
SELECT *
FROM proprietarios
WHERE telefone IS NULL 
	OR endereco IS NULL;
	
-- Questao 55
SELECT *
FROM animais
WHERE nascimento >= '2020-01-01';

-- Questao 56
SELECT nome
FROM racas
WHERE TRIM(nome) ILIKE '_A%';

-- Questao 57
SELECT COUNT(*)
FROM atendimentos
WHERE preco > 150.00;


-- Questao 58
SELECT nome, preco
FROM medicamentos
ORDER BY preco DESC
LIMIT 5;

-- Questao 59
SELECT a.nome AS nome_animal, r.nome AS nome_raca
FROM animais a
JOIN racas r ON a.raca = r.codigo;

-- Questao 60
SELECT
	aten.data_hora AS data_hora,
	a.nome AS nome_animal,
	m.nome AS nome_medico
FROM atendimentos aten
JOIN animais a ON aten.animal = a.codigo
JOIN medicos_veterinarios m ON aten.medico = m.codigo;

-- Questao 61
SELECT 
    a.nome AS nome_animal,
    p.nome AS nome_proprietario,
    r.nome AS nome_raca,
    c.nome AS nome_cor
FROM animais a
JOIN proprietarios p ON a.proprietario = p.codigo
JOIN racas r ON a.raca = r.codigo
JOIN cores c ON a.cor = c.codigo;

-- Questao 62
SELECT
    m.nome AS nome_medico,
    COUNT(a.codigo) AS quantidade_total
FROM medicos_veterinarios m
LEFT JOIN atendimentos a ON a.medico = m.codigo
GROUP BY m.codigo, m.nome;

-- Questao 63
SELECT 
	a.nome AS nome_animal,
	SUM(aten.preco) AS valor_total
FROM animais a
JOIN atendimentos aten ON aten.animal = a.codigo
GROUP BY a.codigo, a.nome;

-- Questao 64
SELECT r.nome
FROM racas r
JOIN animais a ON a.raca = r.codigo
GROUP BY r.codigo, r.nome
HAVING COUNT(a.raca) > 10;


-- Questao 65
SELECT DISTINCT p.nome
FROM proprietarios p
JOIN animais a ON a.proprietario = p.codigo
JOIN cores c ON a.cor = c.codigo
WHERE c.nome IN ('Branco', 'Preto');

-- Questao 66
SELECT 
    aten.data_hora AS data_atendimento,
    TRIM(a.nome) AS nome_animal,
    m.nome AS nome_medicamento
FROM atendimentos aten
JOIN animais a ON aten.animal = a.codigo
JOIN prescricoes p ON aten.codigo = p.atendimento
JOIN medicamentos m ON p.medicamento = m.codigo;

	
-- Questao 67
SELECT 
    r.nome AS nome_raca,
    COUNT(aten.codigo) AS total_atendimentos
FROM racas r
LEFT JOIN animais a ON a.raca = r.codigo
LEFT JOIN atendimentos aten ON aten.animal = a.codigo
GROUP BY r.codigo, r.nome
ORDER BY total_atendimentos DESC;

-- Questao 68
SELECT DISTINCT
    m.nome AS nome_medico,
    m.telefone AS telefone_medico
FROM medicos_veterinarios m
JOIN atendimentos aten ON aten.medico = m.codigo
WHERE aten.preco = (SELECT MAX(preco) FROM atendimentos);
 

-- Questao 69
SELECT p.nome
FROM proprietarios p
WHERE p.codigo IN (
    SELECT a.proprietario
    FROM animais a
    WHERE a.raca IN (
        SELECT r.codigo
        FROM racas r
        WHERE TRIM(r.nome) IN ('Poodle', 'Pastor Alemao')
    )
);

-- Questao 70
SELECT a.nome AS nome_animal
FROM animais a
LEFT JOIN atendimentos aten ON aten.animal = a.codigo
WHERE aten.codigo IS NULL
ORDER BY a.nome;

-- Questao 71
SELECT m.nome, m.preco
FROM medicamentos m
WHERE m.preco > (
    SELECT AVG(m2.preco)
    FROM prescricoes p
    JOIN atendimentos a ON a.codigo = p.atendimento
    JOIN medicamentos m2 ON m2.codigo = p.medicamento
    WHERE EXTRACT(YEAR FROM a.data_hora) = EXTRACT(YEAR FROM CURRENT_DATE)
);

-- Questao 72
SELECT p.nome
FROM proprietarios p
ORDER BY (
    (
        SELECT COALESCE(SUM(aten.preco), 0)
        FROM animais a
        LEFT JOIN atendimentos aten ON aten.animal = a.codigo
        WHERE a.proprietario = p.codigo
    ) + 
    (
        SELECT COALESCE(SUM(m.preco * pr.quantidade), 0)
        FROM animais a
        JOIN atendimentos aten ON aten.animal = a.codigo
        JOIN prescricoes pr ON pr.atendimento = aten.codigo
        JOIN medicamentos m ON pr.medicamento = m.codigo
        WHERE a.proprietario = p.codigo
    )
) DESC
LIMIT 1;


-- Questao 73
SELECT 
    aten.codigo,
    aten.data_hora,
    aten.preco
FROM atendimentos aten
WHERE aten.preco > (
    SELECT AVG(a.preco)
    FROM atendimentos a
    WHERE a.medico = aten.medico
);

-- Questao 74
SELECT 
    p.nome AS nome_proprietario,
    COUNT(a.codigo) AS quantidade_animais
FROM proprietarios p
JOIN animais a ON a.proprietario = p.codigo
GROUP BY p.codigo, p.nome
HAVING COUNT(a.codigo) > 3;

-- Questao 75
SELECT 
    m.nome,
    SUM(p.quantidade) AS total_receitado
FROM medicamentos m
JOIN prescricoes p ON p.medicamento = m.codigo
JOIN atendimentos a ON a.codigo = p.atendimento
JOIN animais an ON an.codigo = a.animal
JOIN racas r ON r.codigo = an.raca
WHERE r.nome ILIKE '%gato%'
   OR r.nome ILIKE '%feline%'
GROUP BY m.codigo, m.nome
ORDER BY total_receitado DESC
LIMIT 1;


--Insercoes para teste
-- Medicos Veterinarios
INSERT INTO medicos_veterinarios (codigo, nome, telefone) 
VALUES (1, 'Carlos Eduardo', '74999910001');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (2, 'Ana Beatriz', '74999910002');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (3, 'Marcos Paulo', '74999910003');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (4, 'Julia Costa', '74999910004');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (5, 'Roberto Silva', '74999910005');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (6, 'Fernanda Lima', '74999910006');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (7, 'Ricardo Alves', '74999910007');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (8, 'Camila Souza', '74999910008');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (9, 'Gabriel Rocha', '74999910009');

INSERT INTO medicos_veterinarios (codigo, nome, telefone)
VALUES (10, 'Patricia Melo', '74999910010');

-- Proprietarios
INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (101, 'Joao Santos', 'Rua das Flores, 45', 7436111001);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (102, 'Maria Oliveira', 'Av. Central, 120', 7436111002);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (103, 'Lucas Almeida', 'Rua Bahia, 88', 7436111003);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (104, 'Juliana Reis', 'Alameda Sol, 15', 7436111004);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (105, 'Pedro Costa', 'Travessa Norte, 9', 7436111005);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (106, 'Mariana Lima', 'Rua Sete, 234', 7436111006);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (107, 'Rodrigo Gomes', 'Av. Brasil, 400', 7436111007);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (108, 'Beatriz Rocha', 'Rua Direita, 55', 7436111008);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (109, 'Fernando Souza', 'Av. Paris, 1000', 7436111009);

INSERT INTO proprietarios (codigo, nome, endereco, telefone)
VALUES (110, 'Aline Borges', 'Rua do Paraiso, 12', 7436111010);

INSERT INTO proprietarios (codigo, nome, endereco, telefone) 
VALUES (111, 'Marcos Souza', 'Rua das Palmeiras, 30', NULL);

INSERT INTO proprietarios (codigo, nome, endereco, telefone) 
VALUES (112, 'Fernanda Costa', NULL, 7436112233);

INSERT INTO proprietarios (codigo, nome, endereco, telefone) 
VALUES (113, 'Ricardo Santos', NULL, NULL);


-- Cores
INSERT INTO cores (codigo, nome) 
VALUES (1, 'Preto');

INSERT INTO cores (codigo, nome)
VALUES (2, 'Branco');

INSERT INTO cores (codigo, nome)
VALUES (3, 'Marrom');

INSERT INTO cores (codigo, nome)
VALUES (4, 'Cinza');

INSERT INTO cores (codigo, nome)
VALUES (5, 'Caramelo');

INSERT INTO cores (codigo, nome)
VALUES (6, 'Dourado');

INSERT INTO cores (codigo, nome)
VALUES (7, 'Malhado');

INSERT INTO cores (codigo, nome)
VALUES (8, 'Creme');

INSERT INTO cores (codigo, nome)
VALUES (9, 'Tigrado');

INSERT INTO cores (codigo, nome)
VALUES (10, 'Azul Russo');

-- Racas
INSERT INTO racas (codigo, nome)
VALUES (1, 'Vira-lata (SRD)');

INSERT INTO racas (codigo, nome)
VALUES (2, 'Pastor Alemao');

INSERT INTO racas (codigo, nome)
VALUES (3, 'Poodle');

INSERT INTO racas (codigo, nome)
VALUES (4, 'Pinscher');

INSERT INTO racas (codigo, nome)
VALUES (5, 'Siames (Gato)');

INSERT INTO racas (codigo, nome)
VALUES (6, 'Persa (Gato)');

INSERT INTO racas (codigo, nome)
VALUES (7, 'Golden Retriever');

INSERT INTO racas (codigo, nome)
VALUES (8, 'Labrador');

INSERT INTO racas (codigo, nome)
VALUES (9, 'Bulldog Frances');

INSERT INTO racas (codigo, nome)
VALUES (10, 'Pitbull');

-- Medicamentos
INSERT INTO medicamentos (codigo, nome, preco)
VALUES (501, 'Antitoxico Dopalen', 45.50);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (502, 'Antibiotico Chemitril', 62.00);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (503, 'Anti-inflamatorio Maxicam', 35.80);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (504, 'Vitamina Glicopan Pet', 28.90);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (505, 'Vermifugo Apoquel', 120.00);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (506, 'Pomada Ganadol', 18.50);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (507, 'Colirio Tobradex', 54.00);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (508, 'Suplemento Organew', 42.10);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (509, 'Shampoo Peroxydex', 75.00);

INSERT INTO medicamentos (codigo, nome, preco)
VALUES (510, 'Analgesico Dipirona Gotas', 12.30);

-- Animais
INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1001, 'Thor', '2020-03-15', 3, 2, 101);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1002, 'Luna', '2022-07-20', 2, 5, 102);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1003, 'Mel', '2019-09-10', 5, 3, 103);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1004, 'Rex', '2018-01-05', 1, 1, 104);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1023, 'Mia', '2023-05-18', 4, 6, 105);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1006, 'Bob', '2021-11-22', 6, 7, 106);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1007, 'Pipoca', '2024-02-14', 8, 4, 107);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1008, 'Apollo', '2020-06-30', 1, 10, 108);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1009, 'Frida', '2022-12-25', 9, 9, 109);

INSERT INTO animais (codigo, nome, nascimento, cor, raca, proprietario)
VALUES (1010, 'Simba', '2021-08-08', 5, 1, 110);

-- Atendimentos
INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2001, '2026-06-15 09:00:00', 'Consulta de rotina e vacinacao', 150.00, 1001, 1);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2002, '2026-06-15 10:15:00', 'Tratamento de otite infecciosa', 180.00, 1002, 2);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2003, '2026-06-15 11:30:00', 'Procedimento de limpeza de tartaro', 350.00, 1003, 3);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2004, '2026-06-15 14:00:00', 'Sutura de ferimento na pata traseira', 220.00, 1004, 4);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2005, '2026-06-15 15:20:00', 'Exame dermatologico e coleta de sangue', 130.00, 1023, 5);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2006, '2026-06-15 16:45:00', 'Aplicacao de antialergico intravenoso', 95.00, 1006, 6);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2007, '2026-06-15 17:30:00', 'Atendimento emergencial por intoxicacao', 400.00, 1007, 7);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2008, '2026-06-15 18:10:00', 'Reavaliacao cirurgica ortopedica', 200.00, 1008, 8);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2009, '2026-06-15 19:00:00', 'Ultrassonografia abdominal preventiva', 250.00, 1009, 9);

INSERT INTO atendimentos (codigo, data_hora, descricao, preco, animal, medico)
VALUES (2010, '2026-06-15 20:00:00', 'Consulta para controle de obesidade', 150.00, 1010, 10);

-- Prescricoes
INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (504, 2001, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (502, 2002, 2);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (507, 2002, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (503, 2003, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (506, 2004, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (510, 2004, 2);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (505, 2005, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (509, 2005, 1);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (501, 2007, 2);

INSERT INTO prescricoes (medicamento, atendimento, quantidade)
VALUES (508, 2010, 1);