USE formativaHogwarts; 

ALTER TABLE usuarios
ADD COLUMN foto text;

ALTER TABLE usuarios
ADD COLUMN num_phone int;

create table solicitantes (
id_solicitantes int ,
nome varchar(100),
primary key (id_solicitantes)
);

create table estatus(
id_status int ,
comentario varchar(100),
fotos varchar(100),
dta datetime,
estatus varchar(100), 
primary key (id_status)
);

 

create table tarefas(
id_tarefas int ,
descricao varchar(500),
prazo date,
dti date,
dtf date,
locais bigint,
solicitantes int,
responsaveis int,
estatus int,
primary key (id_tarefas),
FOREIGN KEY (locais) REFERENCES locais(id),
FOREIGN KEY (solicitantes) REFERENCES solicitantes(id_solicitantes),
FOREIGN KEY (estatus) REFERENCES estatus(id_status)
);

INSERT INTO solicitantes (id_solicitantes, nome)
VALUES (1, 'isabela'),
       (2, 'iago'),
       (3, 'eduardo');


INSERT INTO estatus (id_status, comentario, fotos, dta, estatus)
VALUES (1, 'fazer reuniao para marca o dia ', 'fotos1.jpg', NOW(), 'aberta' ),
       (2, 'esta em andamento porem tera atraso ', 'fotos2.jpg', NOW(), 'em andamento'),
	   (3, 'foi concluida', 'fotos2.jpg', NOW(), 'concluida'),
       (4, 'encerrada porem vamos ter que arrumar outra coisa', 'fotos3.jpg', NOW(), 'encerrada');


INSERT INTO tarefas (id_tarefas, descricao, prazo, dti, dtf, locais, solicitantes, responsaveis, estatus)
VALUES (1, 'Descrição Tarefa 1', '2023-06-10', '2023-05-30', NULL, 1, 1, 1, 1),
       (2, 'Descrição Tarefa 2', '2023-06-15', '2023-06-01', NULL, 2, 2, 2, 2),
       (3, 'Descrição Tarefa 3', '2023-06-20', '2023-06-05', NULL, 3, 3, 3, 3);
       
INSERT INTO tarefas (id_tarefas, descricao, prazo, dti, dtf, locais, solicitantes, responsaveis, estatus)
VALUES (4, 'Descrição Tarefa 1', '2023-06-10', '2023-05-30', NULL, 1, 2, 1, 2);
INSERT INTO tarefas (id_tarefas, descricao, prazo, dti, dtf, locais, solicitantes, responsaveis, estatus)
VALUES (5, 'Descrição Tarefa 1', '2023-06-10', '2023-05-30', NULL, 1, 3, 2, 3);

INSERT INTO tarefas (id_tarefas, descricao, prazo, dti, dtf, locais, solicitantes, responsaveis, estatus)
VALUES (6, 'Descrição Tarefa 1', '2023-06-10', '2023-05-30', NULL, 1, 3, 2, 4);


-- primeira
select t.id_tarefas, t.descricao, t.prazo, t.dti, t.dtf, s.nome as solicitante, u.nome as responsavel, e.comentario, e.fotos
from tarefas t
join solicitantes s on t.solicitantes = s.id_solicitantes
join usuarios u on t.responsaveis = u.id 
join estatus e on t.estatus = e.id_status
where t.dti is not null;

-- segunda

select l.id, l.nome, count(t.id_tarefas) as quantidade_tarefas
from locais l
join tarefas t on l.id = t.locais
group by l.id, l.nome
having count(t.id_tarefas) > 2;
  
  -- terceira 
  
select u.id, u.nome, count(t.id_tarefas) as quantidade_tarefas
from usuarios u
join tarefas t on u.id = t.responsaveis
group by u.id, u.nome
having count(t.id_tarefas) >= 2;
  
  -- quarta

select e.id, e.nome as nome_evento, t.id_tarefas, t.descricao
from eventos e
join locais l on e.localFK = l.id
left join tarefas t on l.id = t.locais and t.dtf is null
WHERE e.inicio > CURDATE();

  -- quinta 

select l.id, l.nome as nome_local, COUNT(t.id_tarefas) as quantidade_tarefas
from locais l
left join tarefas t on l.id = t.locais
group by l.id, l.nome;

  -- sexta

select l.id, l.nome as nome_local, COUNT(t.id_tarefas) as quantidade_tarefas_concluidas
from locais l
join tarefas t on l.id = t.locais
join estatus e on t.estatus = e.id_status
where e.id_status = 4
group by l.id, l.nome;

  -- decima

select u.id_usuarios, u.nome as nome_usuario, COUNT(t.id_tarefas) as quantidade_tarefas
from usuarios u
left join tarefas t on  u.id_usuarios = t.responsaveis
group by u.id_usuarios, u.nome;

  -- onze

select u.id, u.nome as nome_usuario, COUNT(t.id_tarefas) as quantidade_tarefas
from usuarios u
left join tarefas t on  u.id = t.responsaveis
group by u.id, u.nome;

  -- doze

select year(t.dti) as ano,month(t.dti) as mes,l.id as id_local,l.nome as nome_local,
avg(COUNT(t.id_tarefas)) as media_tarefas
from tarefas t
join locais l on t.locais = l.id
group by(t.dti), month(t.dti),l.id,l.nome;
