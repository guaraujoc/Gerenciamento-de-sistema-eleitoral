-- Inserções para a Tabela Individuo
INSERT INTO Individuo (Nome) VALUES
('João Silva'),
('Maria Oliveira'),
('Carlos Souza'),
('Ana Pereira'),
('Pedro Santos'),
('Paula Lima'),
('José Almeida'),
('Rita Gonçalves'),
('Ricardo Ramos'),
('Fernanda Ferreira');

-- Inserções para a Tabela Pessoa Fisica
INSERT INTO PessoaFisica (CPF, idIndividuo) VALUES
(12345678901, 1),
(23456789012, 2),
(34567890123, 3),
(45678901234, 4),
(56789012345, 5),
(67890123456, 6),
(78901234567, 7),
(89012345678, 8),
(90123456789, 9),
(12345098765, 10);

-- Inserções para a Tabela Pessoa Juridica
INSERT INTO PessoaJuridica (CNPJ, idIndividuo) VALUES
(12345678000101, 1),
(23456789000102, 2),
(34567890000103, 3),
(45678901000104, 4),
(56789012000105, 5),
(67890123000106, 6),
(78901234000107, 7),
(89012345000108, 8),
(90123456000109, 9),
(12345670001234, 10);

-- Inserções para a Tabela Processo
INSERT INTO Processo (Data, Status, Tipo, Procedente, NaoProcedente, Tramitado, Julgado) VALUES
('2019-01-10', 'Ativo', 'Criminal', TRUE, FALSE, TRUE, TRUE),
('2020-05-15', 'Concluído', 'Civil', FALSE, TRUE, FALSE, TRUE),
('2021-03-22', 'Ativo', 'Trabalhista', FALSE, FALSE, TRUE, FALSE),
('2018-08-30', 'Concluído', 'Criminal', TRUE, FALSE, FALSE, TRUE),
('2017-12-05', 'Ativo', 'Civil', FALSE, TRUE, TRUE, FALSE),
('2016-04-18', 'Concluído', 'Trabalhista', FALSE, TRUE, FALSE, TRUE),
('2015-07-27', 'Ativo', 'Criminal', TRUE, FALSE, TRUE, FALSE),
('2014-11-03', 'Concluído', 'Civil', FALSE, TRUE, FALSE, TRUE),
('2013-06-19', 'Ativo', 'Trabalhista', FALSE, FALSE, TRUE, FALSE),
('2012-09-24', 'Concluído', 'Criminal', TRUE, FALSE, FALSE, TRUE);

-- Inserções para a Tabela Ficha
INSERT INTO Ficha (idIndividuo, idProcesso, Data, Status) VALUES
(1, 1, '2019-01-10', 'Ativo'),
(2, 2, '2020-05-15', 'Concluído'),
(3, 3, '2021-03-22', 'Ativo'),
(4, 4, '2018-08-30', 'Concluído'),
(5, 5, '2017-12-05', 'Ativo'),
(6, 6, '2016-04-18', 'Concluído'),
(7, 7, '2015-07-27', 'Ativo'),
(8, 8, '2014-11-03', 'Concluído'),
(9, 9, '2013-06-19', 'Ativo'),
(10, 10, '2012-09-24', 'Concluído');

-- Inserções para a Tabela Candidato
INSERT INTO Candidato (NumCandidato, idIndividuo, Nome) VALUES
(1, 1, 'João Silva'),
(2, 2, 'Maria Oliveira'),
(3, 3, 'Carlos Souza'),
(4, 4, 'Ana Pereira'),
(5, 5, 'Pedro Santos'),
(6, 6, 'Paula Lima'),
(7, 7, 'José Almeida'),
(8, 8, 'Rita Gonçalves'),
(9, 9, 'Ricardo Ramos'),
(10, 10, 'Fernanda Ferreira');

-- Inserções para a Tabela Partido
INSERT INTO Partido (Sigla, NAfiliados) VALUES
('ABC', 100),
('DEF', 150),
('GHI', 200),
('JKL', 250),
('MNO', 300),
('PQR', 350),
('STU', 400),
('VWX', 450),
('YZA', 500),
('BCD', 550);

-- Inserções para a Tabela Programa
INSERT INTO Programa (Descricao) VALUES
('Programa de Desenvolvimento Urbano'),
('Programa de Educação'),
('Programa de Saúde'),
('Programa de Segurança Pública'),
('Programa de Meio Ambiente'),
('Programa de Tecnologia'),
('Programa de Esporte'),
('Programa de Cultura'),
('Programa de Transporte'),
('Programa de Habitação');

-- Inserções para a Tabela Cargo
INSERT INTO Cargo (Cidade, Estado, Executivo, Legislativo) VALUES
('São Paulo', 'SP', TRUE, FALSE),
('Rio de Janeiro', 'RJ', TRUE, FALSE),
('Belo Horizonte', 'MG', TRUE, FALSE),
('Porto Alegre', 'RS', TRUE, FALSE),
('Curitiba', 'PR', TRUE, FALSE),
('Florianópolis', 'SC', TRUE, FALSE),
('Salvador', 'BA', TRUE, FALSE),
('Recife', 'PE', TRUE, FALSE),
('Fortaleza', 'CE', TRUE, FALSE),
('Brasília', 'DF', TRUE, FALSE);

-- Inserções para a Tabela Pleito
INSERT INTO Pleito (Data, QtdVotos, Vice) VALUES
('2023-10-01', 5000, 'Carlos Silva'),
('2023-10-02', 4500, 'Ana Oliveira'),
('2023-10-03', 4700, 'Pedro Santos'),
('2023-10-04', 4900, 'Maria Souza'),
('2023-10-05', 4800, 'Paulo Lima'),
('2023-10-06', 4600, 'José Pereira'),
('2023-10-07', 5300, 'Rita Almeida'),
('2023-10-08', 5200, 'Ricardo Gonçalves'),
('2023-10-09', 5400, 'Fernanda Ramos'),
('2023-10-10', 5500, 'João Ferreira');

-- Inserções para a Tabela Candidatura
INSERT INTO Candidatura (NumCandidato, idCargo, idPleito, SeElege) VALUES
(1, 1, 1, TRUE),
(2, 2, 2, TRUE),
(3, 3, 3, FALSE),
(4, 4, 4, TRUE),
(5, 5, 5, FALSE),
(6, 6, 6, TRUE),
(7, 7, 7, FALSE),
(8, 8, 8, TRUE),
(9, 9, 9, TRUE),
(10, 10, 10, FALSE);

-- Inserções para a Tabela DoacaoPJ
INSERT INTO DoacaoPJ (Data, Valor, NumCandidato, idDoador) VALUES
('2023-01-10', 1000.00, 1, 12345678000101),
('2023-02-15', 2000.00, 2, 23456789000102),
('2023-03-20', 1500.00, 3, 34567890000103),
('2023-04-25', 1800.00, 4, 45678901000104),
('2023-05-30', 1700.00, 5, 56789012000105),
('2023-06-05', 1600.00, 6, 67890123000106),
('2023-07-10', 1400.00, 7, 78901234000107),
('2023-08-15', 1300.00, 8, 89012345000108),
('2023-09-20', 1900.00, 9, 90123456000109),
('2023-10-25', 1200.00, 10, 12345670001234);

-- Inserções para a Tabela DoacaoPF
INSERT INTO DoacaoPF (Data, Valor, NumCandidato, idDoador) VALUES
('2023-01-11', 1100.00, 1, 12345678901),
('2023-02-16', 2100.00, 2, 23456789012),
('2023-03-21', 1600.00, 3, 34567890123),
('2023-04-26', 1900.00, 4, 45678901234),
('2023-05-31', 1800.00, 5, 56789012345),
('2023-06-06', 1700.00, 6, 67890123456),
('2023-07-11', 1500.00, 7, 78901234567),
('2023-08-16', 1400.00, 8, 89012345678),
('2023-09-21', 2000.00, 9, 90123456789),
('2023-10-26', 1300.00, 10, 12345098765);

-- Inserções para a Tabela Apoiador
INSERT INTO Apoiador (idIndividuo) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

-- Inserções para a Tabela Equipe de Apoio
INSERT INTO EquipeApoio (Nome) VALUES
('Equipe A'),
('Equipe B'),
('Equipe C'),
('Equipe D'),
('Equipe E'),
('Equipe F'),
('Equipe G'),
('Equipe H'),
('Equipe I'),
('Equipe J');

