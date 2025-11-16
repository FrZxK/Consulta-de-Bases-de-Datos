
/* ---- DEFINIR FORMATO FECHA DD/MM/YYYY ---- */
ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';

/* ---- BORRADO DE OBJETOS ---- */

DROP TABLE bono_escolar CASCADE CONSTRAINTS;

DROP TABLE trabajador CASCADE CONSTRAINTS;

DROP TABLE asignacion_familiar CASCADE CONSTRAINTS;

DROP TABLE tickets_concierto CASCADE CONSTRAINTS;

DROP TABLE comisiones_ticket CASCADE CONSTRAINTS;

DROP TABLE bono_antiguedad CASCADE CONSTRAINTS;

DROP TABLE isapre CASCADE CONSTRAINTS;

DROP TABLE afp CASCADE CONSTRAINTS;

DROP TABLE comuna_ciudad CASCADE CONSTRAINTS;

DROP TABLE tipo_trabajador CASCADE CONSTRAINTS;

DROP TABLE estado_civil CASCADE CONSTRAINTS;

DROP TABLE est_civil CASCADE CONSTRAINTS;

DROP TABLE detalle_bonificaciones_trabajador CASCADE CONSTRAINTS;

DROP SEQUENCE seq_det_bonif;

DROP SEQUENCE seq_cat;

DROP SEQUENCE seq_com;

DROP SEQUENCE seq_porc_com_annos;
 
/* ---- CREACIÓN DE OBJETOS ---- */

CREATE SEQUENCE seq_cat;

CREATE SEQUENCE seq_com START WITH 80;

CREATE SEQUENCE seq_porc_com_annos;

CREATE SEQUENCE seq_det_bonif START WITH 100 INCREMENT BY 10;

CREATE TABLE afp (
  cod_afp         NUMBER(2)
    CONSTRAINT pk_afp PRIMARY KEY,
  nombre_afp      VARCHAR2(30) NOT NULL,
  porc_descto_afp NUMBER(2) NOT NULL
);

CREATE TABLE isapre (
  cod_isapre         NUMBER(2)
    CONSTRAINT pk_isapre PRIMARY KEY,
  nombre_isapre      VARCHAR2(30) NOT NULL,
  porc_descto_isapre NUMBER(2) NOT NULL
);

CREATE TABLE comuna_ciudad (
  id_ciudad     NUMBER(3) NOT NULL,
  nombre_ciudad VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_ciudad PRIMARY KEY ( id_ciudad )
);

CREATE TABLE tipo_trabajador (
  id_categoria   NUMBER(1) NOT NULL,
  desc_categoria VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_tipo_trab PRIMARY KEY ( id_categoria )
);

CREATE TABLE estado_civil (
  id_estcivil   NUMBER(1) NOT NULL,
  desc_estcivil VARCHAR2(25) NOT NULL,
  CONSTRAINT pk_estado_civil_ PRIMARY KEY ( id_estcivil )
);

CREATE TABLE bono_escolar (
  id_escolar NUMBER(2) NOT NULL,
  sigla      VARCHAR2(6) NOT NULL,
  descrip    VARCHAR2(50) NOT NULL,
  porc_bono  NUMBER(2),
  CONSTRAINT pk_escolaridad PRIMARY KEY ( id_escolar )
);

CREATE TABLE trabajador (
  numrut           NUMBER(10) NOT NULL,
  dvrut            VARCHAR2(1) NOT NULL,
  appaterno        VARCHAR2(20) NOT NULL,
  apmaterno        VARCHAR2(20) NOT NULL,
  nombre           VARCHAR2(25) NOT NULL,
  direccion        VARCHAR2(35) NOT NULL,
  fonofijo         VARCHAR2(15) NOT NULL,
  fecnac           DATE,
  fecing           DATE NOT NULL,
  sueldo_base      NUMBER(7) NOT NULL,
  id_ciudad        NUMBER(3),
  id_categoria_t   NUMBER(1),
  id_escolaridad_t NUMBER(2) NOT NULL,
  cod_afp          NUMBER(2) NOT NULL,
  cod_isapre       NUMBER(2) NOT NULL,
  CONSTRAINT pk_trabajador PRIMARY KEY ( numrut ),
  CONSTRAINT fk_trabajador_ciudad FOREIGN KEY ( id_ciudad )
    REFERENCES comuna_ciudad ( id_ciudad ),
  CONSTRAINT fk_trabajador_afp FOREIGN KEY ( cod_afp )
    REFERENCES afp ( cod_afp ),
  CONSTRAINT fk_trabajador_isapre FOREIGN KEY ( cod_isapre )
    REFERENCES isapre ( cod_isapre ),
  CONSTRAINT fk_trabajador_escolaridad FOREIGN KEY ( id_escolaridad_t )
    REFERENCES bono_escolar ( id_escolar ),
  CONSTRAINT fk_trabajador_tipo_t FOREIGN KEY ( id_categoria_t )
    REFERENCES tipo_trabajador ( id_categoria )
);

CREATE TABLE asignacion_familiar (
  numrut_carga    NUMBER(10) NOT NULL
    CONSTRAINT pk_asg_familiar PRIMARY KEY,
  dvrut_carga     VARCHAR2(1) NOT NULL,
  appaterno_carga VARCHAR2(15) NOT NULL,
  apmaterno_carga VARCHAR2(15) NOT NULL,
  nombre_carga    VARCHAR2(25) NOT NULL,
  numrut_t        NUMBER(10) NOT NULL,
  CONSTRAINT fk_asgn_familiar_t FOREIGN KEY ( numrut_t )
    REFERENCES trabajador ( numrut )
);

CREATE TABLE detalle_bonificaciones_trabajador (
  num                   NUMBER(10)
    CONSTRAINT pk_det_bont PRIMARY KEY,
  rut                   VARCHAR2(20 BYTE),
  nombre_trabajador     VARCHAR2(70 BYTE),
  sueldo_base           NUMBER(7) NOT NULL,
  num_ticket            VARCHAR2(12) NOT NULL,
  direccion             VARCHAR2(50) NOT NULL,
  sistema_salud         VARCHAR2(30) NOT NULL,
  monto                 NUMBER(8) NOT NULL,
  bonif_x_ticket        NUMBER(8) NOT NULL,
  simulacion_x_ticket   NUMBER(8) NOT NULL,
  simulacion_antiguedad NUMBER(8) NOT NULL
);

CREATE TABLE tickets_concierto (
  nro_ticket   NUMBER(10) PRIMARY KEY,
  fecha_ticket DATE NOT NULL,
  monto_ticket NUMBER(15) NOT NULL,
  id_cliente   NUMBER(10) NOT NULL,
  numrut_t     NUMBER(10) NOT NULL,
  CONSTRAINT fk_ftrabajador FOREIGN KEY ( numrut_t )
    REFERENCES trabajador ( numrut )
);

CREATE TABLE bono_antiguedad (
  id              NUMBER(2)
    CONSTRAINT pk_annos_trabajados PRIMARY KEY,
  limite_inferior NUMBER(2) NOT NULL,
  limite_superior NUMBER(2) NOT NULL,
  porcentaje      NUMBER(3, 2) NOT NULL
);

CREATE TABLE comisiones_ticket (
  nro_ticket     NUMBER(10) NOT NULL PRIMARY KEY,
  valor_comision NUMBER(10) NOT NULL,
  CONSTRAINT fk_vta_ticket FOREIGN KEY ( nro_ticket )
    REFERENCES tickets_concierto ( nro_ticket )
);

CREATE TABLE est_civil (
  numrut_t        NUMBER(10) NOT NULL,
  id_estcivil_est NUMBER(1) NOT NULL,
  fecini_estcivil DATE NOT NULL,
  fecter_estcivil DATE,
  CONSTRAINT pk_est_civil PRIMARY KEY ( numrut_t,
                                        id_estcivil_est ),
  CONSTRAINT fk_est_civil_trab FOREIGN KEY ( numrut_t )
    REFERENCES trabajador ( numrut ),
  CONSTRAINT fk_civil_estciv FOREIGN KEY ( id_estcivil_est )
    REFERENCES estado_civil ( id_estcivil )
); 



  
-- insercion de datos

INSERT INTO afp VALUES (
  1,
  'MODELO',
  9
);

INSERT INTO afp VALUES (
  2,
  'PLANVITAL',
  15
);

INSERT INTO afp VALUES (
  3,
  'CAPITAL',
  11
);

INSERT INTO afp VALUES (
  4,
  'CUPRUM',
  12
);

INSERT INTO afp VALUES (
  5,
  'PROVIDA',
  11
);

INSERT INTO afp VALUES (
  6,
  'HABITAT',
  15
);

-- insercion de datos
INSERT INTO isapre VALUES (
  1,
  'FONASA',
  5
);

INSERT INTO isapre VALUES (
  2,
  'BAN MEDICA',
  10
);

INSERT INTO isapre VALUES (
  3,
  'COLMENA',
  8
);

INSERT INTO isapre VALUES (
  4,
  'Fundacion',
  12
);

INSERT INTO isapre VALUES (
  5,
  'CRUZ BLANCA',
  12
);

INSERT INTO isapre VALUES (
  6,
  'MAS VIDA',
  6
);

INSERT INTO isapre VALUES (
  7,
  'VIDA TRES',
  11
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Las Condes'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Providencia'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Santiago'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'nunoa'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Vitacura'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'La Reina'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'La Florida'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Maipu'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Lo Barnechea'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Macul'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'San Miguel'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Penalolen'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Puente Alto'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Recoleta'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Estacion Central'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'San Bernardo'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Independencia'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'La Cisterna'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Quilicura'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Quinta Normal'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Conchali'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'San Joaquin'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Huechuraba'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'El Bosque'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Cerrillos'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Cerro Navia'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'La Granja'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'La Pintana'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Lo Espejo'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Lo Prado'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Pedro Aguirre Cerda'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Pudahuel'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Renca'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'San Ramon'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Melipilla'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'San Pedro'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Alhue'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Maria Pinto'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Curacavi'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Talagante'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'El Monte'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Buin'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Paine'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Penaflor'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Isla de Maipo'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Colina'
);

INSERT INTO comuna_ciudad VALUES (
  seq_com.NEXTVAL,
  'Pirque'
);

INSERT INTO tipo_trabajador VALUES (
  seq_cat.NEXTVAL,
  'VENDEDOR HONORARIOS'
);

INSERT INTO tipo_trabajador VALUES (
  seq_cat.NEXTVAL,
  'PLANTA'
);

INSERT INTO tipo_trabajador VALUES (
  seq_cat.NEXTVAL,
  'CAJERO'
);

INSERT INTO tipo_trabajador VALUES (
  seq_cat.NEXTVAL,
  'CONTRATO PLAZO FIJO'
);

INSERT INTO estado_civil VALUES (
  1,
  'Soltero'
);

INSERT INTO estado_civil VALUES (
  2,
  'Casado'
);

INSERT INTO estado_civil VALUES (
  3,
  'Separado'
);

INSERT INTO estado_civil VALUES (
  4,
  'Divorciado'
);

INSERT INTO estado_civil VALUES (
  5,
  'Viudo'
);

INSERT INTO bono_escolar VALUES (
  10,
  'BA',
  'BaSICA',
  1
);

INSERT INTO bono_escolar VALUES (
  20,
  'MCH',
  'MEDIA CIENTiFICA HUMANISTA',
  2
);

INSERT INTO bono_escolar VALUES (
  30,
  'MTP',
  'MEDIA TeCNICO PROFESIONAL',
  3
);

INSERT INTO bono_escolar VALUES (
  40,
  'SCFT',
  'SUPERIOR CENTRO DE FORMACIoN TeCNICA',
  4
);

INSERT INTO bono_escolar VALUES (
  50,
  'SIP',
  'SUPERIOR INSTITUTO PROFESIONAL',
  5
);

INSERT INTO bono_escolar VALUES (
  60,
  'SUO',
  'SUPERIOR UNIVERSIDAD',
  6
);

INSERT INTO trabajador VALUES (
  11649964,
  '0',
  'GALVEZ',
  'CASTRO',
  'MARTA',
  'CLOVIS MONTERO 0260 D/202',
  '23417556',
  '20121971',
  '01071996',
  1515239,
  80,
  1,
  10,
  1,
  1
);

INSERT INTO trabajador VALUES (
  12113369,
  '4',
  'ROMERO',
  'DIAZ',
  'NANCY',
  'TENIENTE RAMON JIMENEZ 4753',
  '25631567',
  '09011968',
  '01081991',
  2710153,
  81,
  3,
  20,
  2,
  1
);

INSERT INTO trabajador VALUES (
  12456905,
  '1',
  'CANALES',
  'BASTIAS',
  'JORGE',
  'GENERAL CONCHA PEDREGAL #885',
  '27413395',
  '21121957',
  '01091983',
  2945675,
  81,
  3,
  20,
  2,
  1
);

INSERT INTO trabajador VALUES (
  12466553,
  '2',
  'VIDAL',
  'PEREZ',
  'TERESA',
  'FCO. DE CAMARGO 14515 D/14',
  '28122603',
  '01081996',
  '01081994',
  1202614,
  82,
  3,
  10,
  3,
  7
);

INSERT INTO trabajador VALUES (
  11745244,
  '3',
  'VENEGAS',
  'SOTO',
  'KARINA',
  'ARICA 3850',
  '27494190',
  '01081988',
  '01081994',
  1439042,
  83,
  3,
  60,
  4,
  7
);

INSERT INTO trabajador VALUES (
  11999100,
  '4',
  'CONTRERAS',
  'CASTILLO',
  'CLAUDIO',
  'ISABEL RIQUELME 6075',
  '27764142',
  '24121966',
  '01081994',
  364163,
  84,
  4,
  30,
  6,
  6
);

INSERT INTO trabajador VALUES (
  12888868,
  '5',
  'PAEZ',
  'MACMILLAN',
  'JOSE',
  'FERNANDEZ CONCHA 500',
  '22399493',
  '25121964',
  '01031991',
  1896155,
  85,
  3,
  30,
  5,
  7
);

INSERT INTO trabajador VALUES (
  12811094,
  '6',
  'MOLINA',
  'GONZALEZ',
  'PAULA',
  'PJE.TIMBAL 1095 V/POMAIRE',
  '25313830',
  '26121978',
  '01042017',
  1757577,
  86,
  3,
  60,
  3,
  5
);

INSERT INTO trabajador VALUES (
  14255602,
  '7',
  'MUnOZ',
  'ROJAS',
  'CARLOTA',
  'TERCEIRA 7426 V/LIBERTAD',
  '26490093',
  '01052006',
  '01081994',
  2658577,
  87,
  2,
  50,
  4,
  4
);

INSERT INTO trabajador VALUES (
  11630572,
  '8',
  'ARAVENA',
  'HERBAGE',
  'GUSTAVO',
  'FERNANDO DE ARAGON 8420',
  '25588481',
  NULL,
  '01072001',
  1957095,
  88,
  3,
  40,
  1,
  1
);

INSERT INTO trabajador VALUES (
  11636534,
  '9',
  'ADASME',
  'ZUnIGA',
  'LUIS',
  'LITTLE ROCK 117 V/PDTE.KENNEDY',
  '26483081',
  '29121973',
  '01061996',
  1614934,
  89,
  3,
  50,
  6,
  7
);

INSERT INTO trabajador VALUES (
  12272880,
  'K',
  'LAPAZ',
  'SEPULVEDA',
  'MARCO',
  'GUARDIA MARINA. RIQUELME 561',
  '26038967',
  '30121989',
  '01072016',
  1352596,
  92,
  3,
  40,
  5,
  1
);

INSERT INTO trabajador VALUES (
  11846972,
  '5',
  'OGAZ',
  'VARAS',
  'MARCO',
  'OVALLE Nº5798 V/ OHIGGINS',
  '27763209',
  '31121959',
  '01022017',
  253590,
  94,
  4,
  50,
  6,
  4
);

INSERT INTO trabajador VALUES (
  14283083,
  '6',
  'MONDACA',
  'COLLAO',
  'AUGUSTO',
  'NUEVA COLON Nº1152',
  '27357104',
  '01011989',
  '01092013',
  1144245,
  95,
  2,
  50,
  3,
  6
);

INSERT INTO trabajador VALUES (
  14541837,
  '7',
  'ALVAREZ',
  'RIVERA',
  'MARCO',
  'HONDURAS B/8908 D/102 L.BRISAS',
  '22875902',
  '02011977',
  '01101996',
  1541418,
  97,
  3,
  20,
  4,
  7
);

INSERT INTO trabajador VALUES (
  12482036,
  '8',
  'OLAVE',
  'CASTILLO',
  'ADRIAN',
  'ELISA CORREA 188',
  '22888897',
  '03011956',
  '01111986',
  1068086,
  98,
  3,
  20,
  1,
  1
);

INSERT INTO trabajador VALUES (
  12468081,
  '9',
  'SANCHEZ',
  'GONZALEZ',
  'PAOLA',
  'AV.OSSA 01240 V/MI VInITA',
  '25273328',
  '04011987',
  '01082012',
  1330355,
  99,
  3,
  60,
  4,
  1
);

INSERT INTO trabajador VALUES (
  12260812,
  '0',
  'RIOS',
  'ZUnIGA',
  'RAFAEL',
  'LOS CASTAnOS 1427 VILLA C.C.U.',
  '26410462',
  '05011991',
  '01032013',
  367056,
  106,
  4,
  50,
  4,
  3
);

INSERT INTO trabajador VALUES (
  12899759,
  '1',
  'CACERES',
  'JIMENEZ',
  'ERIKA',
  'PJE.NAVARINO 15758 V/P.DE OnA',
  '28593881',
  '06011974',
  '01121994',
  2281415,
  107,
  3,
  40,
  4,
  5
);

INSERT INTO trabajador VALUES (
  12868553,
  '2',
  'CHACON',
  'AMAYA',
  'PATRICIA',
  'LO ERRAZURIZ 530 V/EL SENDERO',
  '25577963',
  '07011985',
  '01012006',
  1723055,
  108,
  3,
  10,
  1,
  2
);

INSERT INTO trabajador VALUES (
  12648200,
  '3',
  'NARVAEZ',
  'MUnOZ',
  'LUIS',
  'AMBRIOSO OHIGGINS  2010',
  '27742268',
  '08011993',
  '01032017',
  1966613,
  80,
  3,
  60,
  2,
  1
);

INSERT INTO trabajador VALUES (
  11670042,
  '5',
  'GONGORA',
  'DEVIA',
  'VALESKA',
  'PASAJE VENUS 2765',
  '23244270',
  '10011975',
  '01091998',
  1635086,
  82,
  3,
  30,
  1,
  1
);

INSERT INTO trabajador VALUES (
  12642309,
  'K',
  'NAVARRO',
  'SANTIBAnEZ',
  'JUAN',
  'SANTA ELENA 300 V/LOS ALAMOS',
  '25342599',
  '11011986',
  '02092011',
  1659230,
  83,
  3,
  30,
  6,
  7
);

INSERT INTO est_civil VALUES (
  11649964,
  1,
  '01071996',
  '31052016'
);

INSERT INTO est_civil VALUES (
  11649964,
  2,
  '01062016',
  NULL
);

INSERT INTO est_civil VALUES (
  12113369,
  4,
  '01081991',
  '05062018'
);

INSERT INTO est_civil VALUES (
  12113369,
  2,
  '06062018',
  NULL
);

INSERT INTO est_civil VALUES (
  12456905,
  2,
  '01091983',
  NULL
);

INSERT INTO est_civil VALUES (
  12466553,
  3,
  '01081996',
  NULL
);

INSERT INTO est_civil VALUES (
  11745244,
  1,
  '01081988',
  NULL
);

INSERT INTO est_civil VALUES (
  11999100,
  2,
  '01081994',
  NULL
);

INSERT INTO est_civil VALUES (
  12888868,
  3,
  '01031991',
  NULL
);

INSERT INTO est_civil VALUES (
  12811094,
  4,
  '01042018',
  NULL
);

INSERT INTO est_civil VALUES (
  14255602,
  1,
  '01052006',
  NULL
);

INSERT INTO est_civil VALUES (
  11630572,
  3,
  '01072001',
  NULL
);

INSERT INTO est_civil VALUES (
  11636534,
  1,
  '01061996',
  '02062018'
);

INSERT INTO est_civil VALUES (
  11636534,
  2,
  '03062018',
  NULL
);

INSERT INTO est_civil VALUES (
  12272880,
  2,
  '01072016',
  NULL
);

INSERT INTO est_civil VALUES (
  11846972,
  3,
  '01042018',
  NULL
);

INSERT INTO est_civil VALUES (
  14283083,
  4,
  '01092013',
  NULL
);

INSERT INTO est_civil VALUES (
  14541837,
  1,
  '01101996',
  '15062018'
);

INSERT INTO est_civil VALUES (
  14541837,
  2,
  '16062018',
  NULL
);

INSERT INTO est_civil VALUES (
  12482036,
  2,
  '01111986',
  NULL
);

INSERT INTO est_civil VALUES (
  12468081,
  3,
  '01082012',
  NULL
);

INSERT INTO est_civil VALUES (
  12260812,
  4,
  '01032013',
  NULL
);

INSERT INTO est_civil VALUES (
  12899759,
  1,
  '01121994',
  NULL
);

INSERT INTO est_civil VALUES (
  12868553,
  2,
  '01012006',
  NULL
);

INSERT INTO est_civil VALUES (
  12648200,
  3,
  '01032017',
  NULL
);

INSERT INTO est_civil VALUES (
  11670042,
  1,
  '01091998',
  '06062018'
);

INSERT INTO est_civil VALUES (
  11670042,
  2,
  '07062018',
  NULL
);

INSERT INTO est_civil VALUES (
  12642309,
  2,
  '02092011',
  NULL
);

INSERT INTO asignacion_familiar VALUES (
  20639521,
  '0',
  'ARAVENA',
  'RIQUELME',
  'Jorge',
  11630572
);

INSERT INTO asignacion_familiar VALUES (
  19074837,
  '1',
  'ARAVENA',
  'RIQUELME',
  'CESAR',
  11630572
);

INSERT INTO asignacion_familiar VALUES (
  22251882,
  '2',
  'ARAVENA',
  'DONOSO',
  'CLAUDIO',
  11630572
);

INSERT INTO asignacion_familiar VALUES (
  17238830,
  '3',
  'RIOS',
  'CAVERO',
  '¨Pedro',
  12260812
);

INSERT INTO asignacion_familiar VALUES (
  18777063,
  '4',
  'RIOS',
  'CAVERO',
  'PABLO',
  12260812
);

INSERT INTO asignacion_familiar VALUES (
  22467572,
  '5',
  'TRONCOSO',
  'ROMERO',
  'CLAUDIO',
  12113369
);

INSERT INTO asignacion_familiar VALUES (
  20487147,
  '9',
  'SOTO',
  'MUnOZ',
  'MARTINA',
  14255602
);

INSERT INTO bono_antiguedad VALUES (
  seq_porc_com_annos.NEXTVAL,
  2,
  8,
  0.05
);

INSERT INTO bono_antiguedad VALUES (
  seq_porc_com_annos.NEXTVAL,
  10,
  15,
  0.06
);

INSERT INTO bono_antiguedad VALUES (
  seq_porc_com_annos.NEXTVAL,
  16,
  19,
  0.08
);

INSERT INTO bono_antiguedad VALUES (
  seq_porc_com_annos.NEXTVAL,
  20,
  30,
  0.10
);

INSERT INTO tickets_concierto VALUES (
  1,
  '21/04'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  134560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  2,
  '13/04'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  125000,
  2000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  3,
  '21/04'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  138560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  4,
  '21/04'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  157893,
  2000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  5,
  '05/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  160000,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  6,
  '16/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  1258000,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  7,
  '16/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  158000,
  3000,
  12642309
);

INSERT INTO tickets_concierto VALUES (
  8,
  '16/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  18000,
  3000,
  11670042
);

INSERT INTO tickets_concierto VALUES (
  9,
  '17/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  28000,
  3000,
  12648200
);

INSERT INTO tickets_concierto VALUES (
  10,
  '25/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  234560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  11,
  '26/05'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  257893,
  2000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  12,
  '01/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  14560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  13,
  '01/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  257893,
  2000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  14,
  '05/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  260000,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  15,
  '16/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  358000,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  16,
  '16/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  155000,
  3000,
  12642309
);

INSERT INTO tickets_concierto VALUES (
  17,
  '16/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  125800,
  3000,
  11670042
);

INSERT INTO tickets_concierto VALUES (
  18,
  '17/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  155800,
  3000,
  12648200
);

INSERT INTO tickets_concierto VALUES (
  19,
  '21/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  234560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  20,
  '21/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  145793,
  2000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  21,
  '21/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  34560,
  1000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  22,
  '22/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  45793,
  2000,
  12113369
);

INSERT INTO tickets_concierto VALUES (
  23,
  '22/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  160000,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  24,
  '23/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  75800,
  3000,
  12456905
);

INSERT INTO tickets_concierto VALUES (
  25,
  '23/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  35800,
  3000,
  12642309
);

INSERT INTO tickets_concierto VALUES (
  26,
  '16/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  55800,
  3000,
  11670042
);

INSERT INTO tickets_concierto VALUES (
  27,
  '23/06'
  || to_char(EXTRACT(YEAR FROM sysdate)),
  55800,
  3000,
  12648200
);

INSERT INTO comisiones_ticket VALUES (
  1,
  540
);

INSERT INTO comisiones_ticket VALUES (
  2,
  786
);

INSERT INTO comisiones_ticket VALUES (
  3,
  618
);

INSERT INTO comisiones_ticket VALUES (
  4,
  7868
);

INSERT INTO comisiones_ticket VALUES (
  5,
  8500
);

INSERT INTO comisiones_ticket VALUES (
  6,
  9370
);

INSERT INTO comisiones_ticket VALUES (
  7,
  8370
);

INSERT INTO comisiones_ticket VALUES (
  8,
  3700
);

INSERT INTO comisiones_ticket VALUES (
  9,
  8700
);

INSERT INTO comisiones_ticket VALUES (
  10,
  184
);

INSERT INTO comisiones_ticket VALUES (
  11,
  6868
);

INSERT INTO comisiones_ticket VALUES (
  12,
  514
);

INSERT INTO comisiones_ticket VALUES (
  13,
  6864
);

INSERT INTO comisiones_ticket VALUES (
  14,
  9000
);

INSERT INTO comisiones_ticket VALUES (
  15,
  730
);

INSERT INTO comisiones_ticket VALUES (
  16,
  9300
);

INSERT INTO comisiones_ticket VALUES (
  17,
  430
);

INSERT INTO comisiones_ticket VALUES (
  18,
  7300
);

INSERT INTO comisiones_ticket VALUES (
  19,
  1514
);

INSERT INTO comisiones_ticket VALUES (
  20,
  6464
);

INSERT INTO comisiones_ticket VALUES (
  21,
  514
);

INSERT INTO comisiones_ticket VALUES (
  22,
  6864
);

INSERT INTO comisiones_ticket VALUES (
  23,
  9000
);

INSERT INTO comisiones_ticket VALUES (
  24,
  6370
);

INSERT INTO comisiones_ticket VALUES (
  25,
  9970
);

INSERT INTO comisiones_ticket VALUES (
  26,
  18370
);

INSERT INTO comisiones_ticket VALUES (
  27,
  4370
);

COMMIT;




--CASOS DE LA ACTIVIDAD S4

-- CASO 1: Listado de Trabajadores
SELECT 
    UPPER(t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno) AS "Nombre Completo Trabajador",
    REPLACE(TRIM(TO_CHAR(t.numrut, '99G999G999')) || '-' || t.dvrut, ',', '.') AS "RUT Trabajador",
    tt.desc_categoria AS "Tipo Trabajador",
    INITCAP(cc.nombre_ciudad) AS "Ciudad Trabajador",
    REPLACE(TO_CHAR(t.sueldo_base, '$999,999,999'), ',', '.') AS "Sueldo Base"
FROM 
    trabajador t
    JOIN tipo_trabajador tt ON t.id_categoria_t = tt.id_categoria
    JOIN comuna_ciudad cc ON t.id_ciudad = cc.id_ciudad
WHERE 
    t.sueldo_base BETWEEN 650000 AND 3000000
ORDER BY 
    cc.nombre_ciudad DESC, 
    t.sueldo_base ASC;

-- CASO 2: Listado Cajeros
SELECT 
    REPLACE(TRIM(TO_CHAR(t.numrut, '99G999G999')) || '-' || t.dvrut, ',', '.') AS "RUT Trabajador",
    INITCAP(t.nombre) || ' ' || INITCAP(t.appaterno) AS "Nombre Trabajador",
    COUNT(DISTINCT tc.nro_ticket) AS "Total Tickets",
    REPLACE(TO_CHAR(SUM(tc.monto_ticket), '$9,999,999'), ',', '.') AS "Total Vendido",
    REPLACE(TO_CHAR(SUM(ct.valor_comision), '$99,999,999'), ',', '.') AS "Comisión Total",
    tt.desc_categoria AS "Tipo Trabajador",
    INITCAP(cc.nombre_ciudad) AS "Ciudad Trabajador"
FROM 
    trabajador t
    JOIN tipo_trabajador tt ON t.id_categoria_t = tt.id_categoria
    JOIN comuna_ciudad cc ON t.id_ciudad = cc.id_ciudad
    JOIN tickets_concierto tc ON t.numrut = tc.numrut_t
    JOIN comisiones_ticket ct ON tc.nro_ticket = ct.nro_ticket
WHERE 
    UPPER(tt.desc_categoria) LIKE '%CAJERO%'
GROUP BY 
    t.numrut, t.dvrut, t.nombre, t.appaterno, tt.desc_categoria, cc.nombre_ciudad
HAVING 
    SUM(tc.monto_ticket) > 50000
ORDER BY 
    SUM(tc.monto_ticket) DESC;

-- CASO 3: Listado de Bonificaciones
SELECT 
    REPLACE(TRIM(TO_CHAR(t.numrut, '99G999G999')) || '-' || t.dvrut, ',', '.') AS "RUT Trabajador",
    INITCAP(t.nombre) || ' ' || INITCAP(t.appaterno) AS "Trabajador Nombre",
    EXTRACT(YEAR FROM t.fecing) AS "Año Ingreso",
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM t.fecing) AS "Años Antigüedad",
    NVL(COUNT(af.numrut_carga), 0) AS "Num. Cargas Familiares",
    i.nombre_isapre AS "Nombre Isapre",
    REPLACE(TO_CHAR(t.sueldo_base, '$9,999,999'), ',', '.') AS "Sueldo Base",
    REPLACE(TO_CHAR(CASE 
        WHEN UPPER(i.nombre_isapre) = 'FONASA' THEN ROUND(t.sueldo_base * 0.01)
        ELSE 0 
    END, '$999,999,999'), ',', '.') AS "Bono Fonasa",
    REPLACE(TO_CHAR(CASE 
        WHEN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM t.fecing)) <= 10 THEN ROUND(t.sueldo_base * 0.10)
        ELSE ROUND(t.sueldo_base * 0.15)
    END, '$999,999,999'), ',', '.') AS "Bono Antigüedad",
    a.nombre_afp AS "Nombre AFP",
    ec.desc_estcivil AS "Estado Civil"
FROM 
    trabajador t
    JOIN comuna_ciudad cc ON t.id_ciudad = cc.id_ciudad
    JOIN isapre i ON t.cod_isapre = i.cod_isapre
    JOIN afp a ON t.cod_afp = a.cod_afp
    JOIN est_civil est ON t.numrut = est.numrut_t
    JOIN estado_civil ec ON est.id_estcivil_est = ec.id_estcivil
    LEFT JOIN asignacion_familiar af ON t.numrut = af.numrut_t
WHERE 
    est.fecter_estcivil IS NULL OR est.fecter_estcivil > SYSDATE
GROUP BY 
    t.numrut, t.dvrut, t.nombre, t.appaterno, t.fecing, i.nombre_isapre, 
    t.sueldo_base, a.nombre_afp, ec.desc_estcivil
ORDER BY 
    t.numrut ASC;