
-- CASO 1: Reportería de Asesorías

SELECT
    p.id_profesional AS "ID",
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre AS "PROFESIONAL",
    NVL(banca.nro_asesorias_banca, 0) AS "NRO ASESORIA BANCA",
    '$' || TO_CHAR(NVL(banca.monto_total_banca, 0), 'FM9G999G999G990') AS "MONTO_TOTAL_BANCA",
    NVL(retail.nro_asesorias_retail, 0) AS "NRO ASESORIA RETAIL",
    '$' || TO_CHAR(NVL(retail.monto_total_retail, 0), 'FM9G999G999G990') AS "MONTO_TOTAL_RETAIL",
    NVL(banca.nro_asesorias_banca, 0) + NVL(retail.nro_asesorias_retail, 0) AS "TOTAL ASESORIAS",
    '$' || TO_CHAR(NVL(banca.monto_total_banca, 0) + NVL(retail.monto_total_retail, 0), 'FM9G999G999G990') AS "TOTAL HONORARIOS"
FROM
    profesional p
INNER JOIN
    (
        SELECT a.id_profesional FROM asesoria a JOIN empresa e ON a.cod_empresa = e.cod_empresa WHERE e.cod_sector = 3
        INTERSECT
        SELECT a.id_profesional FROM asesoria a JOIN empresa e ON a.cod_empresa = e.cod_empresa WHERE e.cod_sector = 4
    ) versatiles ON p.id_profesional = versatiles.id_profesional
LEFT JOIN
    (
        SELECT a.id_profesional, COUNT(a.id_profesional) AS nro_asesorias_banca, SUM(a.honorario) AS monto_total_banca
        FROM asesoria a JOIN empresa e ON a.cod_empresa = e.cod_empresa WHERE e.cod_sector = 3
        GROUP BY a.id_profesional
    ) banca ON p.id_profesional = banca.id_profesional
LEFT JOIN
    (
        SELECT a.id_profesional, COUNT(a.id_profesional) AS nro_asesorias_retail, SUM(a.honorario) AS monto_total_retail
        FROM asesoria a JOIN empresa e ON a.cod_empresa = e.cod_empresa WHERE e.cod_sector = 4
        GROUP BY a.id_profesional
    ) retail ON p.id_profesional = retail.id_profesional
ORDER BY 1 ASC;




-- CASO 2: Resumen de Honorarios

DROP TABLE REPORTE_MES;


CREATE TABLE REPORTE_MES (
    ID_PROFESIONAL       NUMBER(10) NOT NULL,
    NOMBRE_COMPLETO      VARCHAR2(80) NOT NULL,
    NOMBRE_PROFESION     VARCHAR2(50) NOT NULL,
    NOM_COMUNA           VARCHAR2(30) NOT NULL,
    NRO_ASESORIAS        NUMBER(3),
    MONTO_TOTAL_HONORIOS     NUMBER(12, 0),
    PROMEDIO_HONORARIO       NUMBER(12, 0),
    HONORARIO_MINIMO         NUMBER(12, 0),
    HONORARIO_MAXIMO         NUMBER(12, 0)
);


INSERT INTO REPORTE_MES (
    ID_PROFESIONAL, NOMBRE_COMPLETO, NOMBRE_PROFESION, NOM_COMUNA,
    NRO_ASESORIAS, MONTO_TOTAL_HONORIOS, PROMEDIO_HONORARIO,
    HONORARIO_MINIMO, HONORARIO_MAXIMO
)
SELECT
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre,
    prof.nombre_profesion,
    com.nom_comuna,
    COUNT(a.id_profesional) AS NRO_ASESORIAS,
    SUM(a.honorario) AS MONTO_TOTAL_HONORIOS,
    ROUND(AVG(a.honorario)) AS PROMEDIO_HONORARIO,
    MIN(a.honorario) AS HONORARIO_MINIMO,
    MAX(a.honorario) AS HONORARIO_MAXIMO
FROM asesoria a
JOIN profesional p ON a.id_profesional = p.id_profesional
JOIN comuna com ON p.cod_comuna = com.cod_comuna
JOIN profesion prof ON p.cod_profesion = prof.cod_profesion
WHERE a.fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -2)
    AND a.fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -1)
GROUP BY p.id_profesional, p.appaterno, p.apmaterno, p.nombre, prof.nombre_profesion, com.nom_comuna;

COMMIT;

UPDATE REPORTE_MES
SET NRO_ASESORIAS = NRO_ASESORIAS + 1;

COMMIT;

SELECT * FROM REPORTE_MES ORDER BY ID_PROFESIONAL ASC;




-- CASO 3: Modificación de Honorarios

SELECT
    '$' || TO_CHAR(NVL(ROUND(resumen.monto_honorarios), 0), 'FM9G999G990') AS HONORARIO,
    p.id_profesional AS ID_PROFESIONAL,
    p.numrun_prof AS NUMRUN_PROF,
    '$' || TO_CHAR(ROUND(p.sueldo), 'FM9G999G990') AS SUELDO -- Sueldo inicial
FROM profesional p

LEFT JOIN (
    SELECT a.id_profesional, SUM(a.honorario) AS monto_honorarios
    FROM asesoria a
    WHERE a.fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -10)
        AND a.fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -9)
    GROUP BY a.id_profesional
) resumen ON p.id_profesional = resumen.id_profesional
WHERE NVL(resumen.monto_honorarios, 0) > 0
ORDER BY p.id_profesional ASC;


UPDATE profesional p
SET p.sueldo = (
    SELECT
        CASE
            WHEN resumen.monto_honorarios < 1000000 THEN p.sueldo * 1.10
            WHEN resumen.monto_honorarios >= 1000000 THEN p.sueldo * 1.15
            ELSE p.sueldo
        END
    FROM
        (
            SELECT a.id_profesional, SUM(a.honorario) AS monto_honorarios
            FROM asesoria a
            WHERE a.fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -10)
                AND a.fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -9)
            GROUP BY a.id_profesional
        ) resumen
    WHERE p.id_profesional = resumen.id_profesional
)
WHERE p.id_profesional IN (
    SELECT id_profesional
    FROM asesoria
    WHERE fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -10)
        AND fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -9)
);
COMMIT;



UPDATE profesional p
SET p.puntaje = NVL(p.puntaje, 0) + 50
WHERE p.id_profesional IN (
    SELECT id_profesional
    FROM asesoria
    WHERE fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -10)
        AND fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -9)
);
COMMIT;


SELECT
    '$' || TO_CHAR(NVL(ROUND(resumen.monto_honorarios), 0), 'FM9G999G990') AS HONORARIO,
    p.id_profesional AS ID_PROFESIONAL,
    p.numrun_prof AS NUMRUN_PROF,
    '$' || TO_CHAR(ROUND(p.sueldo), 'FM9G999G990') AS SUELDO -- Sueldo incrementado
FROM profesional p

LEFT JOIN (
    SELECT a.id_profesional, SUM(a.honorario) AS monto_honorarios
    FROM asesoria a
    WHERE a.fin_asesoria >= ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -10)
        AND a.fin_asesoria < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), -9)
    GROUP BY a.id_profesional
) resumen ON p.id_profesional = resumen.id_profesional
WHERE NVL(resumen.monto_honorarios, 0) > 0
ORDER BY p.id_profesional ASC;