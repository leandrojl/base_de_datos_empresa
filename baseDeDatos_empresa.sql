create database if not exists empresa;

use empresa;

create table area(
cod_area int auto_increment primary key,
descripcion varchar(100) not null
);

create table especialidad(
cod_esp int auto_increment primary key,
descripcion varchar(100) not null
);

create table empleado(
nro int auto_increment primary key,
nombre varchar (50) not null,
cod_esp int not null,
nro_jefe int,
sueldo int not null,
f_ingreso date not null,
constraint fk_especialidad foreign key (cod_esp) references especialidad(cod_esp),
constraint fk_jefe foreign key (nro_jefe) references empleado(nro)
);

create table trabaja(
nro_emp int,
cod_area int,
constraint trabaja_pk primary key(nro_emp,cod_area),
constraint fk_empleado foreign key(nro_emp) references empleado(nro),
constraint fk_area foreign key(cod_area) references area(cod_area)
);

insert into area
(descripcion)
values ("Area 1"),("Area 2"),("Area 3");

insert into especialidad
(descripcion)
values ("Gerente"),("Operario"),("Administracion"),("Limpieza"),("Cocinero");

insert into empleado
(nombre, cod_esp, nro_jefe, sueldo,f_ingreso)
values ("Juan",1,null,10000,"2000-01-01");

insert into empleado
(nombre, cod_esp, nro_jefe, sueldo,f_ingreso)
values ("Pedro",2,1,5000,"2008-05-01");

insert into empleado
(nombre, cod_esp, nro_jefe, sueldo,f_ingreso)
values ("Daniel",2,1,2000,"2009-10-01"); 

insert into trabaja
(nro_emp,cod_area)
values (1,1),(1,2),(2,1),(3,2);

select * from area;
select * from empleado;
select * from trabaja;
select * from especialidad;

drop table empleado; /*tener cuidado con esta sentencia si no tengo el where*/
drop table especialidad;

ALTER TABLE trabaja
DROP FOREIGN KEY fk_cod_area;

ALTER TABLE empleado /*elimina la constraint/restriccion de una fk*/
DROP FOREIGN KEY fk_especialidad;

alter table empleado
drop foreign key fk_jefe;

alter table trabaja
drop foreign key fk_cod_area;

alter table trabaja
drop foreign key fk_empleado;

alter table trabaja add constraint fk_empleado foreign key (nro_emp) references empleado(nro);
alter table trabaja add constraint fk_area foreign key (cod_area) references area(cod_area);

ALTER TABLE empleado /*agrega una constraint/restriccion a la fk de la tabla*/
ADD CONSTRAINT fk_especialidad FOREIGN KEY (cod_esp)
REFERENCES especialidad(cod_esp);

show create table area; /*muestra la estructura y restricciones de la tabla*/
show create table empleado;
show create table especialidad;
show create table trabaja;

select * from area;
select * from especialidad;
select * from empleado;
select * from trabaja;

truncate table area; /*vacia los registros de la tabla y tambien restablece el contador del auto_increment a 0*/
truncate table empleado;

alter table area auto_increment = 0; /*Setea la pk auto_increment de la tabla nuevamente a 0*/

delete from area /*sintaxis para borrar varios registros*/
where cod_area in (6,7,8);

/*indicar la cantidad de empleados de la empresa*/


select count(e.nro) as cantidad_empleados
from empleado e
;

select count(*) as cantidad_empleados
from empleado;

/*indicar cantidad de empleados y sueldo maximo de la empresa*/

select count(*) as cantidad_de_empleados, max(sueldo)
from empleado;

/*cuantos ganan mas de 3000?*/

select em.nro as nro_pk,em.nombre as nombre, em.cod_esp as codigo_especialidad, esp.descripcion as especialidad
from empleado em
join especialidad esp on em.cod_esp = esp.cod_esp
where sueldo > 3000;

/*indicar el sueldo minimo de los empleados por cada codigo de especialidad*/

select esp.cod_esp as especialidad_pk, min(em.sueldo) as sueldo_minimo
from especialidad esp
join empleado em on esp.cod_esp = em.cod_esp
group by esp.cod_esp;

select cod_esp as codigo_especialidad_fk, min(sueldo) as sueldo_minimo
from empleado
group by cod_esp;

/*indicar el sueldo minimo de los empleados por cada codigo de especialidad, solo para aquellas especialidades cuyo minimo sea mayor a 3000*/

select * from empleado;

select em.cod_esp, min(em.sueldo)
from empleado em
group by em.cod_esp, em.sueldo
having min(em.sueldo) > 3000;

/*indicar el sueldo minimo de los empleados por cada codigo de especialidad, solo para aquellas especialidades con mas de 5 empleados*/

/*lista los nombres de los empledados que ganan el sueldo maximo*/

select em.nombre, em.sueldo
from empleado em
where sueldo =
(select max(em2.sueldo)
from empleado em2);

/*indicar la descripcion de aquellas areas sin empleados asignados*/

select * from area;
select * from especialidad;
select * from empleado;
select * from trabaja;

/**/

select a.descripcion
from area a
left join trabaja t on a.cod_area = t.cod_area /*left join completa con NULL cuando no encuentra el valor*/
where t.nro_emp is null;

select a.descripcion
from area a
join trabaja t on a.cod_area = t.cod_area /*por eso cuando busco solamente con JOIN no me devuelve nada ya que en la relacion N:N entre empleado y trabaja NO SE GUARDAN NULLS.*/
where t.nro_emp is null;

select a.descripcion
from area a
where not exists
(select 1
from trabaja t
where t.cod_area = a.cod_area);



