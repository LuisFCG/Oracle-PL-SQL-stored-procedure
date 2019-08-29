--------------------------------------------------------
-- Archivo creado  - miércoles-agosto-28-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure P_BUSCARPORCEDULA_PERSONAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_BUSCARPORCEDULA_PERSONAL" 
(
  P_CEDULA IN NUMBER
) AS 
error_msg VARCHAR2(300);
CURSOR cpersonal (PC_CEDULA NUMBER)
    IS 
    SELECT P.cedula as ced, P.nombre as nom, P.apellido as apell, C.SUELDO as sueld
    FROM T_PERSONAL P JOIN T_CARGO C
    ON P.COD_CARGO = C.COD_CARGO
    WHERE P.cedula = PC_CEDULA;

    registros   cpersonal%rowtype;

BEGIN
   OPEN cpersonal(P_CEDULA);
    LOOP
        FETCH cpersonal INTO registros;
        EXIT WHEN cpersonal%notfound;
        dbms_output.put_line(
        'Cedula: '||rpad(registros.ced,15,' ')||' '||
        'Nombre: '||rpad(registros.nom,15,' ')||' '||
        'Apellido: '||rpad(registros.apell,15,' ')||' '||
        'sueldo: '||rpad(registros.sueld,10,' '));
    END LOOP;
    CLOSE cpersonal;
EXCEPTION  
WHEN OTHERS THEN
  
  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);  
END P_BUSCARPORCEDULA_PERSONAL;

/
--------------------------------------------------------
--  DDL for Procedure P_BUSCARPORNOMBRE_CARGOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_BUSCARPORNOMBRE_CARGOS" 
(
  P_NOMBRE IN VARCHAR2 
) AS 
error_msg VARCHAR2(300);
CURSOR lcargos (PC_NOMBRECARGO VARCHAR2)
    IS 
    SELECT nombre_cargo 
    FROM T_CARGO
   -- WHERE nombre_cargo like '%'||PC_NOMBRECARGO||'%'; --SI ES PARA BUSQUEDA EN GENERAL
   WHERE nombre_cargo = PC_NOMBRECARGO; --PARA BUSQUEDA EXACTA

    registros   lcargos%rowtype;

BEGIN
    OPEN lcargos(P_NOMBRE);
    LOOP
        FETCH lcargos INTO registros;
        EXIT WHEN lcargos%notfound;
        dbms_output.put_line(registros.nombre_cargo);
    END LOOP;

    CLOSE lcargos;
EXCEPTION  
WHEN OTHERS THEN
  
  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);    
END P_BUSCARPORNOMBRE_CARGOS;

/
--------------------------------------------------------
--  DDL for Procedure P_ELIMINAR_CARGO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_ELIMINAR_CARGO" 
(
  P_COD_CARGO IN VARCHAR2 
) AS 
 error_msg VARCHAR2(300);
BEGIN
  
  delete t_cargo
  where COD_CARGO = 'P_COD_CARGO';
  EXCEPTION  
WHEN OTHERS THEN
  
  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);
END P_ELIMINAR_CARGO;

/
--------------------------------------------------------
--  DDL for Procedure P_INGRESAR_CARGO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_INGRESAR_CARGO" 
(
  P_COD_CARGO IN VARCHAR2 
, P_NOMBRE_CARGO IN VARCHAR2 
) AS 
    error_msg VARCHAR2(300);
BEGIN
INSERT INTO T_CARGO(COD_CARGO, NOMBRE_CARGO)
values (P_COD_CARGO, P_NOMBRE_CARGO);
 
 
EXCEPTION  
WHEN OTHERS THEN
  
  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);
 
END P_INGRESAR_CARGO;

/
--------------------------------------------------------
--  DDL for Procedure P_INGRESAR_PERSONAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_INGRESAR_PERSONAL" 
(
  P_ID IN NUMBER
, P_CEDULA IN NUMBER 
, P_NOMBRE IN VARCHAR2 
, P_APELLIDO IN VARCHAR2 
, P_COD_CARGO IN VARCHAR2 
, P_COD_UBICACION IN VARCHAR2 
, P_FECHA IN DATE
) AS 
 error_msg VARCHAR2(300);
BEGIN
 INSERT INTO T_PERSONAL(ID, CEDULA, NOMBRE, APELLIDO, COD_CARGO, COD_UBICACION, FECHA)
values (P_ID, P_CEDULA, P_NOMBRE, P_APELLIDO, P_COD_CARGO, P_COD_UBICACION, P_FECHA);
 
 
EXCEPTION  
WHEN OTHERS THEN
  
  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);
END P_INGRESAR_PERSONAL;

/
--------------------------------------------------------
--  DDL for Procedure P_LISTAR_CARGOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."P_LISTAR_CARGOS" AS
    CURSOR lcargos 
    IS 
    SELECT nombre_cargo FROM T_CARGO;

    registros   lcargos%rowtype;
BEGIN
    OPEN lcargos;
    LOOP
        FETCH lcargos INTO registros;
        EXIT WHEN lcargos%notfound;
        dbms_output.put_line(registros.nombre_cargo);
    END LOOP;

    CLOSE lcargos;
END p_listar_cargos;

/
--------------------------------------------------------
--  DDL for Procedure PA_AUMENTARSUELDOPORCENTAJE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."PA_AUMENTARSUELDOPORCENTAJE" (porcentaje in number)
 as
 begin
  update T_CARGO
  set sueldo=sueldo+(sueldo*porcentaje/100);
 end;

/
--------------------------------------------------------
--  DDL for Procedure PA_CARGOS_AUMENTARSUELDO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."PA_CARGOS_AUMENTARSUELDO" (ccargo in varchar2,monto in number default 100)
 as
 begin
  update T_CARGO
  set sueldo=monto
  where cod_cargo=ccargo;
 end;

/
--------------------------------------------------------
--  DDL for Procedure PA_ELIMINAR_PERSONAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."PA_ELIMINAR_PERSONAL" 
(
P_CEDULA IN NUMBER
) AS 
 error_msg VARCHAR2(300);
 VALIDAR VARCHAR2(100);

BEGIN

SELECT F_VALIDA_EXISTE_CEDULA(P_CEDULA) INTO VALIDAR FROM DUAL;
if VALIDAR != 'NO_EXISTE' then
dbms_output.put_line('VARIABLE VALIDAR: '||VALIDAR);
    DELETE FROM T_PERSONAL
    WHERE CEDULA = P_CEDULA;
    dbms_output.put_line('Registro eliminado');
ELSE
    dbms_output.put_line('Registro NO EXISTE');
END IF;
EXCEPTION  
WHEN OTHERS THEN

  error_msg := SQLERRM;
  DBMS_OUTPUT.put_line(error_msg);
END PA_ELIMINAR_PERSONAL;

/
