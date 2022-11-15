CREATE DATABASE sql_ddl_dml_2_v3
GO
USE sql_ddl_dml_2_v3
GO
CREATE TABLE cliente(
num_cadastro	INT				NOT NULL,
nome			VARCHAR(70)		NOT NULL,
logradouro		VARCHAR(150)	NOT NULL,
num				INT				NOT NULL	CHECK (num > 0),
cep				CHAR(8)			NULL		CHECK (LEN(cep) = 8)
PRIMARY KEY (num_cadastro)
)
GO
CREATE TABLE estrela(
id			INT			NOT NULL,
nome		VARCHAR(50) NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE filme(
id		INT			NOT NULL,
titulo	VARCHAR(40) NOT NULL,
ano		INT			NULL		CHECK (ano <= 2021)
PRIMARY KEY (id)
)
GO
CREATE TABLE filme_estrela(
filmeid			INT		NOT NULL,
estrelaid		INT		NOT NULL
PRIMARY KEY (filmeid,estrelaid) 
FOREIGN KEY(filmeid) REFERENCES filme(id),
FOREIGN KEY(estrelaid) REFERENCES estrela(id)
) 
GO
CREATE TABLE dvd(
num				INT		NOT NULL,
data_fabricacao DATE	NOT NULL	CHECK (data_fabricacao <= GETDATE()),
filmeid			INT		NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (filmeid) REFERENCES filme(id)
)
GO
CREATE TABLE locacao(
dvdnum				INT				NOT NULL,
clientenum_cadastro INT				NOT NULL,
data_locacao		DATE			NOT NULL	DEFAULT (GETDATE()),
data_devolucao		DATE			NOT NULL,
valor				DECIMAL(7, 2)	NOT NULL	CHECK (valor > 0.00),
CONSTRAINT chk_dt CHECK (data_devolucao > data_locacao),
PRIMARY KEY (dvdnum, clientenum_cadastro, data_locacao),
FOREIGN KEY(clientenum_cadastro) REFERENCES cliente(num_cadastro),
FOREIGN KEY(dvdnum) REFERENCES dvd(num),
)
GO
ALTER TABLE estrela
ADD nome_real	VARCHAR(50) NULL
GO
ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80)
GO
INSERT INTO cliente VALUES
(5501,'Matilde Luz','Rua Síria',150,'03086040'),
(5502,'Carlos Carreiro','Rua Bartolomeu Aires',1250,'04419110'),
(5503,'Daniel Ramalho','Rua Itajutiba',169,NULL),
(5504,'Roberta Bento','Rua Jayme Von Rosenburg',36,NULL),
(5505,'Rosa Cerqueira','Rua Arnaldo Simões Pinto',235,'02917110')
GO
INSERT INTO estrela VALUES
(9901,'Michael Keaton','Michael John Douglas'),
(9902,'Emma Stone','Emily Jean Stone'),
(9903,'Miles Teller',NULL),
(9904,'Steve Carell','Steven John Carell'),
(9905,'Jennifer Garner','Jennifer Anne Garner')
GO
INSERT INTO filme VALUES
(1001,'Whiplash',2015),
(1002,'Birdman',2015),
(1003,'Interestelar',2014),
(1004,'A Culpa é das estrelas',2014),
(1005,'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso',2014),
(1006,'Sing',2016)
GO
INSERT INTO filme_estrela VALUES
(1001,9903),
(1002,9901),
(1002,9902),
(1005,9904),
(1005,9905)
GO
INSERT INTO dvd VALUES
(10001,'2020-12-02',1001),
(10002,'2019-10-18',1002),
(10003,'2020-04-03',1003),
(10004,'2020-12-02',1001),
(10005,'2019-10-18',1004),
(10006,'2020-04-03',1002),
(10007,'2020-12-02',1005),
(10008,'2019-10-18',1002),
(10009,'2020-04-03',1003)
GO
INSERT INTO locacao VALUES
(10001,5501,'2021-02-24','2021-02-26',3.10),
(10001,5502,'2021-02-18','2021-02-21',3.25),
(10002,5503,'2021-02-18','2021-02-19',3.50),
(10002,5505,'2021-02-20','2021-02-23',3.00),
(10004,5505,'2021-02-20','2021-02-23',3.00),
(10005,5505,'2021-02-20','2021-02-23',3.00),
(10008,5501,'2021-02-24','2021-02-26',3.10),
(10009,5502,'2021-02-18','2021-02-21',3.25)
GO
UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503
GO
UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504
GO
UPDATE locacao
SET valor = 3.25
WHERE clientenum_cadastro = 5502 AND data_locacao = '2021-02-18'
GO
UPDATE locacao
SET valor = 3.10
WHERE clientenum_cadastro = 5501 AND data_locacao = '2021-02-24'
GO
UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE num = 10005
GO
UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'
GO
DELETE filme
WHERE titulo = 'Sing'

EXEC sp_help cliente
EXEC sp_help filme
EXEC sp_help estrela
EXEC sp_help filme_estrela
EXEC sp_help dvd
EXEC sp_help locacao

SELECT * FROM cliente
SELECT * FROM filme
SELECT * FROM estrela
SELECT * FROM filme_estrela
SELECT * FROM dvd
SELECT * FROM locacao

SELECT titulo
FROM filme 
WHERE ano = 2014

SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'

SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'

SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'

SELECT DISTINCT filmeid, CONVERT(CHAR(10),data_fabricacao,103) AS fab
FROM dvd
WHERE data_fabricacao >= '2020-01-01'

SELECT dvdnum, CONVERT(CHAR(10),data_locacao,103) AS data_locacao, 
	CONVERT(CHAR(10),data_devolucao,103) AS data_devolucao, 
	valor, valor + 2.00 AS valor_multa
FROM locacao
WHERE clientenum_cadastro = 5505

SELECT logradouro, num, cep
FROM cliente
WHERE nome = 'Matilde Luz'

SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'

SELECT num_cadastro, nome,
	logradouro + ',' + CAST(num AS VARCHAR(5)) + ' - CEP: '+ cep AS end_comp
FROM cliente
WHERE num_cadastro >= 5503 

SELECT id, ano, 
CASE WHEN LEN(titulo) = 10
THEN titulo 
ELSE SUBSTRING(titulo, 1, 10) + '...'
END AS titulo FROM filme
WHERE id IN 
(
	SELECT DISTINCT filmeid 
	FROM dvd
	WHERE data_fabricacao >= '2020-01-01'
)

SELECT num, data_fabricacao, 
DATEDIFF(MONTH, data_fabricacao, GETDATE()) 
AS qtd_meses_desde_a_fabricaçao FROM dvd
WHERE filmeid IN
(
	SELECT id 
	FROM filme
	WHERE titulo = 'Interestelar'
)

SELECT dvdnum, data_locacao, data_devolucao,
DATEDIFF(DAY, data_locacao, data_devolucao) 
AS dias_alugados
FROM locacao 
WHERE clientenum_cadastro IN
(
	SELECT num_cadastro
	FROM cliente
	WHERE nome LIKE '%Rosa%'
)

SELECT nome, logradouro + ', ' + CAST(num AS VARCHAR(5))
AS endereço_completo,
SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep
FROM cliente 
WHERE num_cadastro IN
(
	SELECT clientenum_cadastro
	FROM locacao
	WHERE dvdnum = 10002
)

SELECT cl.num_cadastro, cl.nome, CONVERT(CHAR(10), lo.data_locacao, 103) AS data_locaçao,
DATEDIFF(DAY, lo.data_locacao, lo.data_devolucao) AS qtdade_dias_alugados, fi.titulo, fi.ano
FROM cliente cl, locacao lo, filme fi, dvd
WHERE cl.num_cadastro = lo.clientenum_cadastro
	AND dvd.filmeid = fi.id
	AND dvd.num = lo.dvdnum
	AND nome LIKE 'Matilde%'

SELECT es.nome, es.nome_real, fi.titulo 
FROM estrela es, filme fi, filme_estrela fe
WHERE es.id = fe.estrelaid
	AND fi.id = fe.filmeid
	AND fi.ano = 2015

SELECT fi.titulo, CONVERT(CHAR(10), dvd.data_fabricacao, 103) AS data_fabricaçao,
CASE WHEN DATEDIFF(YEAR, fi.ano, GETDATE()) < 6
THEN DATEDIFF(YEAR, fi.ano, GETDATE()) + 'Anos'
ELSE DATEDIFF(YEAR, fi.ano, GETDATE())
END AS diferenca_anos
FROM filme fi, dvd
WHERE fi.id = dvd.filmeid

SELECT cl.num_cadastro, cl.nome, fi.id, dvd.data_fabricacao, lo.valor
FROM cliente cl, filme fi, dvd, locacao lo
WHERE cl.num_cadastro = lo.clientenum_cadastro
	AND dvd.filmeid = fi.id
	AND dvd.num = lo.dvdnum
	AND dvd.data_fabricacao IN
	(
		SELECT MAX(dvd.data_fabricacao)
		FROM dvd
	)
ORDER BY dvd.data_fabricacao

SELECT cl.num_cadastro, cl.nome, CONVERT(VARCHAR(10), lo.data_locacao, 103) AS dt_locacao, COUNT(lo.dvdnum) AS qtd_dvd_alugado
FROM cliente cl, locacao lo
WHERE cl.num_cadastro = lo.clientenum_cadastro
GROUP BY lo.data_locacao, cl.nome, cl.num_cadastro

SELECT cl.num_cadastro, cl.nome, CONVERT(VARCHAR(10), lo.data_locacao, 103) AS dt_locacao, SUM(valor) AS valor_total
FROM cliente cl, locacao lo
WHERE cl.num_cadastro = lo.clientenum_cadastro
GROUP BY lo.data_locacao, cl.nome, cl.num_cadastro

SELECT cl.num_cadastro, cl.nome, cl.logradouro + ', ' + CAST(cl.num AS VARCHAR) AS endereço, 
	CONVERT(VARCHAR(10), lo.data_locacao, 103) AS dt_locaçao
FROM cliente cl, locacao lo
WHERE cl.num_cadastro = lo.clientenum_cadastro
	AND lo.clientenum_cadastro IN
		(
			SELECT cl.num_cadastro
			FROM cliente cl, locacao lo, dvd, filme fi
			WHERE cl.num_cadastro = lo.clientenum_cadastro
				AND dvd.num = lo.dvdnum
				AND dvd.filmeid = fi.id
			GROUP BY cl.num_cadastro, lo.dvdnum
			HAVING SUM(dvd.filmeid) >= 2
		)
GROUP BY lo.data_locacao, cl.num_cadastro, cl.nome, cl.logradouro, cl.num