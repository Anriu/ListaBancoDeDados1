-- Banco 3


-- Tabela medicos_veterinarios
CREATE TABLE medicos_veterinarios(
	codigo INTEGER NOT NULL,
	nome CHAR(40) NOT NULL,
	telefone CHAR(14) NULL,

	-- Chave primária
	CONSTRAINT pk_medicos_veterinarios
		PRIMARY KEY(codigo)
);


-- Tabela proprietarios
CREATE TABLE proprietarios(
	codigo INTEGER NOT NULL,
	nome CHAR(30) NOT NULL,
	endereco CHAR(40) NULL,
	telefone DECIMAL(10,0) NOT NULL,

	-- Chave primária
	CONSTRAINT pk_proprietarios
		PRIMARY KEY(codigo)
);


-- Tabela cores
CREATE TABLE cores(
	codigo SMALLINT NOT NULL,
	nome CHAR(20) NOT NULL,

	-- Chave primária
	CONSTRAINT pk_cores
		PRIMARY KEY(codigo)
);

-- Tabela racas
CREATE TABLE racas(
	codigo SMALLINT NOT NULL,
	nome CHAR(30) NOT NULL,

	-- Chave primária
	CONSTRAINT pk_racas
		PRIMARY KEY(codigo)
);

-- Tabela medicamentos
CREATE TABLE medicamentos(
	codigo INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	preco DECIMAL(5,2) NULL,
	
	-- Chave primária
	CONSTRAINT pk_medicamentos
		PRIMARY KEY(codigo)
);


-- Tabela animais
CREATE TABLE animais(
	codigo INTEGER NOT NULL,
	nome CHAR(20) NOT NULL,
	nascimento TIMESTAMP NULL,

	--Para chaves estrangeiras
	cor SMALLINT NOT NULL,
	raca SMALLINT NOT NULL,
	proprietario INTEGER NOT NULL,
	
	
	-- Chave primária
	CONSTRAINT pk_animais
		PRIMARY KEY(codigo),

	-- Chaves estrageiras
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
	preco DECIMAL(6,2),

	--Para chaves estrangeiras
	animal INTEGER NULL,
	medico  INTEGER NOT NULL

	
	-- Chave primária
	CONSTRAINT pk_atendimentos
		PRIMARY KEY(codigo)

	-- Chaves estrangeiras
	CONSTRAINT fk_atendimentos_animal
		FOREIGN KEY (animal)
		REFERENCES animais(codigo)
	
	CONSTRAINT fk_atendimentos_medico_veterinario
		FOREIGN KEY (medico)
		REFERENCES medicos_veterinarios(codigo)
);





-- Tabela prscricoes
CREATE TABLE prscricoes(
	codigo INTEGER NOT NULL,
	
	-- Chave primária
	CONSTRAINT pk_prscricoes
		PRIMARY KEY(codigo)
);


