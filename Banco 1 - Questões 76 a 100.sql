-- Banco 4 - Veiculos de Transporte

-- Tabela de passageiros
CREATE TABLE passageiros(
	telefone VARCHAR(15) NOT NULL,
	nome VARCHAR(40) NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_passageiros
		PRIMARY KEY(telefone)
);

-- Tabela de carros
CREATE TABLE carros(
	placa CHAR(7) NOT NULL,
	ano DECIMAL(4,0) NULL,
	modelo CHAR(10) NULL,
	capacidade SMALLINT null,

	-- Chave primaria
	CONSTRAINT pk_carros
		PRIMARY KEY(placa)
);


-- Tabela de bairros
CREATE TABLE bairros(
	codigo SMALLINT NOT NULL,
	nome VARCHAR(50) NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_bairros
		PRIMARY KEY(codigo)
);


-- Tabela de logradouros
CREATE TABLE logradouros(
	codigo INTEGER NOT NULL,
	nome VARCHAR(70) NOT NULL,

	-- Chave primaria
	CONSTRAINT pk_logradouros
		PRIMARY KEY(codigo)
);

-- Tabela de motoristas
CREATE TABLE motoristas(
	cnh CHAR(10) NOT NULL,
	nome CHAR(30) NOT NULL,
	nascimento DATE null,

	-- Chave primaria
	CONSTRAINT pk_motoristas
		PRIMARY KEY(cnh)
);


-- Tabela corridas
CREATE TABLE corridas(
	corrida INTEGER NOT NULL,
	valor DECIMAL(5,2) null,

	-- Para chaves estrangeiras
	carro CHAR(7) NOT NULL,
	cnh CHAR(10) NOT NULL,
	rua_origem INTEGER NOT NULL,
	bairro_origem SMALLINT NOT NULL,
	rua_destino INTEGER NULL,
	bairro_destino SMALLINT NULL,
	passageiro VARCHAR(15) NULL,
	
	-- Chave primaria
	CONSTRAINT pk_corridas
		PRIMARY KEY(corrida),

	-- Chaves estrangeiras
	CONSTRAINT fk_corridas_carros
		FOREIGN KEY (carro)
		REFERENCES carros(placa),

	CONSTRAINT fk_corridas_motoristas
		FOREIGN KEY (cnh)
		REFERENCES motoristas(cnh),

	CONSTRAINT fk_corridas_passageiros
		FOREIGN KEY (passageiro)
		REFERENCES passageiros(telefone),

	CONSTRAINT fk_corridas_logradouros_origem
		FOREIGN KEY (rua_origem)
		REFERENCES logradouros(codigo),

	CONSTRAINT fk_corridas_bairros_origem
		FOREIGN KEY (bairro_origem)
		REFERENCES bairros(codigo),

	CONSTRAINT fk_corridas_logradouros_destino
		FOREIGN KEY (rua_destino)
		REFERENCES logradouros(codigo),

	CONSTRAINT fk_corridas_bairros_destino
		FOREIGN KEY (bairro_destino)
		REFERENCES bairros(codigo)
);





-- Insercoes para teste 
-- Passageiros
INSERT INTO passageiros (telefone, nome) VALUES ('11999990001', 'Lucas Silva');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990002', 'Beatriz Santos');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990003', 'Carlos Eduardo');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990004', 'Mariana Oliveira');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990005', 'Rodrigo Costa');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990006', 'Juliana Reis');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990007', 'Fernando Souza');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990008', 'Aline Borges');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990009', 'Ricardo Alves');
INSERT INTO passageiros (telefone, nome) VALUES ('11999990010', 'Patricia Melo');

-- Carros
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('ABC1234', 2022, 'Corolla', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('XYZ5678', 2020, 'Onix', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('MNO9876', 2023, 'Compass', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('KJH4321', 2019, 'HB20', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('QWE0987', 2021, 'Argo', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('RTY6543', 2024, 'Nivus', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('UIP0123', 2018, 'Uno', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('VBN7890', 2022, 'Virtus', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('PLM4567', 2023, 'Kwid', 4);
INSERT INTO carros (placa, ano, modelo, capacidade) VALUES ('OKN3210', 2021, 'Tracker', 4);

-- Bairros
INSERT INTO bairros (codigo, nome) VALUES (1, 'Centro');
INSERT INTO bairros (codigo, nome) VALUES (2, 'Jardins');
INSERT INTO bairros (codigo, nome) VALUES (3, 'Pinheiros');
INSERT INTO bairros (codigo, nome) VALUES (4, 'Vila Mariana');
INSERT INTO bairros (codigo, nome) VALUES (5, 'Moema');
INSERT INTO bairros (codigo, nome) VALUES (6, 'Butanta');
INSERT INTO bairros (codigo, nome) VALUES (7, 'Santana');
INSERT INTO bairros (codigo, nome) VALUES (8, 'Lapa');
INSERT INTO bairros (codigo, nome) VALUES (9, 'Ipiranga');
INSERT INTO bairros (codigo, nome) VALUES (10, 'Tatuape');

-- Logradouros
INSERT INTO logradouros (codigo, nome) VALUES (101, 'Avenida Paulista');
INSERT INTO logradouros (codigo, nome) VALUES (102, 'Rua Augusta');
INSERT INTO logradouros (codigo, nome) VALUES (103, 'Avenida Reboucas');
INSERT INTO logradouros (codigo, nome) VALUES (104, 'Rua Domingos de Morais');
INSERT INTO logradouros (codigo, nome) VALUES (105, 'Avenida Ibirapuera');
INSERT INTO logradouros (codigo, nome) VALUES (106, 'Avenida Vital Brasil');
INSERT INTO logradouros (codigo, nome) VALUES (107, 'Rua Voluntarios da Patria');
INSERT INTO logradouros (codigo, nome) VALUES (108, 'Rua Doze de Outubro');
INSERT INTO logradouros (codigo, nome) VALUES (109, 'Rua Silva Bueno');
INSERT INTO logradouros (codigo, nome) VALUES (110, 'Rua Tuiuti');

-- Motoristas
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('1234567890', 'Jose Eduardo Reis', '1980-05-14');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('2345678901', 'Ana Beatriz Souza', '1988-09-22');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('3456789012', 'Marcos Paulo Lima', '1975-03-30');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('4567890123', 'Julia Costa Mendes', '1992-11-12');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('5678901234', 'Roberto Silva Alves', '1983-07-08');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('6789012345', 'Fernanda Rocha Carvalho', '1990-01-25');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('7890123456', 'Ricardo Santos Gomes', '1979-06-18');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('8901234567', 'Camila Oliveira Ramos', '1995-04-02');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('9012345678', 'Gabriel Nascimento Melo', '1986-12-05');
INSERT INTO motoristas (cnh, nome, nascimento) VALUES ('0123456789', 'Amanda Vieira Cunha', '1991-08-19');

-- Corridas
INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (1, 'ABC1234', '1234567890', 101, 1, 102, 1, '11999990001', 25.50);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (2, 'XYZ5678', '2345678901', 103, 3, 105, 5, '11999990002', 42.00);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (3, 'MNO9876', '3456789012', 104, 4, 109, 9, '11999990003', 38.50);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (4, 'KJH4321', '4567890123', 106, 6, 101, 1, '11999990004', 31.00);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (5, 'QWE0987', '5678901234', 107, 7, 108, 8, '11999990005', 45.00);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (6, 'RTY6543', '6789012345', 110, 10, 104, 4, '11999990006', 52.30);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (7, 'UIP0123', '7890123456', 102, 1, 103, 3, '11999990007', 18.00);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (8, 'VBN7890', '8901234567', 105, 5, 106, 6, '11999990008', 29.90);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (9, 'PLM4567', '9012345678', 109, 9, 110, 10, '11999990009', 61.20);

INSERT INTO corridas (corrida, carro, cnh, rua_origem, bairro_origem, rua_destino, bairro_destino, passageiro, valor) 
VALUES (10, 'OKN3210', '0123456789', 108, 8, 107, 7, '11999990010', 35.00);
