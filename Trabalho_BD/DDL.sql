--Tabela Individuo
CREATE TABLE IF NOT EXISTS Individuo (
	idIndividuo SERIAL PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL
);

--Tabela Pessoa Física
CREATE TABLE IF NOT EXISTS PessoaFisica (
	CPF NUMERIC(11) PRIMARY KEY,
	idIndividuo INT REFERENCES Individuo(idIndividuo) ON DELETE CASCADE ON UPDATE CASCADE
);

--Tabela Pessoa Jurídica
CREATE TABLE IF NOT EXISTS PessoaJuridica (
	CNPJ NUMERIC(14) PRIMARY KEY,
	idIndividuo INT REFERENCES Individuo(idIndividuo) ON DELETE CASCADE ON UPDATE CASCADE
);

--Tabela Processo
CREATE TABLE IF NOT EXISTS Processo (
	idProcesso SERIAL PRIMARY KEY,
	Data DATE NOT NULL,
	Status VARCHAR(50) NOT NULL,
	Tipo VARCHAR(50) NOT NULL,
	Procedente BOOLEAN,
	NaoProcedente BOOLEAN,
	Tramitado BOOLEAN,
	Julgado BOOLEAN
);

--Tabela Ficha
CREATE TABLE IF NOT EXISTS Ficha (
	idIndividuo INT REFERENCES Individuo(idIndividuo) ON DELETE CASCADE ON UPDATE CASCADE,
	idProcesso INT REFERENCES Processo(IdProcesso) ON DELETE CASCADE ON UPDATE CASCADE,
	Data DATE NOT NULL,
	Status VARCHAR(50)
);

--Tabela Candidato
CREATE TABLE IF NOT EXISTS Candidato (
	NumCandidato INT PRIMARY KEY,
	idIndividuo INT REFERENCES Individuo(idIndividuo) ON DELETE CASCADE ON UPDATE CASCADE,
	Nome VARCHAR(100) NOT NULL
);

--Tabela Partido
CREATE TABLE IF NOT EXISTS Partido (
	Sigla VARCHAR(10) PRIMARY KEY,
	NAfiliados NUMERIC(5)
);

--Tabela Programa
CREATE TABLE IF NOT EXISTS Programa (
	idPrograma SERIAL PRIMARY KEY,
	Descricao TEXT
);

--Tabela Cargo
CREATE TABLE IF NOT EXISTS Cargo (
	idCargo SERIAL PRIMARY KEY,
	Cidade VARCHAR(50),
	Estado VARCHAR(50),
	Executivo BOOLEAN,
	Legislativo BOOLEAN
);

--Tabela Pleito
CREATE TABLE IF NOT EXISTS Pleito (
	idPleito SERIAL PRIMARY KEY,
	Data DATE NOT NULL,
	QtdVotos NUMERIC(6),
	Vice VARCHAR(100)
);

--Tabela Candidatura
CREATE TABLE IF NOT EXISTS Candidatura (
	NumCandidato INT REFERENCES Candidato(NumCandidato) ON DELETE CASCADE ON UPDATE CASCADE,
	idCargo INT REFERENCES Cargo(idCargo) ON DELETE CASCADE ON UPDATE CASCADE,
	idPleito INT REFERENCES Pleito(idPleito) ON DELETE CASCADE ON UPDATE CASCADE,
	SeElege BOOLEAN
);

--Tabela DoacaoPJ
CREATE TABLE IF NOT EXISTS DoacaoPJ (
	idDoacaoPJ SERIAL PRIMARY KEY,
	Data DATE NOT NULL,
	Valor NUMERIC(10, 2),
	NumCandidato INT REFERENCES Candidato(NumCandidato) UNIQUE NOT NULL,
	idDoador NUMERIC(14) REFERENCES PessoaJuridica(CNPJ) UNIQUE NOT NULL
);

--Tabela DoacaoPF
CREATE TABLE IF NOT EXISTS DoacaoPF (
    idDoacaoPF SERIAL PRIMARY KEY,
    Data DATE NOT NULL,
    Valor NUMERIC(10, 2) NOT NULL,
    NumCandidato INT REFERENCES Candidato(NumCandidato),
    idDoador INT REFERENCES PessoaFisica(CPF)
);

--Tabela Apoiador
CREATE TABLE IF NOT EXISTS Apoiador (
    idApoiador SERIAL PRIMARY KEY,
    idIndividuo INTEGER NOT NULL,
    CONSTRAINT fk_idIndividuo FOREIGN KEY (idIndividuo) REFERENCES Individuo(idIndividuo)
);

--Tabela Equipe Apoio
CREATE TABLE IF NOT EXISTS EquipeApoio (
    idEquipeApoio SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

CREATE OR REPLACE FUNCTION verifica_candidatura_anual()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Candidatura 
        WHERE 
            NEW.NumCandidato = Candidatura.NumCandidato 
            AND EXTRACT(YEAR FROM NEW.Data) = EXTRACT(YEAR FROM Candidatura.Data)
    ) THEN
        RAISE EXCEPTION 'Candidato já se candidatou a um cargo este ano';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verifica_candidatura_anual
BEFORE INSERT ON Candidatura
FOR EACH ROW
EXECUTE FUNCTION verifica_candidatura_anual();

CREATE OR REPLACE FUNCTION verifica_ficha_limpa()
RETURNS TRIGGER AS $$
DECLARE
    ultimo_julgado DATE;
BEGIN
    SELECT MAX(Processo.Data)
    INTO ultimo_julgado
    FROM Processo
    JOIN Ficha ON Processo.idProcesso = Ficha.idProcesso
    WHERE 
        Ficha.idIndividuo = NEW.idIndividuo
        AND Processo.Julgado = TRUE;

    IF (ultimo_julgado IS NULL OR (CURRENT_DATE - INTERVAL '5 years') >= ultimo_julgado) THEN
        NEW.FichaLimpa = TRUE;
    ELSE
        NEW.FichaLimpa = FALSE;
    END IF;

    -- Formatar a data no formato dd/mm/aaaa
    NEW.Data = TO_CHAR(NEW.Data, 'DD/MM/YYYY');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verifica_ficha_limpa
BEFORE INSERT OR UPDATE ON Ficha
FOR EACH ROW
EXECUTE FUNCTION verifica_ficha_limpa();

CREATE OR REPLACE FUNCTION verifica_ficha_limpa_candidato()
RETURNS TRIGGER AS $$
DECLARE
    ficha_limpa BOOLEAN;
BEGIN
    SELECT FichaLimpa
    INTO ficha_limpa
    FROM Ficha
    WHERE Ficha.idIndividuo = NEW.idIndividuo;

    IF ficha_limpa IS NOT TRUE THEN
        RAISE EXCEPTION 'Indivíduo não está ficha-limpa e não pode se candidatar';
    END IF;

    -- Formatar a data no formato dd/mm/aaaa (caso haja alguma coluna de data relevante)
    NEW.Data = TO_CHAR(NEW.Data, 'DD/MM/YYYY');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verifica_ficha_limpa_candidato
BEFORE INSERT ON Candidato
FOR EACH ROW
EXECUTE FUNCTION verifica_ficha_limpa_candidato();

