-- Database: sistemaEleitoral

-- DROP DATABASE IF EXISTS "sistemaEleitoral";

CREATE DATABASE "sistemaEleitoral"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Tabela Partidos
CREATE TABLE Partidos (
    Sigla VARCHAR(10) PRIMARY KEY,
    nAfiliados INT DEFAULT 0
);

-- Tabela Cargos
CREATE TABLE Cargos (
    idCargo SERIAL PRIMARY KEY,
    Cidade VARCHAR(100) NOT NULL,
    Estado VARCHAR(50) NOT NULL
);

-- Tabela Pleito
CREATE TABLE Pleito (
    idPleito SERIAL PRIMARY KEY,
	qtdVoto NUMERIC(6),
    DataAno DATE NOT NULL
);

-- Tabela Programa de Partido
CREATE TABLE ProgramaDePartido (
    idPrograma SERIAL PRIMARY KEY,
    Descricao TEXT NOT NULL
);

-- Tabela Doadores
CREATE TABLE Doadores (
    idDoador SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CNPJ VARCHAR(20)
);

-- Tabela Processos
CREATE TABLE Processos (
    idProcesso SERIAL PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    Data DATE NOT NULL,
    Tramitado BOOLEAN DEFAULT FALSE,
    Julgado BOOLEAN DEFAULT FALSE
);

-- Tabela Equipes de Apoio
CREATE TABLE EquipesApoio (
    idEquipe SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- Tabela ParticipantesEquipesApoio
CREATE TABLE ParticipantesEquipesApoio (
    CPF NUMERIC(11) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- Tabela Candidatos
CREATE TABLE Candidatos (
    idCandidato SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    NumeroCandidato INT UNIQUE NOT NULL,
    Vice VARCHAR(100),
	
    idPartido INT REFERENCES Partidos(Sigla) ON DELETE SET NULL ON UPDATE CASCADE,
    idCargo INT REFERENCES Cargos(idCargo) ON DELETE SET NULL ON UPDATE CASCADE,
    idPleito INT REFERENCES Pleitos(idPleito) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabela Doacoes
CREATE TABLE Doacoes (
    idDoacao SERIAL PRIMARY KEY,
    Valor DECIMAL(15,2) NOT NULL,
    Data DATE NOT NULL,
	
    idDoador INT REFERENCES Doadores(idDoador) ON DELETE CASCADE ON UPDATE CASCADE,
    idCandidato INT REFERENCES Candidatos(idCandidato) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela Fichas
CREATE TABLE Fichas (
    idFicha SERIAL PRIMARY KEY,
    dataJulgamento DATE,
	Elegível BOOLEAN DEFAULT TRUE,
	
    idCandidato INT REFERENCES Candidatos(idCandidato) ON DELETE CASCADE ON UPDATE CASCADE,
    idProcesso INT REFERENCES Processos(idProcesso) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela Candidatura
CREATE TABLE Candidatura (
    idCandidatura SERIAL PRIMARY KEY,
	
    idCandidato INT REFERENCES Candidatos(idCandidato) ON DELETE CASCADE ON UPDATE CASCADE,
    idPrograma INT REFERENCES Programas(idPrograma) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Trigger para atualizar o número de afiliados ao inserir um novo partido
CREATE OR REPLACE FUNCTION atualizar_num_afiliados_insert() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Partidos SET nAfiliados = nAfiliados + 1 WHERE idPartido = NEW.idPartido;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_num_afiliados_insert
AFTER INSERT ON Candidatos
FOR EACH ROW
EXECUTE FUNCTION atualizar_num_afiliados_insert();

-- Trigger para atualizar o número de afiliados ao deletar um partido
CREATE OR REPLACE FUNCTION atualizar_num_afiliados_delete() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Partidos SET nAfiliados = nAfiliados - 1 WHERE idPartido = OLD.idPartido;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_num_afiliados_delete
AFTER DELETE ON Candidatos
FOR EACH ROW
EXECUTE FUNCTION atualizar_num_afiliados_delete();


















