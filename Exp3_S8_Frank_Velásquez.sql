
-- CASO 1 - Parte 1: CREAR USUARIO CON PRIVILEGIOS
-- EJECUTAR CON: SYSTEM

ALTER SESSION SET "_Oracle_Script"=TRUE;

-- Eliminar usuarios
DROP USER PRY2205_USER1 CASCADE;
DROP USER PRY2205_USER2 CASCADE;

-- Eliminar roles
DROP ROLE PRY2205_ROL_D;
DROP ROLE PRY2205_ROL_P;

-- Crear usuarios
CREATE USER PRY2205_USER1 IDENTIFIED BY Password123
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

CREATE USER PRY2205_USER2 IDENTIFIED BY Password123
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

-- ESTRATEGIA DE SEGURIDAD (ROLES Y PRIVILEGIOS)

-- A) Rol Desarrollador (PRY2205_USER1)
CREATE ROLE PRY2205_ROL_D;

GRANT CREATE SESSION TO PRY2205_ROL_D;
GRANT CREATE TABLE TO PRY2205_ROL_D; 
GRANT CREATE VIEW TO PRY2205_ROL_D;
GRANT CREATE SYNONYM TO PRY2205_ROL_D;
GRANT CREATE PUBLIC SYNONYM TO PRY2205_ROL_D;
GRANT CREATE SEQUENCE TO PRY2205_ROL_D;
GRANT CREATE TRIGGER TO PRY2205_ROL_D;
GRANT CREATE PROCEDURE TO PRY2205_ROL_D;

-- B) Rol Programador (PRY2205_USER2)
CREATE ROLE PRY2205_ROL_P;
GRANT CREATE SESSION TO PRY2205_ROL_P;
GRANT CREATE TABLE TO PRY2205_ROL_P; 
GRANT CREATE SEQUENCE TO PRY2205_ROL_P;
GRANT CREATE TRIGGER TO PRY2205_ROL_P;
GRANT CREATE PROCEDURE TO PRY2205_ROL_P;

-- Asignar roles
GRANT PRY2205_ROL_D TO PRY2205_USER1;
GRANT PRY2205_ROL_P TO PRY2205_USER2;

ALTER USER PRY2205_USER1 DEFAULT ROLE PRY2205_ROL_D;
ALTER USER PRY2205_USER2 DEFAULT ROLE PRY2205_ROL_P;

COMMIT;


-- CASO 1 - Parte 2: POBLAR TABLAS
-- EJECUTAR CON: PRY2205_USER1


-- CAMBIAR A USUARIO PRY2205_USER1 PARA POBLAR TABLA

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/RRRR'; 

-- ELIMINACI?N DE TABLAS
DROP TABLE editorial CASCADE CONSTRAINTS;
DROP TABLE escuela CASCADE CONSTRAINTS;
DROP TABLE carrera CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE alumno CASCADE CONSTRAINTS;
DROP TABLE libro CASCADE CONSTRAINTS;
DROP TABLE autor CASCADE CONSTRAINTS;
DROP TABLE ejemplar CASCADE CONSTRAINTS;
DROP TABLE prestamo CASCADE CONSTRAINTS;
DROP TABLE VALOR_MULTA_PRESTAMO;
DROP TABLE DETALLE_PRESTAMO_MENSUAL;
DROP TABLE REBAJA_MULTA CASCADE CONSTRAINTS; 
DROP TABLE resumen_prestamo_mensual;
DROP TABLE ERROR_PROCESO_PRESTAMO CASCADE CONSTRAINTS;


-- CREACION DE TABLAS
CREATE TABLE AUTOR(
  libroid       NUMBER (5) NOT NULL,
  autorid        NUMBER (3) NOT NULL,
  nombre         VARCHAR2 (40) NOT NULL,
  apellidos      VARCHAR2 (40));
ALTER TABLE AUTOR ADD CONSTRAINT AUTOR_PK PRIMARY KEY (libroid,autorid);

CREATE TABLE CARRERA(
  carreraid   NUMBER (3) NOT NULL,
  descripcion VARCHAR2 (50) NOT NULL,
  escuelaid   NUMBER (3) NOT NULL);
ALTER TABLE CARRERA ADD CONSTRAINT CARRERA_PK PRIMARY KEY (carreraid);

CREATE TABLE EDITORIAL(
  editorialid NUMBER (3) NOT NULL,
  descripcion VARCHAR2 (30) NOT NULL);
ALTER TABLE EDITORIAL ADD CONSTRAINT EDITORIAL_PK PRIMARY KEY (editorialid);

CREATE TABLE EJEMPLAR(
  libroid   NUMBER (5) NOT NULL,
  ejemplarid VARCHAR2 (4) NOT NULL,
  ISBN       VARCHAR2 (20) NOT NULL);
ALTER TABLE EJEMPLAR ADD CONSTRAINT EJEMPLAR_PK PRIMARY KEY (ejemplarid,libroid);

CREATE TABLE EMPLEADO(
  empleadoid     NUMBER (3) NOT NULL,
  nombre         VARCHAR2 (20) NOT NULL,
  apaterno       VARCHAR2 (20) NOT NULL,
  amaterno       VARCHAR2 (20) NOT NULL,
  fecha_contrato DATE NOT NULL,
  salario        NUMBER (8) NOT NULL,
  jefeid         NUMBER (3));
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY (empleadoid);

CREATE TABLE ESCUELA(
  escuelaid   NUMBER (3) NOT NULL,
  descripcion VARCHAR2 (30) NOT NULL);
ALTER TABLE ESCUELA ADD CONSTRAINT ESCUELA_PK PRIMARY KEY (escuelaid);

CREATE TABLE alumno(
  alumnoid     NUMBER (3) NOT NULL,
  nombre           VARCHAR2 (20) NOT NULL,
  apaterno         VARCHAR2 (20) NOT NULL,
  amaterno         VARCHAR2 (20) NOT NULL,
  genero           VARCHAR2 (1),
  fecha_nacimiento DATE,
  carreraid        NUMBER (3) NOT NULL);
ALTER TABLE alumno ADD CONSTRAINT alumno_PK PRIMARY KEY (alumnoid);

CREATE TABLE PRESTAMO(
  prestamoid    NUMBER (5) NOT NULL,
  fecha_inicio  DATE NOT NULL,
  hora_inicio   VARCHAR2 (5) NOT NULL,
  fecha_termino DATE NOT NULL,
  hora_termino  VARCHAR2 (5) NOT NULL,
  fecha_entrega DATE,
  hora_entrega  VARCHAR2 (5),
  libroid      NUMBER (5) NOT NULL,
  ejemplarid    VARCHAR2 (4) NOT NULL,
  alumnoid  NUMBER (3) NOT NULL,
  empleadoid    NUMBER (3) NOT NULL);
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_PK PRIMARY KEY (prestamoid);

CREATE TABLE libro(
  libroid    NUMBER (5) NOT NULL,
  nombre_libro      VARCHAR2 (70) NOT NULL,
  publicacion NUMBER (4) NOT NULL,
  paginas     NUMBER (4) NOT NULL,
  precio      NUMBER (6),
  editorialid NUMBER (3));
ALTER TABLE libro ADD CONSTRAINT LIBRO_PK PRIMARY KEY (libroid);

CREATE TABLE VALOR_MULTA_PRESTAMO 
(cant_dias_ini   NUMBER(2) NOT NULL,
 cant_dias_ter   NUMBER(2) NOT NULL,
 valor_multa     NUMBER(7) NOT NULL); 
 ALTER TABLE VALOR_MULTA_PRESTAMO ADD CONSTRAINT PK_VALOR_MULTA_PRESTAMO PRIMARY KEY (cant_dias_ini);

CREATE TABLE REBAJA_MULTA
(carreraid   NUMBER (3) NOT NULL,
 porc_rebaja_multa NUMBER(2) NOT NULL);
ALTER TABLE REBAJA_MULTA ADD CONSTRAINT PK_REBAJA_MULTA PRIMARY KEY (carreraid);

CREATE TABLE DETALLE_PRESTAMO_MENSUAL 
(correlativo NUMBER(6) NOT NULL,
 fecha_proceso VARCHAR2(7) NOT NULL,
 prestamoid NUMBER (5) NOT NULL,
 libro VARCHAR2(100) NOT NULL,
 ejemplarid VARCHAR2 (4) NOT NULL,
 alumno VARCHAR2(100) NOT NULL,
 carrera VARCHAR2(100) NOT NULL,
 dias_atraso_devolucion NUMBER(5) NOT NULL,
 valor_multa NUMBER(10));
 ALTER TABLE DETALLE_PRESTAMO_MENSUAL  ADD CONSTRAINT PK_DET_PRESTAMO_MENSUAL PRIMARY KEY (correlativo,fecha_proceso);

CREATE TABLE resumen_prestamo_mensual
(correlativo NUMBER(5) NOT NULL,
 fecha_proceso VARCHAR2(7) NOT NULL,
 carrera VARCHAR2(50) NOT NULL,
 total_alumnos_carrera NUMBER NOT NULL,
 total_alumnos_solic_libro NUMBER(5) NOT NULL,
 total_devol_en_plazo NUMBER(3) NOT NULL,
 total_devol_fuera_plazo NUMBER(3) NOT NULL,
 valor_total_multa NUMBER(10) NOT NULL);
ALTER TABLE RESUMEN_PRESTAMO_MENSUAL  ADD CONSTRAINT PK_RESUMEN_PRESTAMO_MENSUAL PRIMARY KEY (correlativo,fecha_proceso);

CREATE TABLE ERROR_PROCESO_PRESTAMO
(correlativo NUMBER(5) NOT NULL,
 sentencia_error VARCHAR2(70) NOT NULL,
 mensaje_error VARCHAR2(200) NOT NULL);
ALTER TABLE ERROR_PROCESO_PRESTAMO  ADD CONSTRAINT PK_ERROR_PROCESO_PRESTAMO PRIMARY KEY (correlativo);

ALTER TABLE AUTOR ADD CONSTRAINT AUTOR_libro_FK FOREIGN KEY (libroid) REFERENCES libro (libroid);
ALTER TABLE CARRERA ADD CONSTRAINT CARRERA_ESCUELA_FK FOREIGN KEY (escuelaid) REFERENCES ESCUELA (escuelaid);
ALTER TABLE EJEMPLAR ADD CONSTRAINT EJEMPLAR_libro_FK FOREIGN KEY (libroid) REFERENCES libro (libroid);
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_EMPLEADO_FK FOREIGN KEY (jefeid) REFERENCES EMPLEADO (empleadoid);
ALTER TABLE alumno ADD CONSTRAINT alumno_CARRERA_FK FOREIGN KEY (carreraid) REFERENCES CARRERA (carreraid);
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_EJEMPLAR_FK FOREIGN KEY (ejemplarid,libroid) REFERENCES EJEMPLAR (ejemplarid,libroid);
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_EMPLEADO_FK FOREIGN KEY (empleadoid) REFERENCES EMPLEADO (empleadoid);
ALTER TABLE PRESTAMO ADD CONSTRAINT PRESTAMO_alumno_FK FOREIGN KEY (alumnoid) REFERENCES alumno (alumnoid);
ALTER TABLE libro ADD CONSTRAINT LIBRO_EDITORIAL_FK FOREIGN KEY (editorialid) REFERENCES EDITORIAL (editorialid);
ALTER TABLE REBAJA_MULTA ADD CONSTRAINT LFK_REBAJA_MULTA FOREIGN KEY (carreraid) REFERENCES CARRERA(carreraid);


-- POBLADO DE TABLAS
INSERT INTO VALOR_MULTA_PRESTAMO VALUES(1,3,2000);
INSERT INTO VALOR_MULTA_PRESTAMO VALUES(3,5,5000);
INSERT INTO VALOR_MULTA_PRESTAMO VALUES(7,9,8000);
INSERT INTO VALOR_MULTA_PRESTAMO VALUES(10,12,10000);
INSERT INTO VALOR_MULTA_PRESTAMO VALUES(13,99,20000);

INSERT INTO editorial VALUES(100,'Alfaomega');
INSERT INTO editorial VALUES(110,'Alianza');
INSERT INTO editorial VALUES(120,'Anaya');
INSERT INTO editorial VALUES(130,'Blume');
INSERT INTO editorial VALUES(140,'Bosch');
INSERT INTO editorial VALUES(150,'Ceac');
INSERT INTO editorial VALUES(160,'Cisco');
INSERT INTO editorial VALUES(170,'Deusto');
INSERT INTO editorial VALUES(180,'Fantastico');
INSERT INTO editorial VALUES(190,'Gedisa');
INSERT INTO editorial VALUES(200,'Gestion');
INSERT INTO editorial VALUES(210,'Graphis');
INSERT INTO editorial VALUES(220,'Gustavo gili');
INSERT INTO editorial VALUES(230,'Iortv');
INSERT INTO editorial VALUES(240,'Juridica de chile');
INSERT INTO editorial VALUES(250,'LexisNexis');
INSERT INTO editorial VALUES(260,'Lexus');
INSERT INTO editorial VALUES(270,'Limusa');
INSERT INTO editorial VALUES(280,'McGraw-Hill');
INSERT INTO editorial VALUES(290,'Medica panamericana');
INSERT INTO editorial VALUES(300,'Mediterraneo');
INSERT INTO editorial VALUES(310,'Oceano');
INSERT INTO editorial VALUES(320,'Paidos');
INSERT INTO editorial VALUES(330,'Paramon');
INSERT INTO editorial VALUES(340,'Paraninfo');
INSERT INTO editorial VALUES(350,'Pearson');
INSERT INTO editorial VALUES(360,'Piramide');
INSERT INTO editorial VALUES(370,'Planeta');
INSERT INTO editorial VALUES(380,'Prentice-Hall');
INSERT INTO editorial VALUES(390,'Reverte');


INSERT INTO escuela VALUES('10','Turismo');
INSERT INTO escuela VALUES('20','Salud');
INSERT INTO escuela VALUES('30','Ingenieria');
INSERT INTO escuela VALUES('40','Administracion');
INSERT INTO escuela VALUES('50','Informatica');
INSERT INTO escuela VALUES('60','Comunicacion');
INSERT INTO escuela VALUES('70','Diseno');
INSERT INTO escuela VALUES('80','Construccion');


INSERT INTO carrera VALUES(100,'Ing. en administracion',40);
INSERT INTO carrera VALUES(110,'Ing. en comercio exterior',40);
INSERT INTO carrera VALUES(120,'Ing. en marketing',40);
INSERT INTO carrera VALUES(130,'Comunicacion audiovisual',60);
INSERT INTO carrera VALUES(140,'Tec. audiovisual',60);
INSERT INTO carrera VALUES(150,'Tec. en sonido',60);
INSERT INTO carrera VALUES(160,'Publicidad',60);
INSERT INTO carrera VALUES(170,'Ing. en construccion',80);
INSERT INTO carrera VALUES(180,'Ing. en prevencion de riesgos',80);
INSERT INTO carrera VALUES(190,'Tec. en construccion',80);
INSERT INTO carrera VALUES(200,'Tec. en prevencion de riesgos',80);
INSERT INTO carrera VALUES(210,'Diseno grafico',70);
INSERT INTO carrera VALUES(220,'Diseno industrial',70);
INSERT INTO carrera VALUES(230,'Analista programador computacional',50);
INSERT INTO carrera VALUES(240,'Ing. en conectividad y redes',50);
INSERT INTO carrera VALUES(250,'Ing. en informatica',50);
INSERT INTO carrera VALUES(260,'Ing. en electricidad y automatizacion industrial',30);
INSERT INTO carrera VALUES(270,'Ing. en mecanica automotriz y autotronica',30);
INSERT INTO carrera VALUES(280,'Tec. en electricidad y automatizacion industrial',30);
INSERT INTO carrera VALUES(290,'Tec. en mecanica automotriz y autotronica',30);
INSERT INTO carrera VALUES(300,'Tec. de enfermeria',20);
INSERT INTO carrera VALUES(310,'Tec. de laboratorio clinico y banco de sangre',20);
INSERT INTO carrera VALUES(320,'Gastronomia',10);
INSERT INTO carrera VALUES(330,'Tec. en turismo y hoteleria',10);
INSERT INTO carrera VALUES(340,'Turismo de aventura',10);

INSERT INTO REBAJA_MULTA VALUES(180,6);
INSERT INTO REBAJA_MULTA VALUES(320,7);
INSERT INTO REBAJA_MULTA VALUES(160,4);
INSERT INTO REBAJA_MULTA VALUES(220,2);

INSERT INTO empleado VALUES(100,'Francisco','Fuentes','Gonzalez','05-03-1990',1500000,NULL);
INSERT INTO empleado VALUES(110,'Jose','Badilla','Leal','06-08-1990',1000000,100);
INSERT INTO empleado VALUES(120,'Ana','Rosario','Betanzo','03-04-1995',850000,100);
INSERT INTO empleado VALUES(130,'Blanca','Mendoza','Rojas','04-09-1995',750000,100);
INSERT INTO empleado VALUES(140,'Isidoro','Ordenes','Hormazabal','06-05-1996',750000,100);
INSERT INTO empleado VALUES(150,'Gregoria','Gonzalez','Castillo','05-03-1990',600000,110);
INSERT INTO empleado VALUES(160,'Santos','Reyes','Chavez','08-06-1998',600000,110);
INSERT INTO empleado VALUES(170,'Margarita','Cares','Urrutia','04-10-1999',600000,110);
INSERT INTO empleado VALUES(180,'Carlos','Mejias','Morales','13-03-2000',600000,110);
INSERT INTO empleado VALUES(190,'Gabriel','Vivallos','Riquelme','07-08-2000',600000,110);
INSERT INTO empleado VALUES(200,'Tania','Bahamondez','Perez','19-11-2001',600000,110);
INSERT INTO empleado VALUES(210,'Maria', 'Martinez','Hernandez','09-08-1990',280000,100);
INSERT INTO empleado VALUES(220,'Eduardo','Castillo','Castillo','05-09-1995',280000,210);
INSERT INTO empleado VALUES(230,'Viviana','Alarcon','Caceres','04-03-2002',280000,210);
INSERT INTO empleado VALUES(240,'Manuel','Aravena','Fuentealba','11-08-2003',280000,210);
INSERT INTO empleado VALUES(250,'Luis','Jara','Urbina','03-01-2005',450000,110);
INSERT INTO empleado VALUES(260,'Policarpo','Urrutia','Munoz','02-03-2010',450000,110);
INSERT INTO empleado VALUES(270,'Maureen','Hernandez','Zapata','11-02-2014',650000,110);
INSERT INTO empleado VALUES(280,'Maria','Beltran','Garcia','06-07-2015',650000,110);
INSERT INTO empleado VALUES(290,'Fidel','Chavarria','Pacheco','12-01-2015',350000,100);
INSERT INTO empleado VALUES(300,'Jose','Rocha','Lara','15-02-2016',350000,100);

INSERT INTO alumno VALUES(100,'Nora','Escobar','Montero','F','17-07-1997',340);
INSERT INTO alumno VALUES(101,'Jenoveva','Monares','Urrutia','F','24-04-1993',130);
INSERT INTO alumno VALUES(102,'Miguel','Diocares','Herrera','M','09-05-1997',160);
INSERT INTO alumno VALUES(103,'Maria','Gonzalez','Beltran','F','19-10-1992',300);
INSERT INTO alumno VALUES(104,'Jose','Echeverria','Munoz','M','17-04-1998',150);
INSERT INTO alumno VALUES(105,'Yasna','Diaz','Cisterna','F','19-01-1990',260);
INSERT INTO alumno VALUES(106,'Soledad','Perez','Gallejos','F','05-01-1993',190);
INSERT INTO alumno VALUES(107,'Jose','Zurita','Bustamante','M','15-01-1995',290);
INSERT INTO alumno VALUES(108,'Rosa','Beltran','Rodriguez','F','19-08-1992',200);
INSERT INTO alumno VALUES(109,'Prosperina','Quiroz','Valenzuela','F','30-11-1996',260);
INSERT INTO alumno VALUES(110,'Cecilia','Carrasco','Munoz','F','28-09-1998',230);
INSERT INTO alumno VALUES(111,'Marlene','Gutierrez','Vasquez','F','28-06-1992',230);
INSERT INTO alumno VALUES(112,'Bernardo','Inzunza','Sepulveda','M','15-04-1996',140);
INSERT INTO alumno VALUES(113,'Maria','Arroyo','Escobar','F','30-11-1990',240);
INSERT INTO alumno VALUES(114,'Olga','Navarrete','Paredes','F','03-02-1996',180);
INSERT INTO alumno VALUES(115,'Jose','Torres','Munoz','M','27-08-1995',320);
INSERT INTO alumno VALUES(116,'Cenobia','Marin','Valenzuela','F','28-10-1995',110);
INSERT INTO alumno VALUES(117,'Hugo','Suazo','Riquelme','M','02-02-1997',170);
INSERT INTO alumno VALUES(118,'Gladys','Beltran','Parra','F','21-08-1995',180);
INSERT INTO alumno VALUES(119,'Jerman','Escalona','Espinoza','M','26-08-1992',170);
INSERT INTO alumno VALUES(120,'Florencio','Suazo','Riquelme','M','15-08-1991',260);
INSERT INTO alumno VALUES(121,'Norma','Echeverria','Echevarria','F','21-11-1991',100);
INSERT INTO alumno VALUES(122,'Maria','Guinez','Munoz','F','27-09-1998',200);
INSERT INTO alumno VALUES(123,'Marina','Carrasco','Lopez','F','07-03-1994',290);
INSERT INTO alumno VALUES(124,'Honoria','Escobar','Valenzuela','F','28-11-1998',210);
INSERT INTO alumno VALUES(125,'Julia','Chavarria','Gutierrez','F','26-12-1996',140);
INSERT INTO alumno VALUES(126,'Veronica','Ormeno','Heredia','F','24-01-1997',170);
INSERT INTO alumno VALUES(127,'Sergio','Vasquez','Olate','M','30-11-1991',320);
INSERT INTO alumno VALUES(128,'Flor','Alvarez','Caceres','F','05-07-1992',160);
INSERT INTO alumno VALUES(129,'Berta','Gutierrez','Solar','F','03-11-1995',260);
INSERT INTO alumno VALUES(130,'Teresa','Rivas','Espinoza','F','27-11-1997',100);
INSERT INTO alumno VALUES(131,'Juan','Gutierrez','Jara','M','30-10-1997',250);
INSERT INTO alumno VALUES(132,'Maria','Araneda','Araneda','F','22-07-1998',260);
INSERT INTO alumno VALUES(133,'Maria','Lobos','Araneda','F','03-05-1994',210);
INSERT INTO alumno VALUES(134,'Marta','Osses','Tapia','F','30-01-1994',270);
INSERT INTO alumno VALUES(135,'Jeannette','Matamala','Arroyo','F','08-12-1994',240);
INSERT INTO alumno VALUES(136,'Ana','Zavala','Zavala','F','09-06-1991',290);
INSERT INTO alumno VALUES(137,'Martiniano','Quilodran','Hernandez','M','09-01-1991',230);
INSERT INTO alumno VALUES(138,'Olga','Belmar','Lamilla','F','29-06-1997',150);
INSERT INTO alumno VALUES(139,'Hugo','Munoz','Figueroa','F','25-02-1995',270);
INSERT INTO alumno VALUES(140,'Victor','Estrada','Porraz','M','27-02-1995',110);
INSERT INTO alumno VALUES(141,'Rebeca','Sanchez','Campos','F','02-01-1991',320);
INSERT INTO alumno VALUES(142,'Florencio','Villalobos','Constanzo','M','08-02-1990',240);
INSERT INTO alumno VALUES(143,'Adolfina','Sazo','Arroyo','F','06-05-1990',250);
INSERT INTO alumno VALUES(144,'Mirna','Soto','Echeverria','F','03-09-1992',170);
INSERT INTO alumno VALUES(145,'Jose','Bobadilla','Ortega','M','22-10-1992',280);
INSERT INTO alumno VALUES(146,'Jose','Figueroa','Castillo','M','20-03-1991',340);
INSERT INTO alumno VALUES(147,'Evarista','Riffo','Arroyo','F','07-08-1994',260);
INSERT INTO alumno VALUES(148,'Manuel','Munoz','Cabezas','M','20-05-1993',290);
INSERT INTO alumno VALUES(149,'Carmela','Osses','Ramirez','F','21-01-1990',110);
INSERT INTO alumno VALUES(150,'Marta','Valeria','Acuna','F','31-05-1991',180);
INSERT INTO alumno VALUES(151,'Maria','Sanchez','Cid','F','15-06-1996',170);
INSERT INTO alumno VALUES(152,'Luis','Diaz','Contreras','M','01-04-1998',340);
INSERT INTO alumno VALUES(153,'Rina','Lavin','Escobar','F','30-11-1992',260);
INSERT INTO alumno VALUES(154,'Ramon','Contreras','Toledo','M','06-03-1991',270);
INSERT INTO alumno VALUES(155,'Silda','Gutierrez','Vidal','F','15-08-1997',190);
INSERT INTO alumno VALUES(156,'Elia','Cifuentes','Cifuentes','F','03-10-1993',260);
INSERT INTO alumno VALUES(157,'Maria','Meza','Fonseca','F','19-09-1998',260);
INSERT INTO alumno VALUES(158,'Maria','Veloso','Burgos','F','24-12-1990',220);
INSERT INTO alumno VALUES(159,'Manuel','Martinez','Moreno','M','01-07-1991',290);
INSERT INTO alumno VALUES(160,'Maria','Montes','Bobadilla','F','03-12-1994',270);
INSERT INTO alumno VALUES(161,'Homero','Gonzalez','Sanhueza','M','29-10-1990',150);
INSERT INTO alumno VALUES(162,'Sonia','Gutierrez','Pedraza','F','07-06-1992',340);
INSERT INTO alumno VALUES(163,'Eliana','Liempi','Liempi','F','22-01-1997',110);
INSERT INTO alumno VALUES(164,'Claudia','Inzunza','Bravo','F','14-01-1998',120);
INSERT INTO alumno VALUES(165,'Eliana','Sepulveda','Pena','F','02-06-1997',170);
INSERT INTO alumno VALUES(166,'Hector','Castillo','Castillo','M','04-08-1993',300);
INSERT INTO alumno VALUES(167,'Monica','Sepulveda','Carrasco','F','16-07-1992',130);
INSERT INTO alumno VALUES(168,'Texia','Pena','Gutierrez','F','27-11-1993',320);
INSERT INTO alumno VALUES(169,'Maria','Rivera','Soto','F','07-07-1995',140);
INSERT INTO alumno VALUES(170,'Maria','Alarcon','Sepulveda','F','20-07-1991',120);
INSERT INTO alumno VALUES(171,'Elba','Castillo','Castillo','F','16-11-1996',270);
INSERT INTO alumno VALUES(172,'Juan','Saavedra','Echeverria','M','21-06-1996',260);
INSERT INTO alumno VALUES(173,'Silvia','Cabezas','Lopez','F','30-03-1996',330);
INSERT INTO alumno VALUES(174,'Prosperina','Figueroa','Becar','F','17-11-1990',330);
INSERT INTO alumno VALUES(175,'Jose','Romero','Romero','M','30-06-1995',120);
INSERT INTO alumno VALUES(176,'Maria','Cabezas','Arroyo','F','17-04-1996',320);
INSERT INTO alumno VALUES(177,'Ana','Cisterna','Navarro','F','28-02-1993',260);
INSERT INTO alumno VALUES(178,'Petronila','Escobar','Montero','F','13-04-1993',320);
INSERT INTO alumno VALUES(179,'Alfredo','Medina','Montero','M','06-08-1997',250);
INSERT INTO alumno VALUES(180,'Rosa','Parra','Fonseca','F','08-05-1993',340);
INSERT INTO alumno VALUES(181,'Manuel','Aravena','Bobadilla','M','28-12-1991',150);
INSERT INTO alumno VALUES(182,'Rosa','Cardenas','Moreno','F','06-02-1995',130);
INSERT INTO alumno VALUES(183,'Nelly','Morales','Araneda','F','17-03-1998',330);
INSERT INTO alumno VALUES(184,'Sergio','Hernandez','Zapata','M','11-10-1996',100);
INSERT INTO alumno VALUES(185,'Norma','Araneda','Araneda','F','04-03-1991',280);
INSERT INTO alumno VALUES(186,'Jose','Constanzo','Caceres','M','04-08-1996',160);
INSERT INTO alumno VALUES(187,'Juan','Medina','Medina','M','19-05-1996',270);
INSERT INTO alumno VALUES(188,'Silvio','Pena','Gutierrez','M','08-07-1991',240);
INSERT INTO alumno VALUES(189,'Luisa','Chavarria','Mella','F','08-04-1997',300);
INSERT INTO alumno VALUES(190,'Jorge','Munoz','Lara','M','29-05-1991',190);
INSERT INTO alumno VALUES(191,'Fidelina','Sepulveda','Vega','F','10-04-1992',290);
INSERT INTO alumno VALUES(192,'Nelly','Torres','Sanhueza','F','09-01-1994',150);
INSERT INTO alumno VALUES(193,'Gladys','Gonzalez','Cabezas','F','04-02-1992',100);
INSERT INTO alumno VALUES(194,'Julia','Del Sobarzo','Ortiz','F','19-10-1995',110);
INSERT INTO alumno VALUES(195,'Gerardo','Gonzalez','Bonta','M','15-05-1996',110);
INSERT INTO alumno VALUES(196,'Jose','Vasquez','Parra','M','23-01-1993',100);
INSERT INTO alumno VALUES(197,'Irma','Garcia','Perez','F','28-01-1994',110);
INSERT INTO alumno VALUES(198,'Hector','Inzunza','Quevedo','M','02-05-1993',240);
INSERT INTO alumno VALUES(199,'Rene','Hernandez','Amestica','M','29-11-1993',200);


INSERT INTO libro VALUES(54210,'Relaciones humanas un enfoque moderno',2010,201,145485,240);
INSERT INTO libro VALUES(72891,'Auditoria y control interno',2004,200,274130,300);
INSERT INTO libro VALUES(67087,'Plan de marketing: paso a paso',2001,200,385943,390);
INSERT INTO libro VALUES(54814,'Estadistica para las ciencias administrativas',2001,200,295957,350);
INSERT INTO libro VALUES(97148,'Investigacion de mercados: un enfoque aplicado',2002,200,380310,150);
INSERT INTO libro VALUES(83467,'Diccionario de economia y empresa',2001,200,154099,200);
INSERT INTO libro VALUES(20264,'Visual merchandising and display',2000,200,169685,280);
INSERT INTO libro VALUES(92252,'Gestion de proyectos',2002,200,249387,280);
INSERT INTO libro VALUES(20008,'Logostica de distribucion fisica internacional',2003,200,256700,340);
INSERT INTO libro VALUES(87181,'Estado de flujo de caja',2001,200,170222,350);
INSERT INTO libro VALUES(13244,'Marketing en sectores especificos',2003,200,105403,370);
INSERT INTO libro VALUES(53335,'Gestion administrativa para empresas',2001,689,178134,280);
INSERT INTO libro VALUES(75010,'Imagenes de la organizacion',2000,200,373237,280);
INSERT INTO libro VALUES(85666,'Economia principios y problemas',2002,200,199553,370);
INSERT INTO libro VALUES(92022,'Economia del ocio y el turismo',2003,200,152207,370);
INSERT INTO libro VALUES(57596,'Bandas sonoras',2001,200,124199,300);
INSERT INTO libro VALUES(25636,'El uso de los microfonos',2001,200,226623,100);
INSERT INTO libro VALUES(90140,'Direccion de cine y video: tecnica y estatica',2002,200,366296,230);
INSERT INTO libro VALUES(49893,'Como convertir un buen guion en un guion excelente',2004,200,149137,310);
INSERT INTO libro VALUES(49941,'Equipos de sonido casetes, CD audio y amplificadores',2003,200,299788,320);
INSERT INTO libro VALUES(61196,'El documental: la otra cara del cine',2001,200,331399,340);
INSERT INTO libro VALUES(27404,'Television y patrocinio',2003,200,369218,340);
INSERT INTO libro VALUES(90938,'La television economica financiacion, estrategias y mercados',2007,200,155600,350);
INSERT INTO libro VALUES(79260,'Estatica y psicologia del cine',2001,200,276185,350);
INSERT INTO libro VALUES(49409,'La pelicula y el laboratorio cinematografico',2008,200,285006,370);
INSERT INTO libro VALUES(87450,'Sonido esterofonico para television',2006,200,378448,100);
INSERT INTO libro VALUES(38018,'El cine documental segun Patricio Guzman ',2001,200,387170,380);
INSERT INTO libro VALUES(32329,'Edicion de video con Avid',2001,200,294080,370);
INSERT INTO libro VALUES(62470,'Algebra',2005,200,172279,360);
INSERT INTO libro VALUES(32458,'Fisica conceptual',2004,200,154462,220);
INSERT INTO libro VALUES(19056,'Estadistica elemental',2001,200,268526,350);
INSERT INTO libro VALUES(76042,'Geometria descriptiva aplicada',2004,200,333097,220);
INSERT INTO libro VALUES(23062,'Comunicacion oral argumentativa: estrategias didacticas',2008,200,298321,390);
INSERT INTO libro VALUES(24385,'Compactacion del concreto: ACI 309 R-96',2002,87,85670,140);
INSERT INTO libro VALUES(24638,'Como interpretar un plano',2000,39,342946,140);
INSERT INTO libro VALUES(58114,'Manual de maquinaria de construccion',2000,200,327082,280);
INSERT INTO libro VALUES(89348,'Diseno urbano: teoria y metodo',2000,200,106218,150);
INSERT INTO libro VALUES(65922,'Nueva enciclopedia del encargado de obras',2003,200,169859,200);
INSERT INTO libro VALUES(36969,'Manual de tratamiento de aguas',2002,200,352074,220);
INSERT INTO libro VALUES(84029,'NCh 170 Of.1985: Hormigon: requisitos generales',2002,200,158345,280);
INSERT INTO libro VALUES(11976,'Hormigon armado',2000,396,346875,280);
INSERT INTO libro VALUES(20223,'Estimacion de los costos de construccion',2004,200,269189,350);
INSERT INTO libro VALUES(63249,'Edificios residenciales',2002,200,120606,370);
INSERT INTO libro VALUES(24766,'Manual del instalador electricista',2009,200,395711,280);
INSERT INTO libro VALUES(37349,'Instalaciones de ventilacion y climatizacion',2004,200,314181,280);
INSERT INTO libro VALUES(65070,'Como disenar un tipo',2000,49,127716,140);
INSERT INTO libro VALUES(20475,'La formacion por el arte y la literatura',2011,201,102039,120);
INSERT INTO libro VALUES(46192,'Teoria del color',2004,200,345700,120);
INSERT INTO libro VALUES(63326,'Design in steel',2004,200,145149,130);
INSERT INTO libro VALUES(79562,'Diseno inspirado en la naturaleza',2001,200,132595,150);
INSERT INTO libro VALUES(94153,'Blow molding design guide',2004,200,351888,170);
INSERT INTO libro VALUES(96472,'Publicidad y Diseno: las claves del exito',2004,200,394531,220);
INSERT INTO libro VALUES(25955,'Fotografia digital',2000,200,265538,220);
INSERT INTO libro VALUES(88806,'Manipula tus fotografias digitales con Photoshop CS4',2012,201,238771,280);
INSERT INTO libro VALUES(89870,'Graphis Advertising annual',2000,180,383087,280);
INSERT INTO libro VALUES(37333,'Como construir muebles por elementos',2001,200,374948,310);
INSERT INTO libro VALUES(11611,'El diseno tridimensional del boceto a la pantalla',2008,200,101004,340);
INSERT INTO libro VALUES(84772,'Exprime la fotografia digital',2000,200,307724,350);
INSERT INTO libro VALUES(94706,'Tipografia funcion, forma y diseno',2007,270,355136,210);
INSERT INTO libro VALUES(69767,'Fotografia publicitaria',2005,200,130249,220);
INSERT INTO libro VALUES(16799,'Developing products in half the time new rules, new tools',2000,200,396315,270);
INSERT INTO libro VALUES(85273,'Historia de los colores',2000,200,278051,280);
INSERT INTO libro VALUES(50495,'La ampliacion la tecnica del positivo fotografica',2008,200,216288,380);
INSERT INTO libro VALUES(93335,'El lenguaje fotografico',2004,200,101200,380);
INSERT INTO libro VALUES(44459,'Dilemas eticos de la empresa contemporanea',2002,200,117968,200);
INSERT INTO libro VALUES(44359,'Cocina francesa',2007,89,283253,240);
INSERT INTO libro VALUES(42892,'Marketing creativo: para el servicio de comidas',2008,200,392816,190);
INSERT INTO libro VALUES(40600,'Vino guias gastronomicas',2001,200,380410,350);
INSERT INTO libro VALUES(28808,'Autocad 2000: avanzado',2011,201,324708,290);
INSERT INTO libro VALUES(60177,'CCNP Tshoot 642-832: official certification guide',2001,200,234701,370);
INSERT INTO libro VALUES(87795,'Manual fundamental Word 2000',2007,200,328434,180);
INSERT INTO libro VALUES(35283,'Manual avanzado de Windows 7',2005,320,177245,250);
INSERT INTO libro VALUES(32211,'CCNP switch: Portable Command Guide',2002,200,140078,370);
INSERT INTO libro VALUES(32212,'CCNP switch: Portable Command Guide',2002,200,140078,370);
INSERT INTO libro VALUES(27805,'Guia rapida: Powerpoint Office 2003',2000,200,306761,280);
INSERT INTO libro VALUES(27472,'Color para sitios Web',2003,200,206324,110);
INSERT INTO libro VALUES(14975,'Diseno y usabilidad de aplicaciones IPhone',2002,200,225203,150);
INSERT INTO libro VALUES(36581,'Dreamweaver MX edicion especial',2001,200,291753,150);
INSERT INTO libro VALUES(47614,'Dibujos animados con Flash',2001,200,257230,190);
INSERT INTO libro VALUES(12221,'Microsoft SQL server 7.0 al descubierto',2002,200,46700,200);
INSERT INTO libro VALUES(37353,'Fundamentos de informatica',2001,200,232344,220);
INSERT INTO libro VALUES(87474,'El lenguaje de programacion Visual Basic.Net',2000,200,399533,340);
INSERT INTO libro VALUES(89543,'El kernel 2.4 de linux',2000,200,305717,340);
INSERT INTO libro VALUES(10926,'CCNP switch 642-813: official certification guide',2001,200,170909,370);
INSERT INTO libro VALUES(50687,'Comunicacion entre computadoras',2004,200,259121,390);
INSERT INTO libro VALUES(71094,'Microsoft SQL server 2008 R2: Curso practico',2001,200,367440,100);
INSERT INTO libro VALUES(39000,'Programacion de automatas industriales OMRON',2005,200,211419,100);
INSERT INTO libro VALUES(39527,'Etiqueta social: preguntas y respuestas',2003,200,350624,350);
INSERT INTO libro VALUES(36095,'Excel 2010: los mejores trucos',2000,200,287111,350);
INSERT INTO libro VALUES(20866,'El libro de Windows 7',2005,200,336390,380);
INSERT INTO libro VALUES(55314,'Sistemas industriales accionados por aire comprimido',2012,201,296383,220);
INSERT INTO libro VALUES(57145,'Probabilidad y estadistica para ingenieros',2003,200,338602,230);
INSERT INTO libro VALUES(58047,'Diseno de elementos de maquinas',2002,200,271028,230);
INSERT INTO libro VALUES(93214,'Elementos de resistencia de materiales',2002,200,144674,320);
INSERT INTO libro VALUES(17678,'Circuitos electricos',2003,96,181202,330);
INSERT INTO libro VALUES(61393,'Circuitos logicos programables',2004,200,345900,160);
INSERT INTO libro VALUES(22381,'El curioso caso de Benjamin Button',2001,200,224479,380);
INSERT INTO libro VALUES(33533,'Sistemas auxiliares del motor',2004,200,245143,360);
INSERT INTO libro VALUES(65525,'Farmacologia en enfermeria',2002,200,146147,120);
INSERT INTO libro VALUES(74191,'Manual de microbiologia clinica',2002,200,211222,150);
INSERT INTO libro VALUES(15480,'Materiales dentales',2008,200,137010,360);
INSERT INTO libro VALUES(59841,'El problema del dolor',2002,200,125239,100);
INSERT INTO libro VALUES(49129,'Contabilidad hotelera',2001,200,192148,250);
INSERT INTO libro VALUES(36677,'El turismo: fenomeno social',2007,200,334602,100);
INSERT INTO libro VALUES(52276,'Promocion turistica: un enfoque metodologico',2012,201,116737,120);
INSERT INTO libro VALUES(64233,'Psicosociologia del turismo',2006,200,115023,130);
INSERT INTO libro VALUES(55518,'Estructura del mercado turistico',2001,200,397929,350);
INSERT INTO libro VALUES(49476,'Historia contemporanea de America Latina',2001,200,248415,280);
INSERT INTO libro VALUES(19328,'Informacion turistica en destino',2008,200,87600,280);
INSERT INTO libro VALUES(53290,'Las regiones de Chile: espacio fisico, humano y economico',2009,200,271149,270);
INSERT INTO libro VALUES(90247,'Tecnologia de la construccion',2003,96,166314,130);
INSERT INTO libro VALUES(35653,'La definicion del arte',2000,200,251667,340);
INSERT INTO libro VALUES(78870,'Red Hat Linux 7',2011,201,366587,370);
INSERT INTO libro VALUES(69711,'Ubuntu Linux',2000,200,319349,120);
INSERT INTO libro VALUES(13733,'Principios basicos de auditoria',2011,201,206974,320);
INSERT INTO libro VALUES(51022,'Arquitectura en guarderias: innovacion y diseno',2012,201,263594,350);
INSERT INTO libro VALUES(93714,'El gran libro de las puertas',2004,200,59800,340);
INSERT INTO libro VALUES(52611,'Metodologia en el turismo',2012,201,134184,350);
INSERT INTO libro VALUES(81222,'No mas normas: diseno grafico y posmoderno',2010,201,243652,120);
INSERT INTO libro VALUES(46363,'Terminologia del concreto: ACI 116 R-90',2006,480,155798,220);
INSERT INTO libro VALUES(36988,'La produccion cinematografica',2008,200,306940,380);
INSERT INTO libro VALUES(95098,'La practica del montaje',2009,406,338946,290);
INSERT INTO libro VALUES(23060,'Encendido electronico',2010,201,292603,320);
INSERT INTO libro VALUES(22764,'Tratado sobre automoviles',2004,200,367646,370);
INSERT INTO libro VALUES(47827,'ISO 9000 en empresas de servicios',2004,200,280326,110);
INSERT INTO libro VALUES(26836,'Rapa Nui: Paisajes y vida silvestre',2007,200,185081,220);
INSERT INTO libro VALUES(95268,'Manual imprescindible de Flash CS3',2011,201,192295,120);
INSERT INTO libro VALUES(94738,'El gran libro de la herreria',2000,200,129157,340);
INSERT INTO libro VALUES(78749,'Probabilidad y estadistica para ingenieros',2009,200,252371,260);
INSERT INTO libro VALUES(28076,'Preparacion y evaluacion de proyectos',2010,201,134283,260);
INSERT INTO libro VALUES(37873,'Logistica y turismo',2009,200,222424,120);
INSERT INTO libro VALUES(38303,'Restauracion y rehabilitacion de edificios',2011,255,157609,340);
INSERT INTO libro VALUES(67347,'La publicidad estrategica',2011,201,379485,120);
INSERT INTO libro VALUES(66253,'Indesign CS5',2010,201,104168,120);
INSERT INTO libro VALUES(66776,'Tecnicas de presentacion para el artista grafico',2008,200,134668,350);
INSERT INTO libro VALUES(88904,'Las vitaminas su importancia en la alimentacion',2011,201,197360,340);
INSERT INTO libro VALUES(45190,'Microsoft SQL server 2000: edicion especial',2012,201,259376,120);
INSERT INTO libro VALUES(72577,'La electronica en el automovil',2008,200,394311,220);
INSERT INTO libro VALUES(18624,'Instalaciones electricas',2011,201,376627,220);
INSERT INTO libro VALUES(64546,'Maquetas virtuales de arquitectura',2009,200,245394,120);
INSERT INTO libro VALUES(95583,'Transmision de datos y redes de comunicaciones',2008,200,325660,330);
INSERT INTO libro VALUES(83393,'Video digital: edicion 2009',2013,201,254602,120);
INSERT INTO libro VALUES(80820,'Realismo',2007,200,35600,220);
INSERT INTO libro VALUES(67222,'La fuerza de la publicidad',2007,200,169245,380);
INSERT INTO libro VALUES(48600,'Toda la gastronomia de la A a la Z',2011,201,221378,120);
INSERT INTO libro VALUES(91167,'Turismo, hoteleria y restaurantes',2009,200,180093,120);
INSERT INTO libro VALUES(56092,'Contabilidad de costos',2007,200,183993,390);
INSERT INTO libro VALUES(52083,'Parking: manual del diseno ambiental',2004,200,137008,280);
INSERT INTO libro VALUES(97187,'Indesign CS2: tecnicas esenciales',2013,201,245791,120);
INSERT INTO libro VALUES(68031,'Marketing en el punto de venta',2005,200,232427,370);
INSERT INTO libro VALUES(78179,'Marketing con redes sociales',2007,200,354362,280);


INSERT INTO autor VALUES(10926,1,'David','Hucaby');
INSERT INTO autor VALUES(11611,1,'Jose','Roldan Viloria');
INSERT INTO autor VALUES(11976,1,'Daniel','Burgos');
INSERT INTO autor VALUES(12221,1,'Antonio','Drudis');
INSERT INTO autor VALUES(13244,1,'Fernando','Martinez Dominguez');
INSERT INTO autor VALUES(13733,1,'Jean','Breschand');
INSERT INTO autor VALUES(14975,1,'Josh','Clark');
INSERT INTO autor VALUES(15480,1,'Ricardo','Macchi');
INSERT INTO autor VALUES(16799,1,'Stephen','Timoshenko');
INSERT INTO autor VALUES(17678,1,'Nestor','Navarrete');
INSERT INTO autor VALUES(18624,1,'Anatxu','Zabalbeascoa');
INSERT INTO autor VALUES(19056,1,'Horario','Dottone');
INSERT INTO autor VALUES(19328,1,'Jose','Halabe Cherem');
INSERT INTO autor VALUES(20008,1,'Ramon','Gonzalez Munoz');
INSERT INTO autor VALUES(20223,1,'Cisco Systems',NULL);
INSERT INTO autor VALUES(20264,1,'Martin','Pegler');
INSERT INTO autor VALUES(20475,1,'Jiva','DeVoe');
INSERT INTO autor VALUES(20866,1,'Rafael','Llamas');
INSERT INTO autor VALUES(22381,1,'Frank','Scott Fitzgerald');
INSERT INTO autor VALUES(22764,1,'Ignacio','Bello');
INSERT INTO autor VALUES(23060,1,'Mark','Knapp');
INSERT INTO autor VALUES(23062,1,'Ligia','Ochoa Sierra');
INSERT INTO autor VALUES(24385,1,'Bosch',NULL);
INSERT INTO autor VALUES(24638,1,'Maria','Del Mar');
INSERT INTO autor VALUES(24766,1,'Gilberto','Enriquez Harper');
INSERT INTO autor VALUES(25636,1,'Andrew','Weil');
INSERT INTO autor VALUES(25955,1,'Monica','Gili');
INSERT INTO autor VALUES(26836,1,'Enrique','Couve');
INSERT INTO autor VALUES(27404,1,'Francisco','Garcia Ortiz');
INSERT INTO autor VALUES(27472,1,'Molly','Holzschlag');
INSERT INTO autor VALUES(27805,1,'Antonia','Gonzalez');
INSERT INTO autor VALUES(28076,1,'Nassir','Sapag Chain');
INSERT INTO autor VALUES(28808,1,'Helena','Curtis');
INSERT INTO autor VALUES(32211,1,'Hans','Roth');
INSERT INTO autor VALUES(32212,1,'Scott','Empson');
INSERT INTO autor VALUES(32329,2,'Steve','Bayes');
INSERT INTO autor VALUES(32458,1,'Paul','Hewitt');
INSERT INTO autor VALUES(33533,1,'Eugenio','Tironi Barrios');
INSERT INTO autor VALUES(35283,1,'Jose','Delgado Cabrera');
INSERT INTO autor VALUES(35653,1,'Tomas','Melendo');
INSERT INTO autor VALUES(36095,1,'Jhon','Walkenbach');
INSERT INTO autor VALUES(36581,1,'Francisco','Moreno Garcia');
INSERT INTO autor VALUES(36677,1,'Oscar','De la Torre');
INSERT INTO autor VALUES(36969,1,'I?aki','Abalos');
INSERT INTO autor VALUES(36988,1,'Mario','Carmona');
INSERT INTO autor VALUES(37333,1,'Mark','Russell');
INSERT INTO autor VALUES(37349,1,'Yunus','Cengel');
INSERT INTO autor VALUES(37353,1,'Otl','Aicher');
INSERT INTO autor VALUES(37873,1,'Andres','Munoz Machado');
INSERT INTO autor VALUES(38018,1,'Cecilia','Ricciarelli');
INSERT INTO autor VALUES(38303,1,'Jose','Coscollano Rodriguez');
INSERT INTO autor VALUES(39000,2,'Vicent',' Lladanosa');
INSERT INTO autor VALUES(39527,1,'Maria','Collell');
INSERT INTO autor VALUES(40600,1,'Jeremy','Hubbell');
INSERT INTO autor VALUES(42892,1,'William','Fisher');
INSERT INTO autor VALUES(44359,1,'Rolando','Pantoja Bauza');
INSERT INTO autor VALUES(44459,1,'Linda','Putnam');
INSERT INTO autor VALUES(45190,1,'Alberto','Delgado Garron');
INSERT INTO autor VALUES(46192,1,'David','Frey');
INSERT INTO autor VALUES(46363,1,'Gonzalo','Garcia Munoz');
INSERT INTO autor VALUES(47614,1,'Mark','Stephen Smith');
INSERT INTO autor VALUES(47827,1,'Enrique','Bernardez');
INSERT INTO autor VALUES(48600,1,'Frank','Ableson');
INSERT INTO autor VALUES(49129,1,'Jonathan','Hermosilla');
INSERT INTO autor VALUES(49409,1,'Don','Knowles');
INSERT INTO autor VALUES(49476,1,'Tulio','Halperin Donghi');
INSERT INTO autor VALUES(49893,1,'Jose','Ferre Trenzano');
INSERT INTO autor VALUES(49941,1,'Ulrich','Beck');
INSERT INTO autor VALUES(50495,1,'Karl','Case');
INSERT INTO autor VALUES(50687,1,'Irwin','Miller');
INSERT INTO autor VALUES(51022,1,'Arian','Mostaedi');
INSERT INTO autor VALUES(52083,1,'John','Ingle');
INSERT INTO autor VALUES(52276,1,'Miguel','Acerenza');
INSERT INTO autor VALUES(52611,1,'J. K','Rowling');
INSERT INTO autor VALUES(53290,1,'Roberto Morales','Morales');
INSERT INTO autor VALUES(53335,1,'J.M','Juran');
INSERT INTO autor VALUES(54210,1,'Carlos','Ducci Claro');
INSERT INTO autor VALUES(54814,1,'Alvaro','Torres Nieto');
INSERT INTO autor VALUES(55314,1,'Elizabeth','Wilhide');
INSERT INTO autor VALUES(55518,1,'Bassam','Halabi');
INSERT INTO autor VALUES(56092,1,'Antonio','Miravete');
INSERT INTO autor VALUES(57145,1,'Ronald','Walpole');
INSERT INTO autor VALUES(57596,1,'Francisco','Montiel Avendano');
INSERT INTO autor VALUES(58047,1,'Robert','Mott');
INSERT INTO autor VALUES(58114,1,'Manuel','Diaz de Rio');
INSERT INTO autor VALUES(59841,1,'C.S','Lewis');
INSERT INTO autor VALUES(60177,1,'Kevin','Wallace');
INSERT INTO autor VALUES(61196,1,'Jean','Breschand');
INSERT INTO autor VALUES(61393,1,'Wendell','Odom');
INSERT INTO autor VALUES(62470,1,'Ignacio','Bello');
INSERT INTO autor VALUES(63249,1,'Ana','Canizares');
INSERT INTO autor VALUES(63326,1,'Susy','Atkins');
INSERT INTO autor VALUES(64233,1,'Bethan','Ryder');
INSERT INTO autor VALUES(64546,1,'Jim','Doherty');
INSERT INTO autor VALUES(65070,1,'Elizabeth','Wilhide');
INSERT INTO autor VALUES(65525,1,'Margarita','Hernandez Perez');
INSERT INTO autor VALUES(65922,1,'Maria','Collell');
INSERT INTO autor VALUES(66253,1,'Francisco','Gomez Lainez');
INSERT INTO autor VALUES(66776,1,'Francisco','Soler Fajardo');
INSERT INTO autor VALUES(67087,1,'Vicente','Ambrosio');
INSERT INTO autor VALUES(67222,1,'S','Reznikoff');
INSERT INTO autor VALUES(67347,1,'Orlando','Aprile');
INSERT INTO autor VALUES(68031,1,'Francisco','Lobato Gomez');
INSERT INTO autor VALUES(69711,1,'Manuel','Serrat Olmos');
INSERT INTO autor VALUES(69767,1,'Phil','Baines');
INSERT INTO autor VALUES(71094,1,'Teaching soft group',NULL);
INSERT INTO autor VALUES(72577,1,'Hermogenes','Gil');
INSERT INTO autor VALUES(72891,1,'Antonio','Banfi');
INSERT INTO autor VALUES(74191,1,'Hermogenes','Gil');
INSERT INTO autor VALUES(75010,1,'Milton','Gussow');
INSERT INTO autor VALUES(76042,1,'Miguel','Bermejo Herrero');
INSERT INTO autor VALUES(78179,1,'Javier','Gosende Grela');
INSERT INTO autor VALUES(78749,1,'Ana','Canizares');
INSERT INTO autor VALUES(78870,1,'Candelaria','Kristof');
INSERT INTO autor VALUES(79260,1,'Jean','Mitry');
INSERT INTO autor VALUES(79562,1,'Maggie','Macnab');
INSERT INTO autor VALUES(80820,1,'Kerstin','Stremmel');
INSERT INTO autor VALUES(81222,1,'Tim','OReilly');
INSERT INTO autor VALUES(83393,1,'Rafael','Moreno');
INSERT INTO autor VALUES(83467,1,'Josep','Alet i Vilagines');
INSERT INTO autor VALUES(84029,1,'Instituto Nacional de Normalizacion',NULL);
INSERT INTO autor VALUES(84772,1,'Scott','Kelby');
INSERT INTO autor VALUES(85273,1,'Manlio','Brusatin');
INSERT INTO autor VALUES(85666,1,'Michael','Gallo');
INSERT INTO autor VALUES(87181,1,'Luis','Diez de Castro');
INSERT INTO autor VALUES(87450,1,'Richard','Dorf');
INSERT INTO autor VALUES(87474,1,'Isabel','Milio Balanza');
INSERT INTO autor VALUES(87795,1,'Jaime','Pena');
INSERT INTO autor VALUES(88806,1,'Alejo','Sison');
INSERT INTO autor VALUES(88904,1,'Jose','Roldan Viloria');
INSERT INTO autor VALUES(89348,1,'Gustavo','Munizaga Vigil');
INSERT INTO autor VALUES(89543,1,'Sham','Tickoo');
INSERT INTO autor VALUES(89870,1,'Martin','Pedersen');
INSERT INTO autor VALUES(90140,1,'Michael','Rabiger');
INSERT INTO autor VALUES(90247,1,'Ivor','Seeley');
INSERT INTO autor VALUES(90938,1,'Philip','Kotler');
INSERT INTO autor VALUES(91167,1,'Elena','Fonseca');
INSERT INTO autor VALUES(92022,1,'Peter','Rob');
INSERT INTO autor VALUES(92252,1,'Gary','Heerkens');
INSERT INTO autor VALUES(93214,1,'Andrew','Darley');
INSERT INTO autor VALUES(93335,1,'David','Duchemin');
INSERT INTO autor VALUES(93714,1,'Oscar','Asensio');
INSERT INTO autor VALUES(94153,1,'Norma','Lee');
INSERT INTO autor VALUES(94706,1,'Martin','Pedersen');
INSERT INTO autor VALUES(94738,1,'Oscar','Asensio');
INSERT INTO autor VALUES(95098,1,'Ricardo','Macchi');
INSERT INTO autor VALUES(95268,1,'Antonio','Paniagua Navarro');
INSERT INTO autor VALUES(95583,1,'Behrouz','Forouzan');
INSERT INTO autor VALUES(96472,1,'Robin','Landa');
INSERT INTO autor VALUES(97148,1,'James','Taylor');
INSERT INTO autor VALUES(97187,1,'Wayne','Rankin');


INSERT INTO ejemplar VALUES(65922,'E007','978-987-690-424-9');
INSERT INTO ejemplar VALUES(79562,'E007','978-84-101-258-8');
INSERT INTO ejemplar VALUES(65922,'E001','978-987-690-424-6');
INSERT INTO ejemplar VALUES(79562,'E006','978-84-101-258-6');
INSERT INTO ejemplar VALUES(79562,'E003','978-84-101-258-4');
INSERT INTO ejemplar VALUES(79562,'E001','978-84-101-258-3');
INSERT INTO ejemplar VALUES(65922,'E002','978-987-690-424-7');
INSERT INTO ejemplar VALUES(79562,'E004','978-84-101-258-2');
INSERT INTO ejemplar VALUES(24385,'E001','978-84-264-979-2');
INSERT INTO ejemplar VALUES(67347,'E004','978-958-810-690-2');
INSERT INTO ejemplar VALUES(65922,'E004','978-987-690-424-3');
INSERT INTO ejemplar VALUES(24385,'E002','978-84-264-979-1');
INSERT INTO ejemplar VALUES(79562,'E005','978-84-101-258-5');
INSERT INTO ejemplar VALUES(67347,'E008','978-958-810-690-6');
INSERT INTO ejemplar VALUES(24638,'E002','978-84-754-491-3');
INSERT INTO ejemplar VALUES(23062,'E001','978-956-143-604-0');
INSERT INTO ejemplar VALUES(65922,'E003','978-987-690-424-5');
INSERT INTO ejemplar VALUES(79562,'E002','978-84-101-258-0');
INSERT INTO ejemplar VALUES(79562,'E008','978-84-101-258-1');
INSERT INTO ejemplar VALUES(24638,'E001','978-84-754-491-5');
INSERT INTO ejemplar VALUES(24638,'E005','978-84-754-491-15');
INSERT INTO ejemplar VALUES(23062,'E003','978-956-143-604-9');
INSERT INTO ejemplar VALUES(67347,'E007','978-958-810-690-3');
INSERT INTO ejemplar VALUES(28808,'E001','978-607-264-362-1');
INSERT INTO ejemplar VALUES(28808,'E002','978-607-264-362-9');
INSERT INTO ejemplar VALUES(32458,'E002','978-607-603-518-2');
INSERT INTO ejemplar VALUES(32458,'E003','978-607-603-518-1');
INSERT INTO ejemplar VALUES(36988,'E002','978-607-603-946-3');
INSERT INTO ejemplar VALUES(36988,'E003','978-607-603-946-9');
INSERT INTO ejemplar VALUES(20866,'E001','978-607-810-280-4');
INSERT INTO ejemplar VALUES(20866,'E002','978-607-810-280-6');
INSERT INTO ejemplar VALUES(49129,'E002','978-607-810-389-5');
INSERT INTO ejemplar VALUES(49129,'E003','978-607-810-389-9');
INSERT INTO ejemplar VALUES(49129,'E005','978-607-810-389-6');
INSERT INTO ejemplar VALUES(97148,'E002','978-607-810-529-4');
INSERT INTO ejemplar VALUES(97148,'E003','978-607-810-529-7');
INSERT INTO ejemplar VALUES(59841,'E003','978-607-867-820-9');
INSERT INTO ejemplar VALUES(59841,'E004','978-607-867-820-8');
INSERT INTO ejemplar VALUES(79260,'E002','978-84-101-198-4');
INSERT INTO ejemplar VALUES(79260,'E003','978-84-101-198-9');
INSERT INTO ejemplar VALUES(27404,'E001','978-84-101-579-7');
INSERT INTO ejemplar VALUES(27404,'E003','978-84-101-579-2');
INSERT INTO ejemplar VALUES(42892,'E002','978-84-187-479-6');
INSERT INTO ejemplar VALUES(42892,'E003','978-84-187-479-3');
INSERT INTO ejemplar VALUES(39527,'E001','978-84-187-543-2');
INSERT INTO ejemplar VALUES(39527,'E002','978-84-187-543-4');
INSERT INTO ejemplar VALUES(53335,'E001','978-84-187-557-8');
INSERT INTO ejemplar VALUES(53335,'E002','978-84-187-557-5');
INSERT INTO ejemplar VALUES(52611,'E001','978-84-187-755-1');
INSERT INTO ejemplar VALUES(52611,'E003','978-84-187-755-6');
INSERT INTO ejemplar VALUES(52611,'E004','978-84-187-755-0');
INSERT INTO ejemplar VALUES(52611,'E005','978-84-187-755-7');
INSERT INTO ejemplar VALUES(24385,'E004','978-84-264-979-7');
INSERT INTO ejemplar VALUES(20475,'E001','978-84-393-701-3');
INSERT INTO ejemplar VALUES(20475,'E004','978-84-393-701-2');
INSERT INTO ejemplar VALUES(47827,'E001','978-84-393-782-2');
INSERT INTO ejemplar VALUES(47827,'E003','978-84-393-782-0');
INSERT INTO ejemplar VALUES(95583,'E001','978-84-499-963-4');
INSERT INTO ejemplar VALUES(95583,'E002','978-84-499-963-1');
INSERT INTO ejemplar VALUES(24766,'E002','978-84-593-814-5');
INSERT INTO ejemplar VALUES(24766,'E004','978-84-593-814-0');
INSERT INTO ejemplar VALUES(25955,'E002','978-84-594-468-6');
INSERT INTO ejemplar VALUES(19056,'E003','978-84-594-468-1');
INSERT INTO ejemplar VALUES(89870,'E001','978-84-594-685-7');
INSERT INTO ejemplar VALUES(89870,'E002','978-84-594-685-8');
INSERT INTO ejemplar VALUES(81222,'E003','978-84-682-826-9');
INSERT INTO ejemplar VALUES(81222,'E004','978-84-682-826-8');
INSERT INTO ejemplar VALUES(80820,'E001','978-84-690-317-8');
INSERT INTO ejemplar VALUES(80820,'E002','978-84-690-317-4');
INSERT INTO ejemplar VALUES(50687,'E003','978-84-754-342-1');
INSERT INTO ejemplar VALUES(50687,'E004','978-84-754-342-8');
INSERT INTO ejemplar VALUES(94706,'E001','978-84-754-378-2');
INSERT INTO ejemplar VALUES(94706,'E002','978-84-754-378-3');
INSERT INTO ejemplar VALUES(69711,'E001','978-84-754-470-3');
INSERT INTO ejemplar VALUES(69711,'E002','978-84-754-470-0');
INSERT INTO ejemplar VALUES(90247,'E002','978-84-754-476-3');
INSERT INTO ejemplar VALUES(90247,'E004','978-84-754-476-8');
INSERT INTO ejemplar VALUES(24638,'E003','978-84-754-491-1');
INSERT INTO ejemplar VALUES(54814,'E002','978-84-810-626-6');
INSERT INTO ejemplar VALUES(54814,'E005','978-84-810-626-4');
INSERT INTO ejemplar VALUES(54814,'E003','978-84-810-626-7');
INSERT INTO ejemplar VALUES(54814,'E004','978-84-810-626-8');
INSERT INTO ejemplar VALUES(90938,'E001','978-84-814-763-8');
INSERT INTO ejemplar VALUES(90938,'E002','978-84-814-763-9');
INSERT INTO ejemplar VALUES(23062,'E004','978-956-143-604-5');
INSERT INTO ejemplar VALUES(10926,'E001','978-956-271-323-1');
INSERT INTO ejemplar VALUES(10926,'E002','978-956-271-323-6');
INSERT INTO ejemplar VALUES(89348,'E002','978-956-320-302-2');
INSERT INTO ejemplar VALUES(89348,'E003','978-956-320-302-9');
INSERT INTO ejemplar VALUES(67347,'E009','978-958-810-690-7');
INSERT INTO ejemplar VALUES(65525,'E001','978-987-622-601-4');
INSERT INTO ejemplar VALUES(65525,'E002','978-987-622-601-6');
INSERT INTO ejemplar VALUES(65922,'E006','978-987-690-424-0');
INSERT INTO ejemplar VALUES(65922,'E008','978-987-690-424-8');
INSERT INTO ejemplar VALUES(58047,'E001','978-0-235-532-1');
INSERT INTO ejemplar VALUES(58047,'E002','978-0-235-532-2');
INSERT INTO ejemplar VALUES(28076,'E002','978-0-393-458-3');
INSERT INTO ejemplar VALUES(28076,'E001','978-0-393-458-4');
INSERT INTO ejemplar VALUES(88806,'E001','978-0-779-900-2');
INSERT INTO ejemplar VALUES(88806,'E002','978-0-779-900-5');
INSERT INTO ejemplar VALUES(48600,'E001','978-0-810-632-0');
INSERT INTO ejemplar VALUES(48600,'E002','978-0-810-632-5');
INSERT INTO ejemplar VALUES(37333,'E001','978-3-912-564-6');
INSERT INTO ejemplar VALUES(37333,'E002','978-3-912-564-9');
INSERT INTO ejemplar VALUES(49409,'E002','978-3-912-565-1');
INSERT INTO ejemplar VALUES(49409,'E001','978-3-912-565-5');
INSERT INTO ejemplar VALUES(37349,'E002','978-3-912-942-1');
INSERT INTO ejemplar VALUES(37349,'E001','978-3-912-942-5');
INSERT INTO ejemplar VALUES(58114,'E002','978-607-187-392-5');
INSERT INTO ejemplar VALUES(58114,'E001','978-607-187-392-6');
INSERT INTO ejemplar VALUES(36581,'E001','978-607-187-433-4');
INSERT INTO ejemplar VALUES(36581,'E002','978-607-187-433-5');
INSERT INTO ejemplar VALUES(92252,'E002','978-607-264-261-0');
INSERT INTO ejemplar VALUES(92252,'E005','978-607-264-261-2');
INSERT INTO ejemplar VALUES(92252,'E004','978-607-264-261-3');
INSERT INTO ejemplar VALUES(92252,'E003','978-607-264-261-8');
INSERT INTO ejemplar VALUES(92252,'E001','978-607-264-261-9');
INSERT INTO ejemplar VALUES(83393,'E001','978-607-264-337-1');
INSERT INTO ejemplar VALUES(83393,'E002','978-607-264-337-6');
INSERT INTO ejemplar VALUES(83393,'E003','978-607-264-337-7');
INSERT INTO ejemplar VALUES(83467,'E001','978-607-264-565-2');
INSERT INTO ejemplar VALUES(83467,'E002','978-607-264-565-7');
INSERT INTO ejemplar VALUES(23060,'E001','978-607-393-146-3');
INSERT INTO ejemplar VALUES(23060,'E003','978-607-393-146-5');
INSERT INTO ejemplar VALUES(23060,'E002','978-607-393-146-9');
INSERT INTO ejemplar VALUES(22764,'E002','978-607-393-419-2');
INSERT INTO ejemplar VALUES(22764,'E001','978-607-393-419-5');
INSERT INTO ejemplar VALUES(32329,'E001','978-607-393-704-2');
INSERT INTO ejemplar VALUES(32329,'E002','978-607-393-704-5');
INSERT INTO ejemplar VALUES(90140,'E001','978-607-393-931-4');
INSERT INTO ejemplar VALUES(90140,'E002','978-607-393-931-9');
INSERT INTO ejemplar VALUES(32212,'E001','978-607-550-392-4');
INSERT INTO ejemplar VALUES(32211,'E001','978-607-550-392-9');
INSERT INTO ejemplar VALUES(61393,'E002','978-607-550-426-4');
INSERT INTO ejemplar VALUES(61393,'E001','978-607-550-426-9');
INSERT INTO ejemplar VALUES(62470,'E002','978-607-603-402-0');
INSERT INTO ejemplar VALUES(62470,'E001','978-607-603-402-4');
INSERT INTO ejemplar VALUES(32458,'E001','978-607-603-518-7');
INSERT INTO ejemplar VALUES(85273,'E001','978-607-603-541-5');
INSERT INTO ejemplar VALUES(85273,'E002','978-607-603-541-9');
INSERT INTO ejemplar VALUES(36988,'E001','978-607-603-946-6');
INSERT INTO ejemplar VALUES(84029,'E002','978-607-670-152-3');
INSERT INTO ejemplar VALUES(84029,'E001','978-607-670-152-8');
INSERT INTO ejemplar VALUES(65070,'E001','978-607-670-486-0');
INSERT INTO ejemplar VALUES(65070,'E002','978-607-670-486-6');
INSERT INTO ejemplar VALUES(84772,'E001','978-607-670-568-3');
INSERT INTO ejemplar VALUES(84772,'E002','978-607-670-568-7');
INSERT INTO ejemplar VALUES(61196,'E001','978-607-810-182-5');
INSERT INTO ejemplar VALUES(61196,'E002','978-607-810-182-8');
INSERT INTO ejemplar VALUES(49129,'E004','978-607-810-389-1');
INSERT INTO ejemplar VALUES(49129,'E001','978-607-810-389-7');
INSERT INTO ejemplar VALUES(97148,'E001','978-607-810-529-5');
INSERT INTO ejemplar VALUES(97148,'E004','978-607-810-529-9');
INSERT INTO ejemplar VALUES(22381,'E002','978-607-810-717-3');
INSERT INTO ejemplar VALUES(22381,'E003','978-607-810-717-4');
INSERT INTO ejemplar VALUES(22381,'E001','978-607-810-717-7');
INSERT INTO ejemplar VALUES(97187,'E002','978-607-810-780-7');
INSERT INTO ejemplar VALUES(97187,'E001','978-607-810-780-9');
INSERT INTO ejemplar VALUES(60177,'E002','978-607-810-930-3');
INSERT INTO ejemplar VALUES(60177,'E001','978-607-810-930-5');
INSERT INTO ejemplar VALUES(96472,'E002','978-607-867-492-1');
INSERT INTO ejemplar VALUES(96472,'E001','978-607-867-492-3');
INSERT INTO ejemplar VALUES(59841,'E002','978-607-867-820-2');
INSERT INTO ejemplar VALUES(59841,'E001','978-607-867-820-6');
INSERT INTO ejemplar VALUES(55518,'E001','978-84-101-120-6');
INSERT INTO ejemplar VALUES(55518,'E002','978-84-101-120-7');
INSERT INTO ejemplar VALUES(19328,'E002','978-84-101-191-4');
INSERT INTO ejemplar VALUES(19328,'E001','978-84-101-191-6');
INSERT INTO ejemplar VALUES(79260,'E001','978-84-101-198-5');
INSERT INTO ejemplar VALUES(46192,'E001','978-84-101-232-3');
INSERT INTO ejemplar VALUES(46192,'E004','978-84-101-232-6');
INSERT INTO ejemplar VALUES(46192,'E002','978-84-101-232-8');
INSERT INTO ejemplar VALUES(46192,'E003','978-84-101-232-9');
INSERT INTO ejemplar VALUES(26836,'E002','978-84-101-328-3');
INSERT INTO ejemplar VALUES(26836,'E001','978-84-101-328-7');
INSERT INTO ejemplar VALUES(56092,'E001','978-84-101-347-5');
INSERT INTO ejemplar VALUES(56092,'E002','978-84-101-347-7');
INSERT INTO ejemplar VALUES(27404,'E002','978-84-101-579-8');
INSERT INTO ejemplar VALUES(45190,'E002','978-84-101-589-2');
INSERT INTO ejemplar VALUES(45190,'E003','978-84-101-589-4');
INSERT INTO ejemplar VALUES(45190,'E001','978-84-101-589-9');
INSERT INTO ejemplar VALUES(91167,'E004','978-84-101-770-0');
INSERT INTO ejemplar VALUES(91167,'E001','978-84-101-770-1');
INSERT INTO ejemplar VALUES(91167,'E002','978-84-101-770-2');
INSERT INTO ejemplar VALUES(91167,'E005','978-84-101-770-3');
INSERT INTO ejemplar VALUES(91167,'E003','978-84-101-770-6');
INSERT INTO ejemplar VALUES(85666,'E001','978-84-187-230-3');
INSERT INTO ejemplar VALUES(85666,'E002','978-84-187-230-8');
INSERT INTO ejemplar VALUES(89543,'E002','978-84-187-284-5');
INSERT INTO ejemplar VALUES(89543,'E001','978-84-187-284-6');
INSERT INTO ejemplar VALUES(40600,'E001','978-84-187-385-2');
INSERT INTO ejemplar VALUES(40600,'E002','978-84-187-385-6');
INSERT INTO ejemplar VALUES(53290,'E001','978-84-187-429-5');
INSERT INTO ejemplar VALUES(53290,'E002','978-84-187-429-8');
INSERT INTO ejemplar VALUES(42892,'E004','978-84-187-479-7');
INSERT INTO ejemplar VALUES(42892,'E001','978-84-187-479-8');
INSERT INTO ejemplar VALUES(95098,'E002','978-84-187-545-2');
INSERT INTO ejemplar VALUES(95098,'E001','978-84-187-545-5');
INSERT INTO ejemplar VALUES(52611,'E002','978-84-187-755-5');
INSERT INTO ejemplar VALUES(52611,'E006','978-84-187-755-9');
INSERT INTO ejemplar VALUES(35283,'E003','978-84-187-796-3');
INSERT INTO ejemplar VALUES(35283,'E001','978-84-187-796-5');
INSERT INTO ejemplar VALUES(35283,'E002','978-84-187-796-8');
INSERT INTO ejemplar VALUES(78749,'E002','978-84-187-797-2');
INSERT INTO ejemplar VALUES(78749,'E001','978-84-187-797-8');
INSERT INTO ejemplar VALUES(93335,'E002','978-84-264-423-5');
INSERT INTO ejemplar VALUES(93335,'E001','978-84-264-423-6');
INSERT INTO ejemplar VALUES(24385,'E003','978-84-264-979-8');
INSERT INTO ejemplar VALUES(87795,'E001','978-84-360-403-1');
INSERT INTO ejemplar VALUES(87795,'E002','978-84-360-403-6');
INSERT INTO ejemplar VALUES(78870,'E001','978-84-360-897-1');
INSERT INTO ejemplar VALUES(78870,'E003','978-84-360-897-2');
INSERT INTO ejemplar VALUES(78870,'E002','978-84-360-897-7');
INSERT INTO ejemplar VALUES(20264,'E001','978-84-393-619-5');
INSERT INTO ejemplar VALUES(20264,'E002','978-84-393-619-9');
INSERT INTO ejemplar VALUES(20475,'E003','978-84-393-701-0');
INSERT INTO ejemplar VALUES(20475,'E005','978-84-393-701-6');
INSERT INTO ejemplar VALUES(20475,'E002','978-84-393-701-9');
INSERT INTO ejemplar VALUES(47827,'E002','978-84-393-782-3');
INSERT INTO ejemplar VALUES(47614,'E001','978-84-499-734-2');
INSERT INTO ejemplar VALUES(47614,'E002','978-84-499-734-6');
INSERT INTO ejemplar VALUES(88904,'E001','978-84-550-757-2');
INSERT INTO ejemplar VALUES(88904,'E002','978-84-550-757-3');
INSERT INTO ejemplar VALUES(87181,'E001','978-84-593-136-6');
INSERT INTO ejemplar VALUES(87181,'E002','978-84-593-136-9');
INSERT INTO ejemplar VALUES(24766,'E009','978-84-593-814-1');
INSERT INTO ejemplar VALUES(24766,'E007','978-84-593-814-2');
INSERT INTO ejemplar VALUES(24766,'E005','978-84-593-814-3');
INSERT INTO ejemplar VALUES(24766,'E008','978-84-593-814-6');
INSERT INTO ejemplar VALUES(24766,'E006','978-84-593-814-7');
INSERT INTO ejemplar VALUES(24766,'E003','978-84-593-814-8');
INSERT INTO ejemplar VALUES(24766,'E001','978-84-593-814-9');
INSERT INTO ejemplar VALUES(87450,'E001','978-84-593-956-5');
INSERT INTO ejemplar VALUES(87450,'E002','978-84-593-956-7');
INSERT INTO ejemplar VALUES(19056,'E002','978-84-594-468-0');
INSERT INTO ejemplar VALUES(25955,'E001','978-84-594-468-2');
INSERT INTO ejemplar VALUES(19056,'E001','978-84-594-468-5');
INSERT INTO ejemplar VALUES(25955,'E003','978-84-594-468-7');
INSERT INTO ejemplar VALUES(89870,'E003','978-84-594-685-9');
INSERT INTO ejemplar VALUES(87474,'E003','978-84-594-735-0');
INSERT INTO ejemplar VALUES(87474,'E002','978-84-594-735-3');
INSERT INTO ejemplar VALUES(87474,'E001','978-84-594-735-6');
INSERT INTO ejemplar VALUES(39000,'E002','978-84-626-228-8');
INSERT INTO ejemplar VALUES(39000,'E001','978-84-626-228-9');
INSERT INTO ejemplar VALUES(14975,'E001','978-84-626-487-2');
INSERT INTO ejemplar VALUES(14975,'E002','978-84-626-487-9');
INSERT INTO ejemplar VALUES(78179,'E001','978-84-626-648-0');
INSERT INTO ejemplar VALUES(78179,'E005','978-84-626-648-1');
INSERT INTO ejemplar VALUES(78179,'E002','978-84-626-648-2');
INSERT INTO ejemplar VALUES(78179,'E004','978-84-626-648-3');
INSERT INTO ejemplar VALUES(78179,'E003','978-84-626-648-6');
INSERT INTO ejemplar VALUES(63249,'E001','978-84-626-899-3');
INSERT INTO ejemplar VALUES(63249,'E002','978-84-626-899-7');
INSERT INTO ejemplar VALUES(52276,'E001','978-84-644-207-0');
INSERT INTO ejemplar VALUES(52276,'E002','978-84-644-207-1');
INSERT INTO ejemplar VALUES(76042,'E001','978-84-662-150-3');
INSERT INTO ejemplar VALUES(76042,'E002','978-84-662-150-9');
INSERT INTO ejemplar VALUES(64546,'E001','978-84-662-816-7');
INSERT INTO ejemplar VALUES(64546,'E002','978-84-662-816-8');
INSERT INTO ejemplar VALUES(27805,'E001','978-84-670-272-0');
INSERT INTO ejemplar VALUES(27805,'E002','978-84-670-272-6');
INSERT INTO ejemplar VALUES(46363,'E002','978-84-670-320-1');
INSERT INTO ejemplar VALUES(46363,'E001','978-84-670-320-3');
INSERT INTO ejemplar VALUES(27472,'E001','978-84-670-620-5');
INSERT INTO ejemplar VALUES(27472,'E003','978-84-670-620-7');
INSERT INTO ejemplar VALUES(27472,'E002','978-84-670-620-9');
INSERT INTO ejemplar VALUES(36095,'E002','978-84-670-706-8');
INSERT INTO ejemplar VALUES(36095,'E001','978-84-670-706-9');
INSERT INTO ejemplar VALUES(57145,'E002','978-84-670-765-0');
INSERT INTO ejemplar VALUES(57145,'E001','978-84-670-765-3');
INSERT INTO ejemplar VALUES(95268,'E001','978-84-670-771-2');
INSERT INTO ejemplar VALUES(95268,'E002','978-84-670-771-5');
INSERT INTO ejemplar VALUES(20008,'E001','978-84-670-919-4');
INSERT INTO ejemplar VALUES(20008,'E002','978-84-670-919-7');
INSERT INTO ejemplar VALUES(92022,'E006','978-84-676-740-0');
INSERT INTO ejemplar VALUES(92022,'E001','978-84-676-740-1');
INSERT INTO ejemplar VALUES(92022,'E002','978-84-676-740-2');
INSERT INTO ejemplar VALUES(92022,'E005','978-84-676-740-3');
INSERT INTO ejemplar VALUES(92022,'E004','978-84-676-740-5');
INSERT INTO ejemplar VALUES(92022,'E003','978-84-676-740-7');
INSERT INTO ejemplar VALUES(20223,'E002','978-84-682-781-2');
INSERT INTO ejemplar VALUES(20223,'E001','978-84-682-781-4');
INSERT INTO ejemplar VALUES(81222,'E007','978-84-682-826-0');
INSERT INTO ejemplar VALUES(81222,'E009','978-84-682-826-1');
INSERT INTO ejemplar VALUES(81222,'E001','978-84-682-826-2');
INSERT INTO ejemplar VALUES(81222,'E005','978-84-682-826-3');
INSERT INTO ejemplar VALUES(81222,'E006','978-84-682-826-5');
INSERT INTO ejemplar VALUES(81222,'E008','978-84-682-826-6');
INSERT INTO ejemplar VALUES(81222,'E002','978-84-682-826-7');
INSERT INTO ejemplar VALUES(94738,'E002','978-84-753-102-3');
INSERT INTO ejemplar VALUES(94738,'E001','978-84-753-102-9');
INSERT INTO ejemplar VALUES(51022,'E002','978-84-753-409-2');
INSERT INTO ejemplar VALUES(51022,'E001','978-84-753-409-5');
INSERT INTO ejemplar VALUES(38018,'E001','978-84-753-663-1');
INSERT INTO ejemplar VALUES(38018,'E002','978-84-753-663-4');
INSERT INTO ejemplar VALUES(37873,'E002','978-84-754-131-2');
INSERT INTO ejemplar VALUES(37873,'E001','978-84-754-131-5');
INSERT INTO ejemplar VALUES(72577,'E001','978-84-754-137-4');
INSERT INTO ejemplar VALUES(72577,'E002','978-84-754-137-7');
INSERT INTO ejemplar VALUES(93714,'E002','978-84-754-149-0');
INSERT INTO ejemplar VALUES(93714,'E001','978-84-754-149-4');
INSERT INTO ejemplar VALUES(72891,'E002','978-84-754-181-2');
INSERT INTO ejemplar VALUES(72891,'E001','978-84-754-181-7');
INSERT INTO ejemplar VALUES(72891,'E003','978-84-754-181-9');
INSERT INTO ejemplar VALUES(69767,'E001','978-84-754-288-3');
INSERT INTO ejemplar VALUES(69767,'E002','978-84-754-288-5');
INSERT INTO ejemplar VALUES(69767,'E003','978-84-754-288-6');
INSERT INTO ejemplar VALUES(50687,'E001','978-84-754-342-0');
INSERT INTO ejemplar VALUES(50687,'E002','978-84-754-342-5');
INSERT INTO ejemplar VALUES(94706,'E003','978-84-754-378-4');
INSERT INTO ejemplar VALUES(64233,'E001','978-84-754-408-2');
INSERT INTO ejemplar VALUES(64233,'E002','978-84-754-408-4');
INSERT INTO ejemplar VALUES(69711,'E003','978-84-754-470-4');
INSERT INTO ejemplar VALUES(90247,'E001','978-84-754-476-1');
INSERT INTO ejemplar VALUES(90247,'E003','978-84-754-476-4');
INSERT INTO ejemplar VALUES(24638,'E009','978-84-754-491-0');
INSERT INTO ejemplar VALUES(24638,'E006','978-84-754-491-2');
INSERT INTO ejemplar VALUES(24638,'E004','978-84-754-491-4');
INSERT INTO ejemplar VALUES(24638,'E007','978-84-754-491-8');
INSERT INTO ejemplar VALUES(24638,'E008','978-84-754-491-9');
INSERT INTO ejemplar VALUES(36969,'E001','978-84-754-528-4');
INSERT INTO ejemplar VALUES(36969,'E002','978-84-754-528-9');
INSERT INTO ejemplar VALUES(50495,'E002','978-84-754-549-3');
INSERT INTO ejemplar VALUES(50495,'E001','978-84-754-549-4');
INSERT INTO ejemplar VALUES(71094,'E001','978-84-754-580-4');
INSERT INTO ejemplar VALUES(71094,'E002','978-84-754-580-6');
INSERT INTO ejemplar VALUES(94153,'E002','978-84-754-946-5');
INSERT INTO ejemplar VALUES(94153,'E001','978-84-754-946-9');
INSERT INTO ejemplar VALUES(49941,'E002','978-84-754-950-3');
INSERT INTO ejemplar VALUES(49941,'E001','978-84-754-950-6');
INSERT INTO ejemplar VALUES(49941,'E003','978-84-754-950-9');
INSERT INTO ejemplar VALUES(44359,'E003','978-84-810-151-1');
INSERT INTO ejemplar VALUES(44359,'E001','978-84-810-151-3');
INSERT INTO ejemplar VALUES(44359,'E002','978-84-810-151-9');
INSERT INTO ejemplar VALUES(54814,'E001','978-84-810-626-9');
INSERT INTO ejemplar VALUES(54210,'E001','978-84-810-669-4');
INSERT INTO ejemplar VALUES(54210,'E002','978-84-810-669-8');
INSERT INTO ejemplar VALUES(16799,'E001','978-84-810-673-4');
INSERT INTO ejemplar VALUES(16799,'E002','978-84-810-673-7');
INSERT INTO ejemplar VALUES(16799,'E003','978-84-810-673-9');
INSERT INTO ejemplar VALUES(17678,'E001','978-84-810-903-3');
INSERT INTO ejemplar VALUES(17678,'E002','978-84-810-903-6');
INSERT INTO ejemplar VALUES(17678,'E003','978-84-810-903-9');
INSERT INTO ejemplar VALUES(44459,'E001','978-84-810-921-4');
INSERT INTO ejemplar VALUES(44459,'E002','978-84-810-921-6');
INSERT INTO ejemplar VALUES(18624,'E001','978-84-810-935-1');
INSERT INTO ejemplar VALUES(18624,'E002','978-84-810-935-7');
INSERT INTO ejemplar VALUES(52083,'E003','978-84-814-450-3');
INSERT INTO ejemplar VALUES(52083,'E002','978-84-814-450-4');
INSERT INTO ejemplar VALUES(52083,'E004','978-84-814-450-7');
INSERT INTO ejemplar VALUES(52083,'E001','978-84-814-450-8');
INSERT INTO ejemplar VALUES(38303,'E003','978-84-814-466-2');
INSERT INTO ejemplar VALUES(38303,'E001','978-84-814-466-8');
INSERT INTO ejemplar VALUES(38303,'E002','978-84-814-466-9');
INSERT INTO ejemplar VALUES(74191,'E002','978-84-814-534-0');
INSERT INTO ejemplar VALUES(74191,'E001','978-84-814-534-4');
INSERT INTO ejemplar VALUES(13733,'E003','978-84-814-704-0');
INSERT INTO ejemplar VALUES(13733,'E002','978-84-814-704-3');
INSERT INTO ejemplar VALUES(13733,'E001','978-84-814-704-8');
INSERT INTO ejemplar VALUES(75010,'E002','978-84-814-985-0');
INSERT INTO ejemplar VALUES(75010,'E001','978-84-814-985-2');
INSERT INTO ejemplar VALUES(75010,'E003','978-84-814-985-7');
INSERT INTO ejemplar VALUES(68031,'E001','978-84-853-151-4');
INSERT INTO ejemplar VALUES(68031,'E002','978-84-853-151-5');
INSERT INTO ejemplar VALUES(13244,'E002','978-84-853-976-4');
INSERT INTO ejemplar VALUES(13244,'E001','978-84-853-976-9');
INSERT INTO ejemplar VALUES(25636,'E002','978-84-888-417-0');
INSERT INTO ejemplar VALUES(25636,'E001','978-84-888-417-9');
INSERT INTO ejemplar VALUES(55314,'E002','978-84-888-913-5');
INSERT INTO ejemplar VALUES(55314,'E001','978-84-888-913-8');
INSERT INTO ejemplar VALUES(57596,'E002','978-84-930-222-1');
INSERT INTO ejemplar VALUES(57596,'E001','978-84-930-222-2');
INSERT INTO ejemplar VALUES(57596,'E003','978-84-930-222-3');
INSERT INTO ejemplar VALUES(15480,'E001','978-84-995-189-3');
INSERT INTO ejemplar VALUES(15480,'E002','978-84-995-189-9');
INSERT INTO ejemplar VALUES(35653,'E001','978-84-995-232-1');
INSERT INTO ejemplar VALUES(35653,'E002','978-84-995-232-3');
INSERT INTO ejemplar VALUES(11611,'E002','978-956-143-494-1');
INSERT INTO ejemplar VALUES(11611,'E001','978-956-143-494-6');
INSERT INTO ejemplar VALUES(23062,'E005','978-956-143-604-1');
INSERT INTO ejemplar VALUES(23062,'E002','978-956-143-604-2');
INSERT INTO ejemplar VALUES(63326,'E001','978-956-271-769-6');
INSERT INTO ejemplar VALUES(63326,'E002','978-956-271-769-9');
INSERT INTO ejemplar VALUES(66776,'E001','978-956-302-915-2');
INSERT INTO ejemplar VALUES(66776,'E002','978-956-302-915-4');
INSERT INTO ejemplar VALUES(66776,'E003','978-956-302-915-6');
INSERT INTO ejemplar VALUES(66776,'E004','978-956-302-915-9');
INSERT INTO ejemplar VALUES(89348,'E004','978-956-320-302-4');
INSERT INTO ejemplar VALUES(89348,'E001','978-956-320-302-7');
INSERT INTO ejemplar VALUES(33533,'E002','978-956-320-878-0');
INSERT INTO ejemplar VALUES(33533,'E001','978-956-320-878-7');
INSERT INTO ejemplar VALUES(93214,'E004','978-956-595-340-3');
INSERT INTO ejemplar VALUES(93214,'E001','978-956-595-340-5');
INSERT INTO ejemplar VALUES(93214,'E002','978-956-595-340-6');
INSERT INTO ejemplar VALUES(93214,'E003','978-956-595-340-8');
INSERT INTO ejemplar VALUES(93214,'E005','978-956-595-340-9');
INSERT INTO ejemplar VALUES(67087,'E001','978-956-595-448-2');
INSERT INTO ejemplar VALUES(67087,'E004','978-956-595-448-4');
INSERT INTO ejemplar VALUES(67087,'E005','978-956-595-448-5');
INSERT INTO ejemplar VALUES(67087,'E002','978-956-595-448-6');
INSERT INTO ejemplar VALUES(67087,'E003','978-956-595-448-7');
INSERT INTO ejemplar VALUES(67222,'E002','978-956-690-697-2');
INSERT INTO ejemplar VALUES(67222,'E003','978-956-690-697-3');
INSERT INTO ejemplar VALUES(67222,'E001','978-956-690-697-5');
INSERT INTO ejemplar VALUES(67222,'E004','978-956-690-697-7');
INSERT INTO ejemplar VALUES(36677,'E003','978-956-787-234-0');
INSERT INTO ejemplar VALUES(36677,'E002','978-956-787-234-1');
INSERT INTO ejemplar VALUES(36677,'E001','978-956-787-234-2');
INSERT INTO ejemplar VALUES(11976,'E002','978-956-787-442-4');
INSERT INTO ejemplar VALUES(11976,'E001','978-956-787-442-5');
INSERT INTO ejemplar VALUES(12221,'E001','978-958-670-380-4');
INSERT INTO ejemplar VALUES(12221,'E002','978-958-670-380-7');
INSERT INTO ejemplar VALUES(49893,'E001','978-958-670-395-1');
INSERT INTO ejemplar VALUES(49893,'E002','978-958-670-395-9');
INSERT INTO ejemplar VALUES(37353,'E001','978-958-810-306-2');
INSERT INTO ejemplar VALUES(37353,'E002','978-958-810-306-5');
INSERT INTO ejemplar VALUES(67347,'E001','978-958-810-690-0');
INSERT INTO ejemplar VALUES(67347,'E003','978-958-810-690-1');
INSERT INTO ejemplar VALUES(67347,'E005','978-958-810-690-4');
INSERT INTO ejemplar VALUES(67347,'E006','978-958-810-690-8');
INSERT INTO ejemplar VALUES(67347,'E002','978-958-810-690-9');
INSERT INTO ejemplar VALUES(49476,'E001','978-987-622-565-1');
INSERT INTO ejemplar VALUES(49476,'E002','978-987-622-565-3');
INSERT INTO ejemplar VALUES(65525,'E005','978-987-622-601-2');
INSERT INTO ejemplar VALUES(65525,'E003','978-987-622-601-3');
INSERT INTO ejemplar VALUES(65525,'E004','978-987-622-601-8');
INSERT INTO ejemplar VALUES(66253,'E001','978-987-690-255-1');
INSERT INTO ejemplar VALUES(66253,'E002','978-987-690-255-9');
INSERT INTO ejemplar VALUES(65922,'E005','978-987-690-424-2');


INSERT INTO prestamo VALUES('47735','07/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:19','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:46','13/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:39','49129','E005','186','160');
INSERT INTO prestamo VALUES('29716','15/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:06','16/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:35','18/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:34','67087','E002','182','190');
INSERT INTO prestamo VALUES('38754','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:06','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:01','12/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:58','23060','E001','154','190');
INSERT INTO prestamo VALUES('92422','21/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:40','23/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:20','29/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:53','11611','E002','174','200');
INSERT INTO prestamo VALUES('39211','29/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:07','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:34','07/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:12','39527','E002','133','170');
INSERT INTO prestamo VALUES('23280','08/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:17','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:03','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:57','63326','E002','170','170');
INSERT INTO prestamo VALUES('37344','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:01','26/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:49','26/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:41','85666','E001','134','150');
INSERT INTO prestamo VALUES('77216','05/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:25','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:47','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:03','64233','E001','193','190');
INSERT INTO prestamo VALUES('94778','01/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:38','02/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:23','06/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:17','22381','E001','100','160');
INSERT INTO prestamo VALUES('97203','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:44','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:21','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:33','47614','E001','150','190');
INSERT INTO prestamo VALUES('60101','12/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:30','16/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:14','19/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:25','66776','E004','108','150');
INSERT INTO prestamo VALUES('60144','03/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:20','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:00','07/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:57','24385','E001','175','170');
INSERT INTO prestamo VALUES('51918','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:57','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:18','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:19','89543','E001','187','200');
INSERT INTO prestamo VALUES('94913','23/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:28','29/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:33','02/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:22','81222','E004','173','190');
INSERT INTO prestamo VALUES('85487','02/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:18','05/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:35','09/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:49','36581','E001','186','180');
INSERT INTO prestamo VALUES('69472','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:26','02/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:35','06/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:20','83467','E001','161','160');
INSERT INTO prestamo VALUES('16224','07/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:55','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:08','12/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:58','78870','E001','156','150');
INSERT INTO prestamo VALUES('31297','29/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:26','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:19','05/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:14','37333','E002','136','200');
INSERT INTO prestamo VALUES('46669','16/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:43','17/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:43','20/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:59','90140','E001','129','170');
INSERT INTO prestamo VALUES('42112','27/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:09','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:36','04/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:04','54814','E003','111','160');
INSERT INTO prestamo VALUES('52891','18/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:30','20/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:07','24/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:33','37353','E001','123','200');
INSERT INTO prestamo VALUES('25468','24/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:08','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:42','30/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:36','44459','E002','109','180');
INSERT INTO prestamo VALUES('25554','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:06','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:18','18/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:42','79562','E001','172','150');
INSERT INTO prestamo VALUES('30890','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:36','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:44','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:17','42892','E004','119','180');
INSERT INTO prestamo VALUES('56149','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:33','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:48','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:00','36095','E002','124','180');
INSERT INTO prestamo VALUES('83898','01/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:37','04/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:39','05/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:45','22381','E003','188','160');
INSERT INTO prestamo VALUES('72784','02/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:45','05/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:50','07/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:53','28808','E001','165','160');
INSERT INTO prestamo VALUES('79895','26/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:19','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:24','03/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:59','20475','E004','122','200');
INSERT INTO prestamo VALUES('57728','05/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:52','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:57','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:24','89543','E002','141','190');
INSERT INTO prestamo VALUES('97761','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:06','05/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:45','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:08','92252','E005','100','150');
INSERT INTO prestamo VALUES('43012','05/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:06','06/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:32','10/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:47','87474','E002','102','150');
INSERT INTO prestamo VALUES('28552','08/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:00','10/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:40','17/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:46','19056','E001','109','180');
INSERT INTO prestamo VALUES('71317','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:44','08/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:39','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:38','95583','E001','183','190');
INSERT INTO prestamo VALUES('34043','30/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:07','31/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:45','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:07','36677','E002','166','200');
INSERT INTO prestamo VALUES('73440','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:08','17/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:13','22/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:08','49941','E002','188','200');
INSERT INTO prestamo VALUES('56230','22/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:51','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:45','26/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:18','91167','E005','194','200');
INSERT INTO prestamo VALUES('30297','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:15','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:49','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:52','96472','E001','109','200');
INSERT INTO prestamo VALUES('85003','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:00','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:36','12/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:09','27472','E001','177','150');
INSERT INTO prestamo VALUES('64095','21/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:48','22/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:08','26/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:23','65525','E004','191','170');
INSERT INTO prestamo VALUES('30477','28/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:06','29/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:49','02/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:53','35283','E003','167','150');
INSERT INTO prestamo VALUES('76184','19/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:16','22/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:04','24/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:16','24638','E005','129','180');
INSERT INTO prestamo VALUES('32768','04/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:45','06/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:00','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:57','23062','E005','127','160');
INSERT INTO prestamo VALUES('18451','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:18','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:46','29/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:22','93335','E001','116','170');
INSERT INTO prestamo VALUES('52684','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:43','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:09','06/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:41','83393','E002','180','160');
INSERT INTO prestamo VALUES('28943','05/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:58','08/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:34','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:01','36095','E001','105','170');
INSERT INTO prestamo VALUES('73900','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:05','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:09','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:40','79562','E007','176','200');
INSERT INTO prestamo VALUES('30733','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:33','14/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:23','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:53','27404','E001','197','160');
INSERT INTO prestamo VALUES('88930','13/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:04','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:42','21/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:14','87181','E001','116','170');
INSERT INTO prestamo VALUES('89688','16/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:37','17/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:12','22/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:39','90938','E002','134','200');
INSERT INTO prestamo VALUES('19582','10/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:26','13/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:45','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:35','81222','E005','152','160');
INSERT INTO prestamo VALUES('91404','22/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:50','23/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:40','28/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:57','57596','E001','143','150');
INSERT INTO prestamo VALUES('13404','18/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:07','21/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:53','25/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:54','93335','E002','101','180');
INSERT INTO prestamo VALUES('92875','14/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:40','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:18','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:52','81222','E002','171','200');
INSERT INTO prestamo VALUES('88395','14/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:01','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:58','20/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:54','84772','E002','102','180');
INSERT INTO prestamo VALUES('24765','14/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:09','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:38','19/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:55','23060','E002','145','200');
INSERT INTO prestamo VALUES('11991','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:18','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:53','05/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:43','67222','E002','150','180');
INSERT INTO prestamo VALUES('40736','25/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:06','28/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:51','28/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:27','65922','E002','139','190');
INSERT INTO prestamo VALUES('62510','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:33','17/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:47','17/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:52','76042','E001','135','190');
INSERT INTO prestamo VALUES('72228','09/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:15','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:05','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:15','88806','E002','114','170');
INSERT INTO prestamo VALUES('87007','02/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:52','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:51','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:20','55518','E002','115','190');
INSERT INTO prestamo VALUES('26021','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:19','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:13','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:11','63249','E001','148','170');
INSERT INTO prestamo VALUES('87697','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:43','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:18','22/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:49','48600','E001','198','200');
INSERT INTO prestamo VALUES('59544','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:22','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:26','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:15','36988','E003','165','200');
INSERT INTO prestamo VALUES('79545','10/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:30','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:14','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:24','93214','E002','105','200');
INSERT INTO prestamo VALUES('87477','15/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:30','21/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:16','21/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:54','61393','E002','156','170');
INSERT INTO prestamo VALUES('65113','02/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:51','04/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:35','06/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:50','90247','E003','154','190');
INSERT INTO prestamo VALUES('83933','24/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:13','28/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:06','02/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:33','78179','E003','120','170');
INSERT INTO prestamo VALUES('71662','14/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:16','15/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:35','21/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:27','67347','E008','198','180');
INSERT INTO prestamo VALUES('89436','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:33','05/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:19','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:33','87450','E002','104','190');
INSERT INTO prestamo VALUES('62474','01/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:51','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:01','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:36','66253','E001','160','150');
INSERT INTO prestamo VALUES('43785','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:19','20/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:28','23/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:12','28076','E002','152','190');
INSERT INTO prestamo VALUES('28233','28/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:55','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:20','05/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:15','71094','E002','187','150');
INSERT INTO prestamo VALUES('27881','30/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:37','31/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:40','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:02','60177','E002','105','190');
INSERT INTO prestamo VALUES('74630','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:41','26/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:05','27/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:21','87450','E001','191','170');
INSERT INTO prestamo VALUES('47411','13/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:26','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:33','21/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:40','91167','E003','198','190');
INSERT INTO prestamo VALUES('48051','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:59','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:36','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:12','32329','E001','144','150');
INSERT INTO prestamo VALUES('78125','11/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:11','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:30','18/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:10','10926','E002','161','190');
INSERT INTO prestamo VALUES('54628','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:09','10/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:26','13/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:54','37873','E002','137','200');
INSERT INTO prestamo VALUES('63890','28/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:06','30/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:46','01/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:15','20866','E002','160','160');
INSERT INTO prestamo VALUES('14983','11/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:00','14/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:46','15/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:03','89870','E003','131','190');
INSERT INTO prestamo VALUES('52029','20/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:00','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:53','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:05','89348','E004','150','160');
INSERT INTO prestamo VALUES('68967','01/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:35','05/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:56','07/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:32','60177','E001','134','160');
INSERT INTO prestamo VALUES('70174','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:25','16/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:57','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:27','25636','E002','120','150');
INSERT INTO prestamo VALUES('24601','14/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:24','16/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:42','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:37','58047','E001','116','180');
INSERT INTO prestamo VALUES('11097','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:35','19/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:46','25/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:35','38018','E001','111','200');
INSERT INTO prestamo VALUES('57616','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:24','11/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:32','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:45','12221','E001','158','180');
INSERT INTO prestamo VALUES('26362','10/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:50','11/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:55','17/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:57','67222','E003','180','200');
INSERT INTO prestamo VALUES('52807','29/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:10','01/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:16','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:39','50687','E003','158','180');
INSERT INTO prestamo VALUES('25913','11/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:53','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:49','18/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:23','79260','E003','184','190');
INSERT INTO prestamo VALUES('12631','22/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:42','25/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:52','29/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:49','37353','E002','159','150');
INSERT INTO prestamo VALUES('90811','08/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:53','12/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:15','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:03','67347','E001','153','170');
INSERT INTO prestamo VALUES('44366','05/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:25','08/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:30','12/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:53','75010','E001','159','180');
INSERT INTO prestamo VALUES('34497','29/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:51','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:43','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:40','67087','E004','147','180');
INSERT INTO prestamo VALUES('17892','01/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:54','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:43','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:15','22764','E001','114','150');
INSERT INTO prestamo VALUES('39621','13/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:20','19/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:06','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:00','81222','E006','155','150');
INSERT INTO prestamo VALUES('61443','13/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:28','12/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:53','19/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:45','44359','E001','131','170');
INSERT INTO prestamo VALUES('35426','21/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:06','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:41','27/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:44','97148','E003','132','150');
INSERT INTO prestamo VALUES('16070','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:24','20/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:14','23/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:37','54814','E005','180','200');
INSERT INTO prestamo VALUES('96064','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:40','28/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:06','30/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:12','85666','E002','108','150');
INSERT INTO prestamo VALUES('86458','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:34','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:28','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:34','25955','E002','183','200');
INSERT INTO prestamo VALUES('76477','26/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:41','29/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:25','03/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:05','32212','E001','155','200');
INSERT INTO prestamo VALUES('50419','07/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:17','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:12','14/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:56','79562','E005','151','190');
INSERT INTO prestamo VALUES('51481','23/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:39','26/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:02','26/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:32','24638','E003','144','200');
INSERT INTO prestamo VALUES('85007','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:16','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:22','04/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:24','93714','E001','101','170');
INSERT INTO prestamo VALUES('14018','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:47','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:45','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:34','65922','E004','121','170');
INSERT INTO prestamo VALUES('34649','13/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:40','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:58','23/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:23','45190','E001','171','180');
INSERT INTO prestamo VALUES('79349','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:07','03/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:47','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:39','69711','E003','157','170');
INSERT INTO prestamo VALUES('86996','15/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:56','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:30','22/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:20','84029','E001','163','160');
INSERT INTO prestamo VALUES('68675','13/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:15','15/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:24','19/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:41','46363','E002','141','160');
INSERT INTO prestamo VALUES('46273','08/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:58','09/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:21','11/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:01','72891','E002','106','200');
INSERT INTO prestamo VALUES('88317','01/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:50','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:54','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:28','90247','E004','148','150');
INSERT INTO prestamo VALUES('73681','06/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:14','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:39','10/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:39','94706','E002','100','150');
INSERT INTO prestamo VALUES('21849','14/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:01','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:05','21/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:39','96472','E002','153','150');
INSERT INTO prestamo VALUES('53058','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:35','11/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:39','12/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:24','67087','E001','169','200');
INSERT INTO prestamo VALUES('71507','02/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:10','05/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:44','07/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:11','79260','E001','183','170');
INSERT INTO prestamo VALUES('73358','01/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:49','04/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:24','09/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:53','24638','E001','132','160');
INSERT INTO prestamo VALUES('21412','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:14','07/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:27','11/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:35','36969','E002','120','160');
INSERT INTO prestamo VALUES('92967','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:54','02/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:14','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:02','52611','E005','145','200');
INSERT INTO prestamo VALUES('60857','19/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:43','21/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:55','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:17','33533','E002','191','190');
INSERT INTO prestamo VALUES('92602','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:20','29/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:08','30/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:56','49129','E004','163','150');
INSERT INTO prestamo VALUES('66419','30/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:29','01/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:39','06/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:14','24385','E002','180','160');
INSERT INTO prestamo VALUES('91110','08/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:17','11/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:49','11/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:50','33533','E001','129','180');
INSERT INTO prestamo VALUES('50243','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:15','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:59','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:11','22381','E002','129','170');
INSERT INTO prestamo VALUES('63985','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:39','11/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:06','14/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:52','48600','E002','103','200');
INSERT INTO prestamo VALUES('84659','25/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:05','26/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:55','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:54','92252','E004','158','190');
INSERT INTO prestamo VALUES('14858','07/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:28','09/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:45','15/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:21','47614','E002','124','190');
INSERT INTO prestamo VALUES('91512','08/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:07','10/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:40','10/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:44','44359','E003','100','170');
INSERT INTO prestamo VALUES('17443','10/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:10','13/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:43','14/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:51','72577','E002','145','150');
INSERT INTO prestamo VALUES('75945','09/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:41','14/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:18','14/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:52','68031','E002','160','200');
INSERT INTO prestamo VALUES('70277','29/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:49','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:48','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:31','67087','E005','179','190');
INSERT INTO prestamo VALUES('67788','06/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:53','07/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:08','08/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:28','25955','E001','124','160');
INSERT INTO prestamo VALUES('32485','26/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:55','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:12','03/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:02','85273','E002','115','190');
INSERT INTO prestamo VALUES('35647','19/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:55','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:52','27/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:18','14975','E001','125','200');
INSERT INTO prestamo VALUES('84269','18/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:51','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:18','22/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:44','22764','E002','112','160');
INSERT INTO prestamo VALUES('88452','23/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:48','26/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:57','28/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:35','83467','E002','160','150');
INSERT INTO prestamo VALUES('11168','03/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:47','08/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:56','07/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:19','27404','E002','125','150');
INSERT INTO prestamo VALUES('50768','04/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:38','06/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:08','11/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:22','61196','E002','152','190');
INSERT INTO prestamo VALUES('83368','26/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:49','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:24','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:43','58114','E001','174','200');
INSERT INTO prestamo VALUES('24110','13/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:59','14/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:43','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:07','75010','E002','190','190');
INSERT INTO prestamo VALUES('65055','11/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:35','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:06','20/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:22','13733','E002','162','190');
INSERT INTO prestamo VALUES('29284','25/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:04','27/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:31','31/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:13','85273','E001','107','190');
INSERT INTO prestamo VALUES('20090','26/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:03','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:32','04/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:45','20475','E001','179','190');
INSERT INTO prestamo VALUES('30564','31/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:19','04/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:56','08/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:37','94738','E002','148','200');
INSERT INTO prestamo VALUES('72308','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:07','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:14','29/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:18','40600','E001','187','160');
INSERT INTO prestamo VALUES('69407','09/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:06','15/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:49','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:46','92022','E002','147','200');
INSERT INTO prestamo VALUES('94785','16/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:15','17/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:08','22/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:13','32458','E003','166','160');
INSERT INTO prestamo VALUES('88388','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:38','10/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:43','12/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:32','10926','E001','166','180');
INSERT INTO prestamo VALUES('21305','28/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:26','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:54','08/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:16','17678','E001','185','160');
INSERT INTO prestamo VALUES('28093','26/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:25','28/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:02','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:34','65922','E001','169','200');
INSERT INTO prestamo VALUES('87123','19/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:14','20/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:07','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:33','57596','E003','166','180');
INSERT INTO prestamo VALUES('32441','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:14','11/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:38','16/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:07','12221','E002','166','190');
INSERT INTO prestamo VALUES('53280','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:01','07/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:22','12/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:04','93214','E005','105','180');
INSERT INTO prestamo VALUES('31065','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:03','06/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:50','10/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:04','46192','E004','135','170');
INSERT INTO prestamo VALUES('89644','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:38','26/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:10','31/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:03','17678','E003','153','170');
INSERT INTO prestamo VALUES('81888','17/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:09','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:41','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:01','45190','E003','102','160');
INSERT INTO prestamo VALUES('56151','22/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:54','27/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:50','26/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:02','94153','E001','188','180');
INSERT INTO prestamo VALUES('92412','23/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:39','28/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:28','28/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:29','64546','E001','151','170');
INSERT INTO prestamo VALUES('87135','16/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:48','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:22','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:28','23062','E002','133','160');
INSERT INTO prestamo VALUES('36803','07/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:14','13/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:13','15/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:20','59841','E003','184','170');
INSERT INTO prestamo VALUES('48174','29/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:31','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:08','09/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:06','79562','E008','150','150');
INSERT INTO prestamo VALUES('35020','02/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:14','05/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:54','05/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:48','57596','E002','150','170');
INSERT INTO prestamo VALUES('75182','02/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:12','03/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:45','05/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:40','45190','E002','168','160');
INSERT INTO prestamo VALUES('87531','10/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:37','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:34','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:46','37873','E001','193','190');
INSERT INTO prestamo VALUES('93140','20/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:45','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:47','24/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:51','49409','E002','186','180');
INSERT INTO prestamo VALUES('57963','16/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:12','18/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:52','23/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:51','13244','E001','178','190');
INSERT INTO prestamo VALUES('20637','12/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:08','14/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:26','17/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:18','94153','E002','186','150');
INSERT INTO prestamo VALUES('65952','02/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:02','03/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:33','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:26','54814','E004','162','160');
INSERT INTO prestamo VALUES('61488','29/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:01','01/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:41','03/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:34','49476','E001','176','200');
INSERT INTO prestamo VALUES('70135','25/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:14','01/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:43','01/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:06','18624','E001','166','160');
INSERT INTO prestamo VALUES('58702','21/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:47','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:50','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:45','27805','E002','170','190');
INSERT INTO prestamo VALUES('76891','13/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:10','18/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:35','21/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:12','67222','E001','180','160');
INSERT INTO prestamo VALUES('63548','25/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:27','27/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:30','31/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:54','28076','E001','139','160');
INSERT INTO prestamo VALUES('66019','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:23','11/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:32','15/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:19','24766','E006','137','160');
INSERT INTO prestamo VALUES('78999','28/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:43','02/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:08','03/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:22','91167','E004','155','170');
INSERT INTO prestamo VALUES('96576','08/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:55','11/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:03','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:47','20223','E002','167','190');
INSERT INTO prestamo VALUES('49923','14/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:15','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:19','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:33','49893','E002','185','180');
INSERT INTO prestamo VALUES('44399','12/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:05','16/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:10','19/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:41','51022','E002','125','150');
INSERT INTO prestamo VALUES('23218','05/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:47','06/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:38','11/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:29','71094','E001','193','170');
INSERT INTO prestamo VALUES('34109','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:59','17/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:06','17/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:57','37333','E001','127','180');
INSERT INTO prestamo VALUES('52573','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:06','09/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:22','13/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:07','79562','E002','102','200');
INSERT INTO prestamo VALUES('28108','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:38','28/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:09','28/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:43','90247','E001','122','190');
INSERT INTO prestamo VALUES('57290','26/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:10','28/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:10','01/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:59','69711','E002','144','200');
INSERT INTO prestamo VALUES('67917','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:31','08/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:48','15/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:26','89348','E003','194','150');
INSERT INTO prestamo VALUES('99117','23/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:10','27/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:01','30/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:38','53290','E001','138','170');
INSERT INTO prestamo VALUES('45605','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:40','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:59','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:44','94706','E003','154','200');
INSERT INTO prestamo VALUES('91178','12/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:42','17/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:35','18/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:27','20475','E002','188','150');
INSERT INTO prestamo VALUES('42809','01/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:19','03/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:58','07/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:12','72891','E003','187','150');
INSERT INTO prestamo VALUES('17225','27/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:09','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:12','03/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:31','32458','E001','157','180');
INSERT INTO prestamo VALUES('38079','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:46','05/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:33','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:15','89870','E002','116','150');
INSERT INTO prestamo VALUES('34458','07/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:43','10/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:46','14/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:07','92252','E001','116','200');
INSERT INTO prestamo VALUES('34516','24/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:45','26/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:55','26/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:14','50495','E002','172','190');
INSERT INTO prestamo VALUES('45149','11/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:56','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:43','19/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:12','35653','E001','185','170');
INSERT INTO prestamo VALUES('34377','24/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:31','30/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:44','29/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:55','39000','E001','123','180');
INSERT INTO prestamo VALUES('66989','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:30','06/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:03','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:23','65922','E006','148','170');
INSERT INTO prestamo VALUES('97542','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:13','07/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:27','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:30','58114','E002','104','160');
INSERT INTO prestamo VALUES('76005','15/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:16','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:01','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:08','37349','E001','133','200');
INSERT INTO prestamo VALUES('88990','02/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:20','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:48','10/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:42','87181','E002','182','170');
INSERT INTO prestamo VALUES('43505','07/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:16','09/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:27','14/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:08','54814','E001','106','150');
INSERT INTO prestamo VALUES('50868','10/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:35','13/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:00','13/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:56','24766','E004','108','160');
INSERT INTO prestamo VALUES('77437','29/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:02','28/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:05','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:10','55314','E001','186','180');
INSERT INTO prestamo VALUES('70944','21/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:39','22/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:01','25/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:12','24638','E007','138','180');
INSERT INTO prestamo VALUES('74970','02/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:24','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:49','08/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:21','67347','E009','150','180');
INSERT INTO prestamo VALUES('38176','25/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:11','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:00','03/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:15','81222','E007','132','200');
INSERT INTO prestamo VALUES('25406','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:58','27/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:06','01/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:41','75010','E003','104','160');
INSERT INTO prestamo VALUES('42143','08/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:36','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:26','14/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:04','92022','E003','178','180');
INSERT INTO prestamo VALUES('90495','10/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:27','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:00','15/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:02','78749','E001','114','170');
INSERT INTO prestamo VALUES('31439','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:10','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:46','19/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:01','19328','E002','198','180');
INSERT INTO prestamo VALUES('12636','29/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:48','30/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:44','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:21','78749','E002','180','200');
INSERT INTO prestamo VALUES('13227','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:43','06/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:27','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:32','97148','E004','157','200');
INSERT INTO prestamo VALUES('34857','19/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:45','21/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:05','25/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:29','23062','E001','194','150');
INSERT INTO prestamo VALUES('95343','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:18','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:36','22/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:42','36677','E001','178','190');
INSERT INTO prestamo VALUES('47688','03/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:37','08/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:55','06/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:29','16799','E002','166','180');
INSERT INTO prestamo VALUES('92760','13/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:10','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:54','25/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:12','52276','E001','121','190');
INSERT INTO prestamo VALUES('26751','16/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:02','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:51','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:56','46192','E003','176','150');
INSERT INTO prestamo VALUES('25135','09/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:54','10/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:51','16/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:04','49476','E002','154','150');
INSERT INTO prestamo VALUES('41416','14/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:50','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:43','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:49','15480','E002','192','150');
INSERT INTO prestamo VALUES('54453','25/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:18','26/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:56','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:52','27404','E003','145','180');
INSERT INTO prestamo VALUES('13066','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:06','18/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:54','21/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:24','92252','E003','159','150');
INSERT INTO prestamo VALUES('17638','25/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:40','26/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:36','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:32','67087','E003','142','200');
INSERT INTO prestamo VALUES('53092','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:19','14/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:46','14/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:06','47827','E001','124','190');
INSERT INTO prestamo VALUES('88656','24/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:57','25/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:25','25/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:27','74191','E002','112','170');
INSERT INTO prestamo VALUES('54973','02/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:53','07/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:20','07/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:32','65525','E003','190','160');
INSERT INTO prestamo VALUES('31334','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:35','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:07','15/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:46','13733','E001','196','190');
INSERT INTO prestamo VALUES('25924','16/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:46','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:22','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:43','50687','E001','112','190');
INSERT INTO prestamo VALUES('57393','02/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:02','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:46','09/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:35','15480','E001','175','190');
INSERT INTO prestamo VALUES('80692','07/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:54','10/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:49','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:58','69711','E001','155','170');
INSERT INTO prestamo VALUES('14287','09/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:22','08/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:16','13/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:37','64546','E002','192','160');
INSERT INTO prestamo VALUES('36652','26/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:29','29/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:00','01/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:53','95268','E002','143','160');
INSERT INTO prestamo VALUES('47578','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:02','03/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:56','05/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:48','92022','E001','145','170');
INSERT INTO prestamo VALUES('41628','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:18','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:52','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:04','61393','E001','176','170');
INSERT INTO prestamo VALUES('13124','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:34','29/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:07','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:47','92022','E004','146','200');
INSERT INTO prestamo VALUES('41250','25/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:08','26/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:44','01/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:03','72577','E001','162','150');
INSERT INTO prestamo VALUES('25333','20/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:16','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:03','26/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:57','52611','E002','145','170');
INSERT INTO prestamo VALUES('96203','27/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:03','30/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:27','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:30','89870','E001','172','160');
INSERT INTO prestamo VALUES('83728','06/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:56','05/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:07','12/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:17','67347','E002','159','200');
INSERT INTO prestamo VALUES('33242','10/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:49','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:51','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:48','50687','E002','156','160');
INSERT INTO prestamo VALUES('58681','08/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:16','11/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:13','12/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:01','49409','E001','135','180');
INSERT INTO prestamo VALUES('66291','09/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:55','10/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:05','15/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:39','58047','E002','107','200');
INSERT INTO prestamo VALUES('19289','22/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:46','25/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:18','29/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:01','36677','E003','151','150');
INSERT INTO prestamo VALUES('98042','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:38','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:11','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:03','52611','E004','176','190');
INSERT INTO prestamo VALUES('15619','23/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:18','22/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:13','28/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:14','65525','E002','120','200');
INSERT INTO prestamo VALUES('45147','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:02','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:57','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:01','65070','E001','199','200');
INSERT INTO prestamo VALUES('81498','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:24','07/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:02','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:22','24766','E007','119','170');
INSERT INTO prestamo VALUES('43644','15/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:55','16/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:54','22/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:54','81222','E001','151','200');
INSERT INTO prestamo VALUES('13585','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:04','28/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:54','27/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:29','61196','E001','148','190');
INSERT INTO prestamo VALUES('63992','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:23','01/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:58','06/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:43','55314','E002','190','160');
INSERT INTO prestamo VALUES('23878','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:02','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:30','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:56','84772','E001','142','150');
INSERT INTO prestamo VALUES('44069','31/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:07','03/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:49','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:07','38303','E001','194','150');
INSERT INTO prestamo VALUES('22006','02/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:54','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:50','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:56','83393','E003','179','200');
INSERT INTO prestamo VALUES('21081','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:31','15/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:27','20/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:51','65525','E005','122','200');
INSERT INTO prestamo VALUES('33797','04/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:05','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:35','06/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:48','95268','E001','195','160');
INSERT INTO prestamo VALUES('13866','10/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:07','12/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:30','12/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:12','19328','E001','138','150');
INSERT INTO prestamo VALUES('50335','19/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:07','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:03','26/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:36','81222','E008','129','160');
INSERT INTO prestamo VALUES('20130','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:46','11/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:59','12/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:29','52083','E001','191','150');
INSERT INTO prestamo VALUES('69759','10/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:34','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:39','17/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:15','39000','E002','153','170');
INSERT INTO prestamo VALUES('21247','24/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:54','23/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:45','29/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:40','20264','E002','142','170');
INSERT INTO prestamo VALUES('42725','23/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:20','22/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:30','27/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:07','18624','E002','186','160');
INSERT INTO prestamo VALUES('64038','22/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:08','25/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:22','29/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:08','79562','E006','182','200');
INSERT INTO prestamo VALUES('83300','10/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:42','09/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:49','14/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:53','66253','E002','101','170');
INSERT INTO prestamo VALUES('99020','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:08','16/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:24','22/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:54','67347','E004','197','170');
INSERT INTO prestamo VALUES('65811','06/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:32','08/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:45','11/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:08','24766','E005','129','190');
INSERT INTO prestamo VALUES('49125','07/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:58','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:12','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:56','16799','E003','163','180');
INSERT INTO prestamo VALUES('27330','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:58','27/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:34','31/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:18','92252','E002','160','170');
INSERT INTO prestamo VALUES('54220','13/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:46','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:34','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:55','93214','E003','119','180');
INSERT INTO prestamo VALUES('52108','21/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:08','22/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:18','22/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:10','56092','E001','186','170');
INSERT INTO prestamo VALUES('79132','04/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:27','05/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:29','05/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:44','27472','E003','189','160');
INSERT INTO prestamo VALUES('72417','10/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:30','09/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:19','18/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:01','13244','E002','149','160');
INSERT INTO prestamo VALUES('87410','01/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:10','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:47','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:46','94706','E001','133','200');
INSERT INTO prestamo VALUES('15368','04/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:59','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:04','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:06','47827','E003','102','170');
INSERT INTO prestamo VALUES('44677','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:38','04/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:15','04/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:50','20008','E002','170','150');
INSERT INTO prestamo VALUES('71777','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:26','16/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:58','21/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:07','24638','E002','183','150');
INSERT INTO prestamo VALUES('34267','16/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:59','17/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:44','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:54','17678','E002','128','200');
INSERT INTO prestamo VALUES('42778','06/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:25','12/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:20','14/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:09','52611','E001','136','170');
INSERT INTO prestamo VALUES('77115','17/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:06','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:29','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:36','57145','E002','125','160');
INSERT INTO prestamo VALUES('14992','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:56','20/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:25','24/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:14','97187','E002','161','170');
INSERT INTO prestamo VALUES('96555','10/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:08','15/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:27','14/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:18','69767','E001','121','170');
INSERT INTO prestamo VALUES('32930','16/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:53','18/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:50','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:10','32211','E001','143','160');
INSERT INTO prestamo VALUES('68781','30/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:27','04/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:50','07/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:21','35283','E002','108','200');
INSERT INTO prestamo VALUES('51217','14/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:13','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:42','21/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:08','97187','E001','149','170');
INSERT INTO prestamo VALUES('14811','18/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:51','17/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:53','21/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:29','38018','E002','196','160');
INSERT INTO prestamo VALUES('82557','14/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:06','19/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:56','22/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:27','63249','E002','138','170');
INSERT INTO prestamo VALUES('38182','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:53','24/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:49','28/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:26','78179','E004','108','190');
INSERT INTO prestamo VALUES('57398','12/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:17','18/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:51','18/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:20','66776','E003','105','170');
INSERT INTO prestamo VALUES('15881','08/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:43','10/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:59','10/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:13','87795','E002','101','160');
INSERT INTO prestamo VALUES('45659','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:54','21/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:54','21/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:42','14975','E002','183','190');
INSERT INTO prestamo VALUES('85834','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:04','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:59','28/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:42','80820','E001','147','160');
INSERT INTO prestamo VALUES('24271','17/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:17','23/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:05','22/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:53','24385','E003','191','200');
INSERT INTO prestamo VALUES('32196','23/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:32','25/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:54','25/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:15','39527','E001','120','200');
INSERT INTO prestamo VALUES('81606','23/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:45','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:57','26/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:52','65922','E005','150','180');
INSERT INTO prestamo VALUES('23532','23/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:10','22/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:31','26/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:01','23060','E003','146','170');
INSERT INTO prestamo VALUES('83581','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:03','12/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:11','20/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:44','65922','E008','135','150');
INSERT INTO prestamo VALUES('10423','30/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:32','31/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:00','31/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:06','67347','E003','103','180');
INSERT INTO prestamo VALUES('57691','27/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:16','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:54','02/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:47','79562','E004','174','200');
INSERT INTO prestamo VALUES('58230','29/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:16','30/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:32','04/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:42','53290','E002','198','200');
INSERT INTO prestamo VALUES('25575','17/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:32','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:42','21/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:57','36988','E001','162','160');
INSERT INTO prestamo VALUES('43944','13/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:21','19/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:23','21/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:14','26836','E001','168','150');
INSERT INTO prestamo VALUES('20551','06/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:25','09/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:12','13/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:46','11976','E002','198','160');
INSERT INTO prestamo VALUES('89530','27/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:17','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:32','30/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:26','36581','E002','121','170');
INSERT INTO prestamo VALUES('11283','30/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:59','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:31','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:34','52276','E002','169','180');
INSERT INTO prestamo VALUES('87592','01/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:34','03/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:31','04/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:17','27472','E002','166','160');
INSERT INTO prestamo VALUES('81502','15/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:47','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:47','22/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:14','50687','E004','126','190');
INSERT INTO prestamo VALUES('23204','31/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:19','03/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:45','04/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:16','78870','E002','151','150');
INSERT INTO prestamo VALUES('12482','06/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:39','09/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:42','10/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:36','92022','E005','174','170');
INSERT INTO prestamo VALUES('98157','04/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:39','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:05','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:53','52611','E006','137','190');
INSERT INTO prestamo VALUES('67088','17/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:56','20/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:10','22/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:07','68031','E001','130','160');
INSERT INTO prestamo VALUES('88961','16/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:16','18/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:48','22/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:27','65070','E002','126','180');
INSERT INTO prestamo VALUES('91280','16/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:54','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:50','18/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:22','24766','E009','146','180');
INSERT INTO prestamo VALUES('48924','23/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:00','24/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:32','24/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:43','97148','E002','128','180');
INSERT INTO prestamo VALUES('84462','17/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:27','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:19','19/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:37','37349','E002','125','150');
INSERT INTO prestamo VALUES('41966','14/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:22','18/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:16','21/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:21','93214','E004','183','180');
INSERT INTO prestamo VALUES('78463','17/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:26','21/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:56','23/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:33','25636','E001','190','190');
INSERT INTO prestamo VALUES('28311','21/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:49','25/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:22','28/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:18','81222','E009','141','160');
INSERT INTO prestamo VALUES('34198','10/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:30','13/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:18','15/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:40','89348','E002','130','150');
INSERT INTO prestamo VALUES('29853','07/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:59','08/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:34','12/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:40','62470','E002','125','160');
INSERT INTO prestamo VALUES('55172','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:39','25/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:11','28/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:55','87795','E001','135','160');
INSERT INTO prestamo VALUES('49477','25/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:43','26/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:08','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:53','90140','E002','119','160');
INSERT INTO prestamo VALUES('67351','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:56','09/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:30','14/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:56','36988','E002','126','150');
INSERT INTO prestamo VALUES('64402','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:32','17/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:47','20/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:24','49129','E001','106','160');
INSERT INTO prestamo VALUES('29272','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:31','20/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:08','20/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:13','19056','E003','141','190');
INSERT INTO prestamo VALUES('66808','17/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:48','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:19','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:06','24385','E004','100','190');
INSERT INTO prestamo VALUES('83813','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:53','22/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:24','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:37','49129','E003','131','150');
INSERT INTO prestamo VALUES('39836','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:28','14/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:14','16/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:28','47827','E002','114','150');
INSERT INTO prestamo VALUES('56224','16/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:09','20/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:25','22/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:14','32329','E002','171','180');
INSERT INTO prestamo VALUES('96142','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:20','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:17','13/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:49','67222','E004','135','160');
INSERT INTO prestamo VALUES('20778','05/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:40','07/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:52','10/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:07','35283','E001','120','200');
INSERT INTO prestamo VALUES('66703','04/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:04','11/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:29','10/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:15','88904','E001','197','190');
INSERT INTO prestamo VALUES('56963','15/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:52','20/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:59','20/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:40','55518','E001','108','200');
INSERT INTO prestamo VALUES('90595','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:08','03/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:07','08/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:07','11611','E001','170','190');
INSERT INTO prestamo VALUES('30403','01/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:14','03/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:09','07/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:33','32458','E002','106','160');
INSERT INTO prestamo VALUES('78338','12/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:08','15/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:46','18/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:11','67347','E006','147','200');
INSERT INTO prestamo VALUES('33513','10/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:53','12/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:04','16/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:51','11976','E001','170','160');
INSERT INTO prestamo VALUES('64310','05/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:55','08/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:38','12/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:24','92022','E006','161','150');
INSERT INTO prestamo VALUES('75388','28/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:25','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:59','01/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:10','23062','E003','192','180');
INSERT INTO prestamo VALUES('34205','25/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:39','28/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:37','01/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:43','89348','E001','150','180');
INSERT INTO prestamo VALUES('70111','28/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:46','30/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:20','03/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:39','24638','E009','171','190');
INSERT INTO prestamo VALUES('31499','02/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:22','05/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:42','06/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:13','59841','E004','183','180');
INSERT INTO prestamo VALUES('86431','19/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:51','23/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:19','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:40','91167','E002','141','180');
INSERT INTO prestamo VALUES('75993','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:07','11/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:33','15/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:55','36969','E001','144','160');
INSERT INTO prestamo VALUES('43894','23/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:50','27/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:52','30/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:17','25955','E003','191','160');
INSERT INTO prestamo VALUES('97186','20/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:55','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:43','25/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:23','20475','E005','182','150');
INSERT INTO prestamo VALUES('89388','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:28','09/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:07','15/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:38','35653','E002','107','170');
INSERT INTO prestamo VALUES('48612','01/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:54','02/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:47','06/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:53','46192','E001','108','150');
INSERT INTO prestamo VALUES('85253','07/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'09:25','08/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'20:42','09/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:31','24766','E002','197','170');
INSERT INTO prestamo VALUES('23296','20/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:42','26/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:51','28/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:12','74191','E001','106','180');
INSERT INTO prestamo VALUES('96543','03/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:48','05/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:55','07/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:07','78179','E001','153','160');
INSERT INTO prestamo VALUES('19771','03/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:36','06/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:36','11/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:17','79562','E003','173','180');
INSERT INTO prestamo VALUES('61326','27/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:39','30/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:48','03/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:13','24638','E004','157','150');
INSERT INTO prestamo VALUES('62322','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:09','22/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:13','22/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:52','49941','E003','186','150');
INSERT INTO prestamo VALUES('34632','02/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:15','05/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:43','08/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:04','95098','E001','194','200');
INSERT INTO prestamo VALUES('36185','01/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:17','04/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'10:15','08/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:32','20223','E001','119','180');
INSERT INTO prestamo VALUES('75162','26/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:44','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:56','04/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:41','20866','E001','111','150');
INSERT INTO prestamo VALUES('86395','08/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:26','12/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:04','14/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:17','50495','E001','146','180');
INSERT INTO prestamo VALUES('59029','07/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:31','09/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:54','10/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:34','40600','E002','174','200');
INSERT INTO prestamo VALUES('44107','15/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:52','19/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:46','20/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:24','46363','E001','164','190');
INSERT INTO prestamo VALUES('95966','07/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:20','10/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:39','14/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'14:44','42892','E003','121','150');
INSERT INTO prestamo VALUES('91859','26/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'21:34','31/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:32','02/06'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:24','42892','E001','156','170');
INSERT INTO prestamo VALUES('41359','25/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:40','26/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'17:17','02/02'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'18:41','52083','E004','163','190');
INSERT INTO prestamo VALUES('13495','15/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:47','16/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:42','18/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:26','57145','E001','167','190');
INSERT INTO prestamo VALUES('95103','30/09'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:33','06/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:52','06/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:15','59841','E002','171','170');
INSERT INTO prestamo VALUES('56700','25/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:43','27/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'16:24','30/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'14:08','88806','E001','188','170');
INSERT INTO prestamo VALUES('86564','22/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:40','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'20:09','29/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'18:32','24638','E008','148','190');
INSERT INTO prestamo VALUES('58878','21/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'10:11','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:23','26/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:15','65525','E001','194','160');
INSERT INTO prestamo VALUES('53298','28/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:36','30/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:28','30/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'11:42','24638','E006','161','200');
INSERT INTO prestamo VALUES('73023','22/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:57','24/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'08:44','28/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:16','24766','E003','126','160');
INSERT INTO prestamo VALUES('10775','23/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:22','28/11'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'13:02','01/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'15:57','80820','E002','184','180');
INSERT INTO prestamo VALUES('73630','30/03'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:09','02/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:21','03/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:21','24766','E008','196','200');
INSERT INTO prestamo VALUES('64862','14/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'08:40','17/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'21:38','20/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'19:33','91167','E001','190','180');
INSERT INTO prestamo VALUES('10571','17/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'15:47','21/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'13:19','28/07'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'17:38','26836','E002','191','170');
INSERT INTO prestamo VALUES('75220','11/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'19:02','14/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'12:19','14/01'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),'11:26','81222','E003','192','160');
INSERT INTO prestamo VALUES('84480','23/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'16:47','24/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'12:45','27/04'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-2),'09:41','52611','E003','108','170');
COMMIT;


EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'ESCUELA',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'ALUMNO',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'PRESTAMO',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'LIBRO',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'VALOR_MULTA_PRESTAMO',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'REBAJA_MULTA',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'DETALLE_PRESTAMO_MENSUAL',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'AUTOR',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'CARRERA',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'EDITORIAL',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'EJEMPLAR',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'PRY2205_USER1',tabname => 'EMPLEADO',estimate_percent => 100);
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'AUTOR_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'CARRERA_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'EDITORIAL_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'EJEMPLAR_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'EMPLEADO_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'ESCUELA_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'ALUMNO_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'PRESTAMO_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'LIBRO_PK');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'PK_VALOR_MULTA_PRESTAMO');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'PK_REBAJA_MULTA');
EXEC DBMS_STATS.GATHER_INDEX_STATS (ownname => 'PRY2205_USER1', indname => 'PK_DET_PRESTAMO_MENSUAL');

COMMIT;


  -- CASO 1 - Parte 3: SINÓNIMOS Y PERMISOS
  -- EJECUTAR CON: PRY2205_USER1

  -- Crear Sinónimos Públicos
  -- Esto oculta el nombre real "PRY2205_USER1.TABLA"
  CREATE OR REPLACE PUBLIC SYNONYM SYN_LIBRO FOR PRY2205_USER1.LIBRO;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_EJEMPLAR FOR PRY2205_USER1.EJEMPLAR;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_PRESTAMO FOR PRY2205_USER1.PRESTAMO;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_EMPLEADO FOR PRY2205_USER1.EMPLEADO;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_ALUMNO FOR PRY2205_USER1.ALUMNO;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_CARRERA FOR PRY2205_USER1.CARRERA;
  CREATE OR REPLACE PUBLIC SYNONYM SYN_REBAJA FOR PRY2205_USER1.REBAJA_MULTA;

  -- Otorgar permisos de lectura al Rol del Programador (ROL_P)
  GRANT SELECT ON LIBRO TO PRY2205_ROL_P;
  GRANT SELECT ON EJEMPLAR TO PRY2205_ROL_P;
  GRANT SELECT ON PRESTAMO TO PRY2205_ROL_P;
  GRANT SELECT ON EMPLEADO TO PRY2205_ROL_P;
  GRANT SELECT ON ALUMNO TO PRY2205_ROL_P;
  GRANT SELECT ON CARRERA TO PRY2205_ROL_P;
  GRANT SELECT ON REBAJA_MULTA TO PRY2205_ROL_P;

  COMMIT;


-- CASO 2: CREACIÓN DE INFORME Y SECUENCIA
-- EJECUTAR CON: PRY2205_USER2

DROP SEQUENCE SEQ_CONTROL_STOCK;
DROP TABLE CONTROL_STOCK_LIBROS;

CREATE SEQUENCE SEQ_CONTROL_STOCK
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE CONTROL_STOCK_LIBROS AS
SELECT 
    ROWNUM AS "ID_CONTROL",
    libroid AS "ID_LIBRO",
    nombre_libro AS "NOMBRE_LIBRO",
    total_ejemplares AS "TOTAL_EJEMPLARES",
    ejemplares_prestamo AS "EN_PRESTAMO",
    ejemplares_disponibles AS "DISPONIBLES",
    porc_prestamo AS "PORCENTAJE_PRESTAMO",
    stock_critico AS "STOCK_CRITICO"
FROM (
    SELECT 
        l.libroid,
        l.nombre_libro,
        COUNT(DISTINCT e.ejemplarid) AS total_ejemplares,
        COUNT(DISTINCT CASE 
            WHEN p.fecha_entrega IS NULL 
            THEN e.ejemplarid 
        END) AS ejemplares_prestamo,
        COUNT(DISTINCT e.ejemplarid) - COUNT(DISTINCT CASE 
            WHEN p.fecha_entrega IS NULL 
            THEN e.ejemplarid 
        END) AS ejemplares_disponibles,
        ROUND(
            (COUNT(DISTINCT CASE 
                WHEN p.fecha_entrega IS NULL 
                THEN e.ejemplarid 
            END) * 100.0) / 
            NULLIF(COUNT(DISTINCT e.ejemplarid), 0)
        ) AS porc_prestamo,
        CASE 
            WHEN (COUNT(DISTINCT e.ejemplarid) - COUNT(DISTINCT CASE 
                WHEN p.fecha_entrega IS NULL 
                THEN e.ejemplarid 
            END)) > 2 
            THEN 'S'
            ELSE 'N'
        END AS stock_critico
    FROM 
        SYN_LIBRO l
        INNER JOIN SYN_EJEMPLAR e ON l.libroid = e.libroid
        LEFT JOIN SYN_PRESTAMO p ON e.libroid = p.libroid 
            AND e.ejemplarid = p.ejemplarid
            AND TO_CHAR(p.fecha_inicio, 'YYYY') = TO_CHAR(ADD_MONTHS(SYSDATE, -24), 'YYYY')
            AND p.empleadoid IN (190, 180, 150)
    GROUP BY 
        l.libroid,
        l.nombre_libro
    ORDER BY 
        l.libroid
);

COMMIT;
-- Consultar la tabla creada
SELECT * FROM CONTROL_STOCK_LIBROS;



-- CASO 3: OPTIMIZACIÓN DE SENTENCIAS SQL

-- CASO 3 - Parte 1: CREACIÓN DE VISTA
-- USUARIO PRY2205_USER1
-- Vista de detalle de multas por préstamos atrasados

CREATE OR REPLACE VIEW VW_DETALLE_MULTAS AS
SELECT 
    p.prestamoid AS "ID_PRESTAMO",
    a.nombre || ' ' || a.apaterno AS "NOMBRE_ALUMNO",
    c.descripcion AS "NOMBRE_CARRERA",
    l.libroid AS "ID_LIBRO",
    REPLACE(TO_CHAR(l.precio, 'L9G999G999'), ',', '.') AS "VALOR_LIBRO",
    p.fecha_termino AS "FECHA_TERMINO",
    p.fecha_entrega AS "FECHA_ENTREGA",
    TO_DATE(p.fecha_entrega, 'DD/MM/YYYY') - TO_DATE(p.fecha_termino, 'DD/MM/YYYY') AS "DIAS_ATRASO",
    REPLACE(TO_CHAR(ROUND(
        l.precio * 0.03 * 
        (TO_DATE(p.fecha_entrega, 'DD/MM/YYYY') - TO_DATE(p.fecha_termino, 'DD/MM/YYYY'))
    ), 'L9G999G999'), ',', '.') AS "VALOR_MULTA",
    
    TO_CHAR(NVL(rm.porc_rebaja_multa, 0)) AS "PORCENTA_REBAJA_MULTA",
    
    REPLACE(TO_CHAR(ROUND(
        l.precio * 0.03 * 
        (TO_DATE(p.fecha_entrega, 'DD/MM/YYYY') - TO_DATE(p.fecha_termino, 'DD/MM/YYYY')) *
        (1 - NVL(rm.porc_rebaja_multa, 0) / 100)
    ), 'L9G999G999'), ',', '.') AS "VALOR_REBAJADO"
FROM 
    SYN_PRESTAMO p
    INNER JOIN SYN_ALUMNO a ON p.alumnoid = a.alumnoid
    INNER JOIN SYN_CARRERA c ON a.carreraid = c.carreraid
    INNER JOIN SYN_LIBRO l ON p.libroid = l.libroid
    LEFT JOIN SYN_REBAJA_MULTA rm ON c.carreraid = rm.carreraid
WHERE 
    TO_CHAR(p.fecha_termino, 'YYYY') = TO_CHAR(ADD_MONTHS(SYSDATE, -24), 'YYYY')
    AND TO_DATE(p.fecha_entrega, 'DD/MM/YYYY') > TO_DATE(p.fecha_termino, 'DD/MM/YYYY')
ORDER BY 
    p.fecha_entrega DESC;

-- Consultar la vista
SELECT * FROM VW_DETALLE_MULTAS;

-- Analizar el plan de ejecución ANTES de crear índices
EXPLAIN PLAN FOR
SELECT * FROM VW_DETALLE_MULTAS;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);



-- CASO 3 - Parte 2: CREACIÓN DE ÍNDICES
-- USUARIO PRY2205_USER1
-- Índices para optimizar el rendimiento de la vista


-- Índice compuesto para tabla PRESTAMO (mejora JOIN y filtros WHERE)
CREATE INDEX IDX_PRESTAMO_FECHA_ALUMNO 
ON PRESTAMO(fecha_termino, alumnoid, libroid);

-- Índice para tabla ALUMNO (mejora JOIN con CARRERA)
CREATE INDEX IDX_ALUMNO_CARRERA 
ON ALUMNO(carreraid, alumnoid);

-- Índice para tabla LIBRO (mejora JOIN y acceso a precio)
CREATE INDEX IDX_LIBRO_ID 
ON LIBRO(libroid);

-- Índice para tabla CARRERA (mejora JOIN con REBAJA_MULTA)
CREATE INDEX IDX_CARRERA_ID 
ON CARRERA(carreraid);

-- Recolectar estadísticas después de crear índices
EXEC DBMS_STATS.GATHER_INDEX_STATS('PRY2205_USER1', 'IDX_PRESTAMO_FECHA_ALUMNO');
EXEC DBMS_STATS.GATHER_INDEX_STATS('PRY2205_USER1', 'IDX_ALUMNO_CARRERA');
EXEC DBMS_STATS.GATHER_INDEX_STATS('PRY2205_USER1', 'IDX_LIBRO_ID');
EXEC DBMS_STATS.GATHER_INDEX_STATS('PRY2205_USER1', 'IDX_CARRERA_ID');

-- Analizar el plan de ejecución DESPUÉS de crear índices
EXPLAIN PLAN FOR
SELECT * FROM VW_DETALLE_MULTAS;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Verificar el uso de los índices
SELECT * FROM VW_DETALLE_MULTAS WHERE ROWNUM <= 10;