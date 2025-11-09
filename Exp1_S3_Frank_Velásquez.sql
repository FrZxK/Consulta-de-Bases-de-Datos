
--Caso 1: Listado de Clientes con Rango de Renta

ACCEPT RENTA_MINIMA PROMPT 'Ingrese la renta mínima: '
ACCEPT RENTA_MAXIMA PROMPT 'Ingrese la renta máxima: '

SELECT 
    ROWNUM AS "N°",
    REPLACE(TO_CHAR(numrut_cli, '99G999G999'), ',','.') || '-' || dvrut_cli AS "RUT Cliente",
    INITCAP(nombre_cli) || ' ' || INITCAP(appaterno_cli) || ' ' || INITCAP(apmaterno_cli) AS "Nombre Completo Cliente",
    direccion_cli AS "Dirección Cliente",
    REPLACE(TO_CHAR(renta_cli, '$99G999G999'), ',', '.') AS "Renta Cliente",
    CASE
        WHEN celular_cli IS NULL THEN 'Sin número'
        ELSE '0' || SUBSTR(TO_CHAR(celular_cli), 1, 1) || '-' ||
             SUBSTR(TO_CHAR(celular_cli), 2, 3) || '-' ||
             SUBSTR(TO_CHAR(celular_cli), 5, 4)
    END AS "Celular Cliente",
    CASE 
        WHEN renta_cli > 500000 THEN 'TRAMO 1'
        WHEN renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
        WHEN renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
        ELSE 'TRAMO 4'
    END AS "Trama Renta Cliente"
FROM cliente
WHERE renta_cli BETWEEN &RENTA_MINIMA AND &RENTA_MAXIMA
    AND celular_cli IS NOT NULL
ORDER BY "Nombre Completo Cliente" ASC;

UNDEFINE RENTA_MINIMA
UNDEFINE RENTA_MAXIMA



--Caso 2: Sueldo Promedio por Categoría de Empleado

ACCEPT SUELDO_PROMEDIO_MINIMO PROMPT 'Ingrese el sueldo promedio mínimo: ';

SELECT 
    ROWNUM AS "N°",
    CODIGO_CATEGORIA,
    DESCRIPCION_CATEGORIA,
    CANTIDAD_EMPLEADOS,
    SUCURSAL,
    SUELDO_PROMEDIO
FROM (
    SELECT 
        ce.id_categoria_emp AS CODIGO_CATEGORIA,
        INITCAP(LOWER(ce.desc_categoria_emp)) AS DESCRIPCION_CATEGORIA,
        COUNT(e.numrut_emp) AS CANTIDAD_EMPLEADOS,
        s.desc_sucursal AS SUCURSAL,
        REPLACE(TO_CHAR(ROUND(AVG(e.sueldo_emp)), '$999G999G999'), ',', '.') AS SUELDO_PROMEDIO,
        AVG(e.sueldo_emp) AS SUELDO_PROMEDIO_NUM
    FROM empleado e
    JOIN categoria_empleado ce ON e.id_categoria_emp = ce.id_categoria_emp
    JOIN sucursal s ON e.id_sucursal = s.id_sucursal
    GROUP BY ce.id_categoria_emp, ce.desc_categoria_emp, s.desc_sucursal
    HAVING AVG(e.sueldo_emp) >= &SUELDO_PROMEDIO_MINIMO
    ORDER BY AVG(e.sueldo_emp) DESC
);

UNDEFINE SUELDO_PROMEDIO_MINIMO;



-- Caso 3: Arriendo Promedio por Tipo de Propiedad

SELECT 
    ROWNUM AS "N°",
    CODIGO_TIPO,
    DESCRIPCION_TIPO,
    TOTAL_PROPIEDADES,
    PROMEDIO_ARRIENDO,
    PROMEDIO_SUPERFICIE,
    VALOR_ARRIENDO_M2,
    CLASIFICACION
FROM (
    SELECT 
        tp.id_tipo_propiedad AS CODIGO_TIPO,
        CASE tp.id_tipo_propiedad
            WHEN 'A' THEN 'CASA'
            WHEN 'B' THEN 'DEPARTAMENTO'
            WHEN 'C' THEN 'LOCAL'
            WHEN 'D' THEN 'PARCELA SIN CASA'
            WHEN 'E' THEN 'PARCELA CON CASA'
        END AS DESCRIPCION_TIPO,
        COUNT(p.nro_propiedad) AS TOTAL_PROPIEDADES,
        REPLACE(TO_CHAR(ROUND(AVG(p.valor_arriendo)), '$999G999G999'), ',', '.') AS PROMEDIO_ARRIENDO,
        REPLACE(TO_CHAR(ROUND(AVG(p.superficie), 2), 'FM999G990D00'), '.',',') AS PROMEDIO_SUPERFICIE,
        REPLACE(TO_CHAR(ROUND(AVG(p.valor_arriendo / p.superficie)), '$999G999'), ',', '.') AS VALOR_ARRIENDO_M2,
        CASE 
            WHEN AVG(p.valor_arriendo / p.superficie) > 10000 THEN 'Alto'
            WHEN AVG(p.valor_arriendo / p.superficie) BETWEEN 5000 AND 10000 THEN 'Medio'
            ELSE 'Económico'
        END AS CLASIFICACION,
        AVG(p.valor_arriendo / p.superficie) AS VALOR_M2_NUM
    FROM propiedad p
    JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id_tipo_propiedad
    GROUP BY tp.id_tipo_propiedad
    HAVING AVG(p.valor_arriendo / p.superficie) > 1000
    ORDER BY AVG(p.valor_arriendo / p.superficie) DESC
);
