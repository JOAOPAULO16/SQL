create database meu_primeiro_SQL
go 
use meu_primeiro_SQL

create table paciente (
num_beneficiario int not null,
nome varchar(100) not null,
logradouro varchar(200) not null,
numero int not null,
cep char(8) not null,
complemento varchar(255) not null,
telefone varchar(11) not null
primary key(num_beneficiario)
)

create table especialidade(
id int not null,
especialidade varchar(100) not null
primary key(id)
)

create table medico(
codigo int not null,
nome varchar(100) not null,
logradouro varchar(200) not null,
numero int not null,
cep char(8) not null,
complemento varchar(255) not null,
contato varchar(11) not null,
especialidade_id int not null
primary key(codigo)
foreign key(especialidade_id)
	references especialidade(id)
)

create table consulta(
paciente_num_beneficiario int not null,
medico_codigo int not null,
data_hora timestamp not null,
observaçao varchar(255) not null
primary key (paciente_num_beneficiario, medico_codigo, data_hora)
foreign key (paciente_num_beneficiario)
	references paciente(num_beneficiario),
foreign key (medico_codigo)
	references medico(codigo)
)

insert into paciente (num_beneficiario, nome, logradouro, numero, cep, complemento, telefone)
values (99901, 'Washington Silva', 'R. Anhaia', 150, 02345000, 'Casa', 922229999),
(99902,'Luis Ricardo', 'R. Voluntários da Pátria', 2251, 03254010, 'Bloco B. Apto 25', 932450987),
(99903,'Maria Elisa', 'Av. Aguia de Haia', 1188, 06987020, 'Apto 1208', 912348765),
(99904,'José Araujo', 'R. XV de Novembro', 18, 0367800, 'Casa', 945674312),
(99905,'Joana Paula', 'R. 7 de Abril', 97, 01214000, 'Conjunto 3 - Apto 801', 912095675)

insert into medico (codigo, nome, logradouro, numero, cep, complemento, contato, especialidade_id)
values (100001, 'Ana Paula', 'R. 7 de Setembro', 256, 03698000, 'Casa', '915689456', 1),
(100002, 'Maria Aparecida', 'Av. Brasil', 32, 02140570, 'Casa', 923235454, 1),
(100003, 'Lucas Borges', 'Av. do Estado', 3210, 05241000, 'Apto 205', 96369585, 2),
(100004, 'Gabriel Oliveira', 'Av. Dom Helder Camara', 350, 03145000, 'Apto 602', 0932458745, 3)

insert into especialidade (id, especialidade)
values (1, 'Otorrinolaringologista'),
(2, 'Urologista'),
(3, 'Geriatra'),
(4, 'Pediatra')

insert into consulta(paciente_num_beneficiario, medico_codigo, data_hora, observaçao)
values (99901, 100002, '2021-09-04 13:20','Infecção Urina'),
(99902, 100003, '2021-09-04 13:15', 'Gripe'),
(99901, 100001, '2021-09-04 12:30', 'Infecção Garganta')

alter table medico
add dia_atendimento varchar(50) not null

update medico
set dia_atendimento = 'Segunda Feira'
where codigo = 100001,
set dia_atendimento = 'Quarta Feira'
where codigo = 100002,
set dia_atendimento = 'Segunda Feira'
where codigo = 100003,
set dia_atendimento = 'Quinta Feira'
where codigo = 100004

delete especialidade
where id = 4

exec sp_rename 'dbo.medico.dia_atendimento', 'dia_semana_atendimento'

update medico
set logradouro = 'Av. Bras Leme', numero = 876, complemento = 'apto 576', cep = 02122000
where id = 100003

alter table consulta
alter column observaçao varchar(200) not null