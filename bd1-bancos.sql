-- BD1 · Apostila da P2 · bancos de exemplo (PostgreSQL 12 ou mais novo)
-- Cada banco fica num esquema próprio, porque há nomes repetidos (PRE_REQUISITO).
-- Uso: psql -d <seu_banco> -f BD1_P2_bancos_exemplo.sql
-- Depois, escolha o banco com SET search_path, por exemplo:  SET search_path TO scott;
--   empresa  EMPRESA do Elmasri, nomes em português (Capítulo 3)
--   scott    Emp, Dept, Salgrade do Oracle (Capítulo 3)
--   fornec   F, P, FP: fornecedores e peças (Capítulo 3)
--   banco    BANCO do Korth (Capítulo 3)
--   univ     UNIVERSIDADE do Elmasri (Capítulo 3)
--   cursos   banco do simulado (Capítulo 21)
-- Rodar de novo apaga e recria tudo.


-- ==================== empresa ====================
DROP SCHEMA IF EXISTS empresa CASCADE;
CREATE SCHEMA empresa;
SET search_path TO empresa;

CREATE TABLE FUNCIONARIO (
  Pnome VARCHAR(15) NOT NULL, Minicial CHAR, Unome VARCHAR(15) NOT NULL,
  Cpf CHAR(11) NOT NULL, Datanasc DATE, Endereco VARCHAR(40), Sexo CHAR,
  Salario DECIMAL(10,2), Cpf_supervisor CHAR(11), Dnr INT NOT NULL,
  PRIMARY KEY (Cpf));
CREATE TABLE DEPARTAMENTO (
  Dnome VARCHAR(15) NOT NULL, Dnumero INT NOT NULL, Cpf_gerente CHAR(11) NOT NULL,
  Data_inicio_gerente DATE,
  PRIMARY KEY (Dnumero), UNIQUE (Dnome),
  FOREIGN KEY (Cpf_gerente) REFERENCES FUNCIONARIO(Cpf));
CREATE TABLE LOCALIZACAO_DEP (
  Dnumero INT NOT NULL, Dlocal VARCHAR(15) NOT NULL,
  PRIMARY KEY (Dnumero, Dlocal), FOREIGN KEY (Dnumero) REFERENCES DEPARTAMENTO(Dnumero));
CREATE TABLE PROJETO (
  Projnome VARCHAR(15) NOT NULL, Projnumero INT NOT NULL, Projlocal VARCHAR(15), Dnum INT NOT NULL,
  PRIMARY KEY (Projnumero), UNIQUE (Projnome), FOREIGN KEY (Dnum) REFERENCES DEPARTAMENTO(Dnumero));
CREATE TABLE TRABALHA_EM (
  Fcpf CHAR(11) NOT NULL, Pnr INT NOT NULL, Horas DECIMAL(3,1),
  PRIMARY KEY (Fcpf, Pnr), FOREIGN KEY (Fcpf) REFERENCES FUNCIONARIO(Cpf),
  FOREIGN KEY (Pnr) REFERENCES PROJETO(Projnumero));
CREATE TABLE DEPENDENTE (
  Fcpf CHAR(11) NOT NULL, Nome_dependente VARCHAR(15) NOT NULL, Sexo CHAR, Datanasc DATE, Parentesco VARCHAR(8),
  PRIMARY KEY (Fcpf, Nome_dependente), FOREIGN KEY (Fcpf) REFERENCES FUNCIONARIO(Cpf));
INSERT INTO FUNCIONARIO VALUES
('João','B','Silva','12345678966','1965-01-09','Rua das Flores, 751, São Paulo','M',30000,'33344555587',5),
('Fernando','T','Wong','33344555587','1955-12-08','Rua da Lapa, 34, São Paulo','M',40000,'88866555576',5),
('Alice','J','Zelaya','99988777767','1968-01-19','Rua Souza Lima, 35, Curitiba','F',25000,'98765432168',4),
('Jennifer','S','Souza','98765432168','1941-06-20','Av. Arthur de Lima, 54, Santo André','F',43000,'88866555576',4),
('Ronaldo','K','Lima','66688444476','1962-09-15','Rua Rebouças, 65, Piracicaba','M',38000,'33344555587',5),
('Joice','A','Leite','45345345376','1972-07-31','Av. Lucas Obes, 74, São Paulo','F',25000,'33344555587',5),
('André','V','Pereira','98798798733','1969-03-29','Rua Timbira, 35, São Paulo','M',25000,'98765432168',4),
('Jorge','E','Brito','88866555576','1937-11-10','Rua do Horto, 35, São Paulo','M',55000,NULL,1);
INSERT INTO DEPARTAMENTO VALUES ('Pesquisa',5,'33344555587','1988-05-22'),('Administração',4,'98765432168','1995-01-01'),('Matriz',1,'88866555576','1981-06-19');
ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_sup FOREIGN KEY (Cpf_supervisor) REFERENCES FUNCIONARIO(Cpf);
ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_dnr FOREIGN KEY (Dnr) REFERENCES DEPARTAMENTO(Dnumero);
INSERT INTO LOCALIZACAO_DEP VALUES (1,'São Paulo'),(4,'Mauá'),(5,'Santo André'),(5,'Itu'),(5,'São Paulo');
INSERT INTO PROJETO VALUES ('ProdutoX',1,'Santo André',5),('ProdutoY',2,'Itu',5),('ProdutoZ',3,'São Paulo',5),('Informatização',10,'Mauá',4),('Reorganização',20,'São Paulo',1),('Novosbenefícios',30,'Mauá',4);
INSERT INTO TRABALHA_EM VALUES ('12345678966',1,32.5),('12345678966',2,7.5),('66688444476',3,40.0),('45345345376',1,20.0),('45345345376',2,20.0),('33344555587',2,10.0),('33344555587',3,10.0),('33344555587',10,10.0),('33344555587',20,10.0),('99988777767',30,30.0),('99988777767',10,10.0),('98798798733',10,35.0),('98798798733',30,5.0),('98765432168',30,20.0),('98765432168',20,15.0),('88866555576',20,NULL);
INSERT INTO DEPENDENTE VALUES ('33344555587','Alicia','F','1986-04-05','Filha'),('33344555587','Tiago','M','1983-10-25','Filho'),('33344555587','Janaína','F','1958-05-03','Esposa'),('98765432168','Antonio','M','1942-02-28','Marido'),('12345678966','Michael','M','1988-01-04','Filho'),('12345678966','Alicia','F','1988-12-30','Filha'),('12345678966','Elizabeth','F','1967-05-05','Esposa');

-- ==================== scott ====================
DROP SCHEMA IF EXISTS scott CASCADE;
CREATE SCHEMA scott;
SET search_path TO scott;

CREATE TABLE DEPT
       (DEPTNO NUMERIC(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR(14) ,
	LOC VARCHAR(13) ) ;
CREATE TABLE EMP
       (EMPNO NUMERIC(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR(10),
	JOB VARCHAR(9),
	MGR NUMERIC(4),
	HIREDATE DATE,
	SAL NUMERIC(7,2),
	COMM NUMERIC(7,2),
	DEPTNO NUMERIC(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);
INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,'1981-2-20',1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,'1981-4-2',2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,'1981-9-28',1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,'1981-5-1',2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,'1981-6-9',2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,'1987-7-13',3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,'1981-9-8',1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,'1981-7-13',1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,'1981-12-3',950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,'1981-12-3',3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,'1981-1-23',1300,NULL,10);
CREATE TABLE BONUS
	(
	ENAME VARCHAR(10) primary key,
	JOB VARCHAR(9)  ,
	SAL NUMERIC,
	COMM NUMERIC
	) ;
CREATE TABLE SALGRADE
      ( GRADE NUMERIC Primary key,
	LOSAL NUMERIC,
	HISAL NUMERIC );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

alter table EMP add constraint EMPMGR_FK
     foreign key (MGR)
     references EMP On Delete Set Null On Update Cascade;
     
alter table BONUS drop column ENAME CASCADE;

alter table BONUS add column EMPNO NUMERIC(4) constraint BONUSEMPNO_PK primary key; 
alter table BONUS add constraint BONUSEMPNO_FK foreign key (EMPNO) references EMP On Delete Cascade On Update Cascade; 


-- ==================== fornec ====================
DROP SCHEMA IF EXISTS fornec CASCADE;
CREATE SCHEMA fornec;
SET search_path TO fornec;

CREATE TABLE F (Fnum CHAR(2) PRIMARY KEY, Fnome VARCHAR(20), Status INT, Cidade VARCHAR(20));
CREATE TABLE P (Pnum CHAR(2) PRIMARY KEY, Pnome VARCHAR(20), Cor VARCHAR(10), Peso NUMERIC(4,1), Cidade VARCHAR(20));
CREATE TABLE FP (Fnum CHAR(2) REFERENCES F, Pnum CHAR(2) REFERENCES P, Quantidade INT, PRIMARY KEY (Fnum, Pnum));
INSERT INTO F VALUES ('F1','José',20,'Campinas'),('F2','Paulo',10,'São Paulo'),('F3','João',30,'Rio de Janeiro');
INSERT INTO P VALUES ('P1','Porca','Vermelho',12.0,'Rio de Janeiro'),('P2','Pino','Verde',17.0,'São Paulo'),('P3','Parafuso','Azul',17.0,'Campinas'),('P4','Tubo','Vermelho',19.0,'Campinas');
INSERT INTO FP VALUES ('F1','P1',450),('F1','P2',700),('F1','P3',430),('F2','P1',300),('F2','P2',400),('F2','P3',200);

-- ==================== banco ====================
DROP SCHEMA IF EXISTS banco CASCADE;
CREATE SCHEMA banco;
SET search_path TO banco;

CREATE TABLE Agencia (Nome_Agencia VARCHAR(15) PRIMARY KEY, Cidade_Agencia VARCHAR(15), Ativo NUMERIC(12,2));
CREATE TABLE Cliente (Nome_Cliente VARCHAR(15) PRIMARY KEY, Rua_Cliente VARCHAR(20), Cidade_Cliente VARCHAR(15));
CREATE TABLE Conta (Numero_Conta CHAR(5) PRIMARY KEY, Nome_Agencia VARCHAR(15) REFERENCES Agencia, Saldo NUMERIC(10,2));
CREATE TABLE Dono_Conta (Nome_Cliente VARCHAR(15) REFERENCES Cliente, Numero_Conta CHAR(5) REFERENCES Conta, PRIMARY KEY (Nome_Cliente, Numero_Conta));
CREATE TABLE Emprestimo (Numero_Emprestimo CHAR(5) PRIMARY KEY, Nome_Agencia VARCHAR(15) REFERENCES Agencia, Valor NUMERIC(10,2));
CREATE TABLE Dono_Emprestimo (Nome_Cliente VARCHAR(15) REFERENCES Cliente, Numero_Emprestimo CHAR(5) REFERENCES Emprestimo, PRIMARY KEY (Nome_Cliente, Numero_Emprestimo));
INSERT INTO Agencia VALUES ('Downtown','Brooklyn',9000000),('Brighton','Brooklyn',7100000),('Redwood','Palo Alto',2100000),('Perryridge','Horseneck',1700000),('Mianus','Horseneck',400000),('Round Hill','Horseneck',8000000);
INSERT INTO Cliente VALUES ('Adams','Spring','Pittsfield'),('Curry','North','Rye'),('Hayes','Main','Harrison'),('Jackson','University','Salt Lake'),('Johnson','Alma','Palo Alto'),('Jones','Main','Harrison'),('Lindsay','Park','Pittsfield'),('Smith','North','Rye'),('Turner','Putnam','Stamford'),('Williams','Nassau','Princeton');
INSERT INTO Conta VALUES ('A-101','Downtown',500),('A-102','Perryridge',400),('A-201','Brighton',900),('A-215','Mianus',700),('A-217','Brighton',750),('A-222','Redwood',700),('A-305','Round Hill',350),('A-333','Perryridge',1500);
INSERT INTO Dono_Conta VALUES ('Johnson','A-101'),('Hayes','A-102'),('Johnson','A-201'),('Smith','A-215'),('Jones','A-217'),('Lindsay','A-222'),('Turner','A-305'),('Hayes','A-333'),('Williams','A-333');
INSERT INTO Emprestimo VALUES ('L-11','Round Hill',900),('L-14','Downtown',1500),('L-15','Perryridge',1500),('L-16','Perryridge',1300),('L-17','Downtown',1000),('L-23','Redwood',2000),('L-93','Mianus',500),('L-99','Perryridge',NULL);
INSERT INTO Dono_Emprestimo VALUES ('Smith','L-11'),('Jackson','L-14'),('Hayes','L-15'),('Adams','L-16'),('Jones','L-17'),('Williams','L-17'),('Smith','L-23'),('Curry','L-93');

-- ==================== univ ====================
DROP SCHEMA IF EXISTS univ CASCADE;
CREATE SCHEMA univ;
SET search_path TO univ;

CREATE TABLE ALUNO (Nome VARCHAR(20), Numero_aluno INT PRIMARY KEY, Tipo_aluno INT, Curso VARCHAR(4));
CREATE TABLE DISCIPLINA (Nome_disciplina VARCHAR(40), Numero_disciplina VARCHAR(8) PRIMARY KEY, Creditos INT, Departamento VARCHAR(4));
CREATE TABLE TURMA (Identificacao_turma INT PRIMARY KEY, Numero_disciplina VARCHAR(8) REFERENCES DISCIPLINA, Semestre VARCHAR(10), Ano INT, Professor VARCHAR(20));
CREATE TABLE HISTORICO_ESCOLAR (Numero_aluno INT REFERENCES ALUNO, Identificacao_turma INT REFERENCES TURMA, Nota CHAR(1), PRIMARY KEY (Numero_aluno, Identificacao_turma));
CREATE TABLE PRE_REQUISITO (Numero_disciplina VARCHAR(8) REFERENCES DISCIPLINA, Numero_pre_requisito VARCHAR(8) REFERENCES DISCIPLINA, PRIMARY KEY (Numero_disciplina, Numero_pre_requisito));
INSERT INTO ALUNO VALUES ('Silva',17,1,'CC'),('Braga',8,2,'CC');
INSERT INTO DISCIPLINA VALUES ('Introdução à Ciência da Computação','CC1310',4,'CC'),('Estruturas de Dados','CC3320',4,'CC'),('Matemática Discreta','MAT2410',3,'MAT'),('Banco de Dados','CC3380',3,'CC');
INSERT INTO TURMA VALUES (85,'MAT2410','Segundo',07,'King'),(92,'CC1310','Segundo',07,'Anderson'),(102,'CC3320','Primeiro',08,'Knuth'),(112,'MAT2410','Segundo',08,'Chang'),(119,'CC1310','Segundo',08,'Anderson'),(135,'CC3380','Segundo',08,'Stone');
INSERT INTO HISTORICO_ESCOLAR VALUES (17,112,'B'),(17,119,'C'),(8,85,'A'),(8,92,'A'),(8,102,'B'),(8,135,'A');
INSERT INTO PRE_REQUISITO VALUES ('CC3380','CC3320'),('CC3380','MAT2410'),('CC3320','CC1310');

-- ==================== cursos ====================
DROP SCHEMA IF EXISTS cursos CASCADE;
CREATE SCHEMA cursos;
SET search_path TO cursos;

CREATE TABLE CURSO (CodCurso VARCHAR(5) PRIMARY KEY, Titulo VARCHAR(40) NOT NULL, CargaHoraria INT);
CREATE TABLE PRE_REQUISITO (CodCurso VARCHAR(5) REFERENCES CURSO, CodCursoPre VARCHAR(5) REFERENCES CURSO, PRIMARY KEY (CodCurso, CodCursoPre));
CREATE TABLE OFERTA (CodCurso VARCHAR(5) REFERENCES CURSO, DataInicio DATE, Local VARCHAR(20), NumVagas INT, PRIMARY KEY (CodCurso, DataInicio));
CREATE TABLE EMPREGADO (NumMatricula VARCHAR(7) PRIMARY KEY, Nome VARCHAR(30), Departamento VARCHAR(20), Salario NUMERIC(10,2));
CREATE TABLE PROFESSOR (NumMatricula VARCHAR(7) PRIMARY KEY REFERENCES EMPREGADO);
CREATE TABLE ALUNO (NumMatricula VARCHAR(7) PRIMARY KEY REFERENCES EMPREGADO);
CREATE TABLE PODE_ENSINAR (NumMatricula VARCHAR(7) REFERENCES PROFESSOR, CodCurso VARCHAR(5) REFERENCES CURSO, PRIMARY KEY (NumMatricula, CodCurso));
CREATE TABLE MINISTRA (NumMatricula VARCHAR(7) REFERENCES PROFESSOR, CodCurso VARCHAR(5), DataInicio DATE,
  PRIMARY KEY (NumMatricula, CodCurso, DataInicio), FOREIGN KEY (CodCurso, DataInicio) REFERENCES OFERTA);
CREATE TABLE PARTICIPA (NumMatricula VARCHAR(7) REFERENCES ALUNO, CodCurso VARCHAR(5), DataInicio DATE, NumAusencias INT DEFAULT 0, Nota NUMERIC(4,2),
  PRIMARY KEY (NumMatricula, CodCurso, DataInicio), FOREIGN KEY (CodCurso, DataInicio) REFERENCES OFERTA);
INSERT INTO CURSO VALUES ('C10','Introdução à Computação',40),('C17','Lógica',30),('C20','Algoritmos',60),('C22','Bancos de Dados',60),('C30','Redes',40);
INSERT INTO PRE_REQUISITO VALUES ('C22','C17'),('C22','C20'),('C20','C10');
INSERT INTO OFERTA VALUES ('C10','2006-02-01','Sala 1',30),('C10','2006-05-02','Sala 1',30),('C10','2006-08-01','Sala 2',30),('C10','2007-02-01','Sala 1',30),
 ('C20','2006-03-01','Lab 1',20),('C22','2006-08-08','Lab 2',20),('C22','2007-03-05','Lab 2',20),('C30','2007-04-10','Sala 3',25);
INSERT INTO EMPREGADO VALUES ('1234587','Ana Souza','TI',9000),('1111111','Bruno Lima','RH',5000),('2222222','Carla Dias','TI',7000),('3333333','Davi Rocha','Vendas',4000),('4444444','Elisa Melo','TI',8000);
INSERT INTO PROFESSOR VALUES ('1234587'),('2222222'),('4444444');
INSERT INTO ALUNO VALUES ('1111111'),('2222222'),('3333333'),('4444444');
INSERT INTO PODE_ENSINAR VALUES ('1234587','C20'),('1234587','C22'),('1234587','C17'),('2222222','C10'),('4444444','C30'),('4444444','C22'),('4444444','C10');
INSERT INTO MINISTRA VALUES ('2222222','C10','2006-02-01'),('2222222','C10','2006-05-02'),('1234587','C22','2006-08-08'),('4444444','C30','2007-04-10'),('1234587','C20','2006-03-01');
INSERT INTO PARTICIPA VALUES ('1111111','C22','2006-08-08',1,8.5),('3333333','C22','2006-08-08',0,9.0),('2222222','C22','2006-08-08',2,9.0),('4444444','C20','2006-03-01',0,7.5),('3333333','C10','2006-02-01',0,6.0),('1111111','C30','2007-04-10',0,NULL);

SET search_path TO public;
