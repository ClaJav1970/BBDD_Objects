CREATE OR REPLACE PROCEDURE PRODUCTO.PROC_VALIDA_CAPITAL_CONFIG (
   P_CD_ENTIDAD       IN     COTIZACIONITEM.CD_ENTIDAD%TYPE,
   P_NU_COTIZACION    IN     COTIZACIONITEM.NU_COTIZACION%TYPE,
   P_CD_AREA          IN     POLIZA.CD_AREA%TYPE,
   P_NU_POLIZA        IN     POLIZA.NU_POLIZA%TYPE,
   P_NU_CERTIFICADO   IN     POLIZACERTIFICADO.NU_CERTIFICADO%TYPE,
   P_IN_EJECUCION     IN     VARCHAR2,
   P_ERROR               OUT VARCHAR2,
   P_MENSAJE             OUT VARCHAR2)
IS
   NO_PROCESAR                EXCEPTION;
   W_STAT                     VARCHAR2 (60);
   W_FE_EFECTIVA              DATE;
   W_FE_COTIZACION            DATE;
   W_ERROR                    VARCHAR2 (300);
   W_TP_CONTRATO              NUMBER;
   W_NU_LOCALES               NUMBER;
   W_NU_CERT                  NUMBER;
   W_EXISTE                   NUMBER;
   W_TP_TRANSA                NUMBER;
   W_FE_HASTA                 DATE;
   W_SA_ROBO                  NUMBER;
   W_MT_SUMA_ASEGURADA        NUMBER;
   W_MT_SUMA_ASEG_EDIF        NUMBER;
   W_MT_SUMA_ASEG_EXIS        NUMBER;
   W_TOTAL_RIESGO             NUMBER;
   W_SUMATORIA                NUMBER;
   W_MT_MAXIMO                NUMBER;
   W_CD_AREA                  NUMBER;
   W_NU_POLIZA                NUMBER;
   W_NU_CERTIFICADO           NUMBER;
   W_FE_DESDE                 DATE;
   W_COTIZA                   NUMBER;
   W_VR_EDIF                  NUMBER;
   W_TOTAL_CERT               NUMBER;
   W_DATO                     NUMBER;
   W_LIMITE                   NUMBER;
   W_BIEN                     VARCHAR2 (100);
   W_COTIZACION               NUMBER;
   W_TOTAL_RIESGO_TERREMOTO   NUMBER;
   W_MT_SUMA_TERREMOTO        NUMBER;
   W_DE_DATO                  VARCHAR2 (100);
   W_TASA_TECNICA             NUMBER;
   W_MT_PRIMA_NETA            NUMBER;
   W_VTR                      NUMBER;
   W_PERDIDA_RENTA            NUMBER;
   W_BIENES_REFRIG            NUMBER;
   W_PERDIDA_INDIRECTA_70     NUMBER;
   W_PERDIDA_INDIRECTA_90     NUMBER;
   W_TOTAL_PERDIDA            NUMBER;
   W_PORC_INDIRECTA           NUMBER;
   W_SUMA                     NUMBER;
   W_VTR_RC                   NUMBER;
   W_PRIMA_NETA               NUMBER;
   W_SUMA_REC                 NUMBER;
   W_PRIMA_BRUTA              NUMBER;
   W_PRIMA_PRORRATA           NUMBER;
   W_MT_COMISION              NUMBER;
   W_COMISION                 NUMBER;
   W_SUMA_HONORARIO           NUMBER;
   W_VR_CONTRA                NUMBER;
   W_VARIAS_SUMAS             NUMBER;
   W_MT_OBLIG                 NUMBER;
   W_MT_TASA                  NUMBER;
   W_CD_MONEDA                NUMBER;
   W_RESTANTE                 NUMBER;
   W_CD_CANAL_VENTA           NUMBER;
   W_CUENTA                   VARCHAR2 (30);
   W_TRATADO                  VARCHAR2 (30);
   W_BOOKING                  NUMBER;
   W_LIMITE_MAXIMO            NUMBER;
   W_VESI                     NUMBER;
   W_VTR_MAS_EDIF             NUMBER;
   W_SA_DANOS_LOCAL           NUMBER;
   W_VTR_VALIDA_HURTO         NUMBER;
   W_SA_HURTO                 NUMBER;
   W_BIEN_COMPLEMENTARIA      NUMBER;
   W_MT_TASA_BS_DOL           NUMBER;
   W_MT_TASA_BS_EUR           NUMBER;
   W_LIMITE_MAX_RIESGO        NUMBER;
   W_MONTO_MAXIMO             NUMBER;
   W_SEVERIDAD                NUMBER;
   W_GRADO                    NUMBER;
   W_PRIMA_TOTAL              NUMBER;
   W_PRIMA_MINIMA             NUMBER;
   W_PRIMA_FULL               NUMBER;
   W_DIVISION                 VARCHAR2 (30);
   W_INDOLE                   VARCHAR2 (30);
   W_ESPECIFICA               VARCHAR2 (30);
   W_ESPECIALIDAD             VARCHAR2 (30);
   W_INDICE_POLIZA            VARCHAR2 (300);
   W_INDICE_COTIZACION        VARCHAR2 (300);
   W_GRADO_POLIZA             NUMBER;
   W_DIVISION_POLIZA          VARCHAR2 (30);
   W_INDOLE_POLIZA            VARCHAR2 (30);
   W_ESPECIFICA_POLIZA        VARCHAR2 (30);
   W_ESPECIALIDAD_POLIZA      VARCHAR2 (30);
   W_SEVERIDAD_POLIZA         VARCHAR2 (30);
   W_VR_EQUIPOS               NUMBER;
   W_ST_COTIZACION            NUMBER;
   W_CD_CAUSA_RECHAZO         NUMBER;
   W_PORC_COMISION            NUMBER;
   W_PORC_COMISION_MAX        NUMBER;
   W_COMISION_TOTAL           NUMBER;
   W_IMPUESTO                 NUMBER;
   W_COMISION_PORC            NUMBER;
   W_TOTAL                    NUMBER;
   W_PORC_COMISION_EVE        NUMBER;
   W_SUMA_DEMOLICION          NUMBER;
   W_MT_SUMA_ASEG_EQ          NUMBER;
   W_MT_SUMA_ASEG_MAQ         NUMBER;
   W_MT_SUMA_ASEG_IND         NUMBER;
   W_MT_SUMA_INUNDACION       NUMBER;
   W_TOTAL_RIESGO_ZONA_1      NUMBER;
   W_TOTAL_RIESGO_ZONA_2      NUMBER;
   W_TOTAL_RIESGO_ZONA_4      NUMBER;
   W_LIM_SA_HURTO             NUMBER;
   W_LIM_HURTO                NUMBER;
   W_CARENCIA                 NUMBER;
   W_CANT_ZONAS               NUMBER;
   W_SUMA_MOTIN               NUMBER;
   W_SUMA_DAGUA               NUMBER;
   W_PORC_PI               NUMBER;
   W_VTR_PI                 NUMBER;
   W_PI_MAQ                   NUMBER;
   W_PI_EXIS                  NUMBER;
   W_DCTO_RCGO                NUMBER;
BEGIN
   W_STAT := '0';


   BEGIN
      SELECT CD_AREA,
             NU_POLIZA,
             CD_MONEDA,
             CD_CANAL_VENTA
        INTO W_CD_AREA,
             W_NU_POLIZA,
             W_CD_MONEDA,
             W_CD_CANAL_VENTA
        FROM COTIZACION
       WHERE CD_ENTIDAD = P_CD_ENTIDAD AND NU_COTIZACION = P_NU_COTIZACION;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR := 'ERROR: NO SE ENCONTRO REGISTRO DE COTIZACION';
         RAISE NO_PROCESAR;
   END;

   W_STAT := '1';

   BEGIN
      SELECT TP_CONTRATO
        INTO W_TP_CONTRATO
        FROM COTIZACION
       WHERE CD_ENTIDAD = P_CD_ENTIDAD AND NU_COTIZACION = P_NU_COTIZACION;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_STAT := '2';

         BEGIN
            SELECT TP_CONTRATO
              INTO W_TP_CONTRATO
              FROM POLIZA
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND CD_AREA = P_CD_AREA
                   AND NU_POLIZA = P_NU_POLIZA;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               P_ERROR := 'ERROR: NO SE ENCONTRO EL TIPO DE CONTRATO';
               RAISE NO_PROCESAR;
         END;
   END;

   W_STAT := '3';

   BEGIN
      SELECT TP_TRANSACCION,
             FE_HASTA,
             FE_DESDE,
             NU_CERTIFICADO,
             ST_COTIZACION,
             CD_CAUSA_RECHAZO
        INTO W_TP_TRANSA,
             W_FE_HASTA,
             W_FE_DESDE,
             W_NU_CERTIFICADO,
             W_ST_COTIZACION,
             W_CD_CAUSA_RECHAZO
        FROM COTIZACIONITEM
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR := 'ERROR: NO SE ENCONTRO REGISTRO DE COTIZACIONITEM';
         RAISE NO_PROCESAR;
   END;

   W_STAT := '4';


   W_FE_COTIZACION :=
      FUN_BUSCAR_FECHA_COTIZACION (P_CD_ENTIDAD,
                                   P_NU_COTIZACION,
                                   0,
                                   NVL (W_CD_AREA, 0),
                                   NVL (W_NU_POLIZA, 0),
                                   NVL (W_NU_CERTIFICADO, 0),
                                   W_ERROR);



   IF W_ERROR IS NOT NULL
   THEN
      P_ERROR := W_STAT || '-' || W_ERROR;
   END IF;

   W_STAT := '5';

   BEGIN
      SELECT VA_DATO
        INTO W_PORC_COMISION
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920056;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT VA_DATO
              INTO W_PORC_COMISION
              FROM POLIZACERTENDOSOBIENDATO
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND CD_AREA = P_CD_AREA
                   AND NU_POLIZA = P_NU_POLIZA
                   AND NU_CERTIFICADO = 0
                   AND NU_ENDOSO =
                          (SELECT NU_ULTIMO_ENDOSO
                             FROM POLIZACERTIFICADO
                            WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                  AND CD_AREA = P_CD_AREA
                                  AND NU_POLIZA = P_NU_POLIZA
                                  AND NU_CERTIFICADO = 0)
                   AND NU_BIEN_ASEGURADO = 0
                   AND CD_DATO = 920056;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               P_ERROR := 'ERROR: NO SE ENCONTRO VALOR EN EL DATO COMISION';
               RAISE NO_PROCESAR;
         END;
   END;


   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_VTR
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO IN (20, 30, 40, 50, 60, 70, 90)
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VTR := 0;
   END;



   W_STAT := '6';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_CUENTA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920078;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_CUENTA := 0;
   END;

   W_STAT := '7';

   IF W_CD_CANAL_VENTA = 3 AND W_CUENTA <> 0
   THEN
      P_ERROR :=
         'ERROR:  PARA EL CANAL DE VENTA IPZ LA CUENTA DEBE SER MAYOR A CERO   ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '8';


   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_TRATADO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920079;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_TRATADO := 0;
   END;

   W_STAT := '9';

   IF W_CD_CANAL_VENTA = 3 AND W_TRATADO = '0'
   THEN
      P_ERROR :=
         'ERROR:    PARA EL CANAL DE VENTA IPZ EL NRO. DE TRATADO DEBE SER DISTINTO A CERO   ';
      RAISE NO_PROCESAR;
   END IF;


   W_STAT := '9.1';

   IF W_CD_CANAL_VENTA <> 3 AND W_TRATADO <> '0'
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920079;
   END IF;

   W_STAT := '10';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SA_ROBO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920033;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SA_ROBO := 0;
   END;

   W_STAT := '10,1';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SA_DANOS_LOCAL
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920023;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SA_DANOS_LOCAL := 0;
   END;

   W_STAT := '11';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_VR_EDIF
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 10
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VR_EDIF := 0;
   END;

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_VR_EQUIPOS
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 80
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VR_EQUIPOS := 0;
   END;

   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_BIEN_COMPLEMENTARIA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_BIEN_COMPLEMENTARIA := 0;
   END;



   IF W_VR_EDIF > 0 AND W_VTR = 0 AND W_BIEN_COMPLEMENTARIA = 0
   THEN
      P_MENSAJE :=
         '  SI DESEA VISUALIZAR EL RESTO DE LAS COBERTURAS DISPONIBLES A SER CONTRATADAS EN ÉSTE PRODUCTO, DEBE ACCEDER AL ICONO COBERTURAS COMPLEMENTARIAS ';
   END IF;

   ------------------------YB SE ACTUALIZA EL DATOS SUSTRACCIÓN iLEGITIMA---------------------------------

   W_STAT := '11.1';


   BEGIN
      SELECT SUM (VA_DATO)
        INTO W_VTR_MAS_EDIF
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VTR_MAS_EDIF := 0;
   END;

   W_STAT := '11.2';

   W_VESI := W_VTR_MAS_EDIF - W_VR_EDIF - W_VR_EQUIPOS;

   W_STAT := '11.3';

   UPDATE COTIZACIONITEMBIENDATO
      SET VA_DATO = W_VESI
    WHERE     CD_ENTIDAD = P_CD_ENTIDAD
          AND NU_COTIZACION = P_NU_COTIZACION
          AND NU_ITEM = 0
          AND NU_BIEN_ASEGURADO = 0
          AND CD_DATO = 920032;

   -----------------------------------------------------------------------------------------------------------------------------------------------
   W_STAT := '12';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_VR_CONTRA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 80
             AND CD_DATO = 920024;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VR_CONTRA := 0;
   END;

   W_STAT := '13';

   BEGIN
      SELECT SUM (MT_SUMA_ASEGURADA)
        INTO W_VARIAS_SUMAS
        FROM COTIZACIONITEMBIENGARANT
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_GARANTIA IN (9201, 9202, 9203, 9204);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VARIAS_SUMAS := 0;
   END;

   W_STAT := '14';

   IF W_VARIAS_SUMAS = 0
   THEN
      P_ERROR :=
         'ERROR:    DEBE CONTRATAR LAS COBERTURAS BÁSICAS ( INCENDIO, EXTENSIÓN DE COBERTURAS, DAÑOS POR AGUA, GASTOS EXPLORATORIOS Y ROBO  ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '15';


   IF W_SA_ROBO != 0 AND W_VTR = 0 AND W_VR_CONTRA > 0
   THEN
      P_ERROR :=
         'ERROR:    LA COBERTURA DE ROBO EN EL BIEN COBERTURAS COMPLEMENTARIAS ES EXCLUYENTE AL BIEN EQUIPOS CONTRATISTA ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '16';

   IF W_SA_ROBO != 0 AND W_VTR = 0 AND W_VR_EDIF > 0
   THEN
      P_ERROR :=
         'ERROR:    LA COBERTURA DE ROBO EN EL BIEN COBERTURAS COMPLEMENTARIAS ES EXCLUYENTE AL BIEN EDIFICACIÓN ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '17';

   IF W_SA_ROBO != 0 AND W_VTR = 0
   THEN
      P_ERROR :=
         'ERROR: PARA SELECCIONAR LA COBERTURA DE ROBO DEBE CONTRATAR COBERTURAS COMPLEMENTARIAS ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '18';

   IF W_SA_ROBO = 0 AND W_VTR != 0
   THEN
      P_ERROR := 'ERROR:    LA COBERTURA DE ROBO ES OBLIGATORIA ';
      RAISE NO_PROCESAR;
   END IF;


   --------------------------------------------------------------------------------
   W_STAT := '15,1';

   IF W_SA_DANOS_LOCAL != 0 AND W_VTR = 0 AND W_VR_CONTRA > 0
   THEN
      P_ERROR :=
         'ERROR:    LA COBERTURA DANOS AL LOCAL  EN EL BIEN COBERTURAS COMPLEMENTARIAS ES EXCLUYENTE AL BIEN EQUIPOS CONTRATISTA ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '16,1';

   IF W_SA_DANOS_LOCAL != 0 AND W_VTR = 0 AND W_VR_EDIF > 0
   THEN
      P_ERROR :=
         'ERROR:    LA COBERTURA DANOS AL LOCAL EN EL BIEN OTROS RIESGO ES EXCLUYENTE AL BIEN EDIFICACIÓN ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '17,1';

   IF W_SA_DANOS_LOCAL != 0 AND W_VTR = 0
   THEN
      P_ERROR :=
         'ERROR: PARA SELECCIONAR LA COBERTURA DANOS AL LOCAL DEBE CONTRATAR COBERTURAS COMPLEMENTARIAS ';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '18,1';

   IF W_SA_DANOS_LOCAL = 0 AND W_VTR != 0
   THEN
      P_ERROR := 'ERROR:    LA COBERTURA DANOS AL LOCAL ES OBLIGATORIA ';
      RAISE NO_PROCESAR;
   END IF;


   --------------------------------------------------------------------------------

   W_STAT := '19';

   IF W_TP_CONTRATO = 1
   THEN
      BEGIN
         SELECT VA_DATO
           INTO W_NU_LOCALES
           FROM COTIZACIONITEMBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO = 920017;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_ERROR :=
               'ERROR: NO SE ENCONTRO VALOR EN EL DATO NUMERO DE LOCALES';
            RAISE NO_PROCESAR;
      END;
   ELSIF W_TP_CONTRATO = 2
   THEN
      W_STAT := '20';

      BEGIN
         SELECT VA_DATO
           INTO W_NU_LOCALES
           FROM POLIZACERTENDOSOBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND CD_AREA = P_CD_AREA
                AND NU_POLIZA = P_NU_POLIZA
                AND NU_CERTIFICADO = 0
                AND NU_ENDOSO =
                       (SELECT NU_ULTIMO_ENDOSO
                          FROM POLIZACERTIFICADO
                         WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                               AND CD_AREA = P_CD_AREA
                               AND NU_POLIZA = P_NU_POLIZA
                               AND NU_CERTIFICADO = 0)
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO = 920017;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_ERROR :=
               'ERROR: NO SE ENCONTRO VALOR EN EL DATO NUMERO DE LOCALES';
            RAISE NO_PROCESAR;
      END;

      W_STAT := '21';

      BEGIN
         SELECT COUNT (*)
           INTO W_EXISTE
           FROM POLIZACERTIFICADO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND CD_AREA = P_CD_AREA
                AND NU_POLIZA = P_NU_POLIZA
                AND ST_CERTIFICADO != 11
                AND NU_CERTIFICADO != 0;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            W_EXISTE := 0;
      END;

      W_STAT := '22';


      IF W_TP_TRANSA = 1
      THEN
         W_STAT := '23';

         IF W_EXISTE + 1 > W_NU_LOCALES
         THEN
            P_ERROR :=
               'ERROR: NO SE PUEDEN EMITIR MAS CERTIFICADOS YA QUE EXCEDE LA CANTIDAD DE LOCALIDADES';
            RAISE NO_PROCESAR;
         END IF;
      ELSIF W_TP_TRANSA = 4 OR (W_TP_TRANSA = 2 AND W_FE_DESDE = W_FE_HASTA)
      THEN
         W_STAT := '24';

         P_ERROR :=
            'ERROR: NO SE PUEDEN EMITIR MAS CERTIFICADOS YA QUE EXCEDE LA CANTIDAD DE LOCALIDADES';
         RAISE NO_PROCESAR;
      END IF;

      W_STAT := '25';

      BEGIN
         FOR REG
            IN (SELECT *
                  FROM COTIZACIONITEMBIENDATO
                 WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                       AND NU_COTIZACION = P_NU_COTIZACION
                       AND NU_ITEM = 0
                       AND CD_DATO IN
                              (920024,
                               920041,
                               920042,
                               920043,
                               920044,
                               920021,
                               920022,
                               920023,
                               920031,
                               920033,
                               920048,
                               920045,
                               920050))
         LOOP
            W_STAT := '26';
            W_TOTAL_CERT := REG.VA_DATO;

            W_STAT := '27';

            W_DATO :=
                  92
               || SUBSTR (LPAD (REG.NU_BIEN_ASEGURADO, 3, 0), 1, 2)
               || SUBSTR (REG.CD_DATO, 5, 6);

            W_STAT := '28';

            BEGIN
               SELECT NVL (SUM (PCEBD.VA_DATO), 0)
                 INTO W_TOTAL_CERT
                 FROM POLIZACERTENDOSOBIENDATO PCEBD, POLIZACERTIFICADO PC
                WHERE     PCEBD.CD_ENTIDAD = P_CD_ENTIDAD
                      AND PCEBD.CD_AREA = P_CD_AREA
                      AND PCEBD.NU_POLIZA = P_NU_POLIZA
                      AND PCEBD.NU_CERTIFICADO != 0
                      AND PCEBD.NU_ENDOSO =
                             (SELECT NU_ULTIMO_ENDOSO
                                FROM POLIZACERTIFICADO
                               WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                     AND CD_AREA = P_CD_AREA
                                     AND NU_POLIZA = P_NU_POLIZA
                                     AND NU_CERTIFICADO = 0)
                      AND PCEBD.NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO
                      AND PCEBD.CD_DATO = REG.CD_DATO
                      AND PCEBD.CD_ENTIDAD = PC.CD_ENTIDAD
                      AND PCEBD.CD_AREA = PC.CD_AREA
                      AND PCEBD.NU_POLIZA = PC.NU_POLIZA
                      AND PCEBD.NU_CERTIFICADO = PC.NU_CERTIFICADO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            W_STAT := '29';

            BEGIN
               SELECT VA_DATO
                 INTO W_COTIZACION
                 FROM COTIZACIONITEMBIENDATO
                WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                      AND NU_COTIZACION = P_NU_COTIZACION
                      AND NU_ITEM = 0
                      AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO
                      AND CD_DATO = REG.CD_DATO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  W_COTIZACION := 0;
            END;

            W_STAT := '30';

            W_TOTAL_CERT := W_TOTAL_CERT + W_COTIZACION;

            W_STAT := '31';

            BEGIN
               SELECT VA_DATO
                 INTO W_LIMITE
                 FROM POLIZACERTENDOSOBIENDATO
                WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                      AND CD_AREA = P_CD_AREA
                      AND NU_POLIZA = P_NU_POLIZA
                      AND NU_CERTIFICADO = 0
                      AND NU_ENDOSO =
                             (SELECT NU_ULTIMO_ENDOSO
                                FROM POLIZACERTIFICADO
                               WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                     AND CD_AREA = P_CD_AREA
                                     AND NU_POLIZA = P_NU_POLIZA
                                     AND NU_CERTIFICADO = 0)
                      AND NU_BIEN_ASEGURADO = 0
                      AND CD_DATO = W_DATO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  W_LIMITE := 0;
            END;

            W_STAT := '32';

            BEGIN
               SELECT DE_BIEN_ASEGURADO
                 INTO W_BIEN
                 FROM PRODUCTOBIEN
                WHERE CD_PRODUCTO = 920892
                      AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  P_ERROR := 'ERROR: NO SE ENCONTRO REGISTRO EN PRODUCTOBIEN';
                  RAISE NO_PROCESAR;
            END;

            W_STAT := '33';

            IF W_LIMITE = 0 AND W_TOTAL_CERT <> 0
            THEN
               P_ERROR :=
                     'ERROR: NO FUE CONTRATADO EL BIEN-'
                  || W_BIEN
                  || 'EN LA POLIZA MATRIZ';
               RAISE NO_PROCESAR;
            END IF;

            W_STAT := '34';

            IF W_LIMITE < W_TOTAL_CERT
            THEN
               P_ERROR :=
                  'ERROR: EL ACUMULADO DE SUMA ASEGURADA EN LOS CERTIFICADOS EXCEDE EL LIMITE DEFINIDO EN LA POLIZA MATRIZ EN EL BIEN -'
                  || W_BIEN;
               RAISE NO_PROCESAR;
            END IF;

            W_STAT := '35';

            BEGIN
               IF W_TP_TRANSA = 1
               THEN
                  W_STAT := '36';

                  IF W_EXISTE + 1 = W_NU_LOCALES
                  THEN
                     IF W_LIMITE <> W_TOTAL_CERT
                     THEN
                        W_RESTANTE := W_LIMITE - W_TOTAL_CERT;

                        P_ERROR :=
                              'ERROR: AUN QUEDAN '
                           || W_RESTANTE
                           || ' RESTANTES QUE APLICAR A LOS VALORES A RIESGO
                      EN EL BIEN '
                           || W_BIEN;
                        RAISE NO_PROCESAR;
                     END IF;
                  END IF;

                  W_STAT := '37';
               ELSIF W_TP_TRANSA = 4
                     OR (W_TP_TRANSA = 2 AND W_FE_DESDE = W_FE_HASTA)
               THEN
                  W_STAT := '38';

                  IF W_EXISTE + 1 = W_NU_LOCALES
                  THEN
                     W_STAT := '39';

                     IF W_LIMITE <> W_TOTAL_CERT
                     THEN
                        W_RESTANTE := W_LIMITE - W_TOTAL_CERT;

                        W_STAT := '40';

                        P_ERROR :=
                              'ERROR: AUN QUEDAN '
                           || W_RESTANTE
                           || ' RESTANTES QUE APLICAR A LOS VALORES A RIESGO
                         EN EL BIEN '
                           || W_BIEN;
                        RAISE NO_PROCESAR;
                     END IF;
                  END IF;
               END IF;
            END;
         END LOOP;
      END;

      W_STAT := '41';

      BEGIN
         FOR REG
            IN (SELECT *
                  FROM COTIZACIONITEMBIENDATO
                 WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                       AND NU_COTIZACION = P_NU_COTIZACION
                       AND NU_ITEM = 0
                       AND NU_BIEN_ASEGURADO = 0
                       AND CD_DATO IN
                              (920034,
                               920035,
                               920036,
                               920037,
                               920039,
                               920046,
                               920030,
                               920052,
                               920053,
                               920054))
         LOOP
            W_STAT := '42';
            W_TOTAL_CERT := 0;

            W_STAT := '43';

            BEGIN
               SELECT NVL (SUM (PCEBD.VA_DATO), 0)
                 INTO W_TOTAL_CERT
                 FROM POLIZACERTENDOSOBIENDATO PCEBD, POLIZACERTIFICADO PC
                WHERE     PCEBD.CD_ENTIDAD = P_CD_ENTIDAD
                      AND PCEBD.CD_AREA = P_CD_AREA
                      AND PCEBD.NU_POLIZA = P_NU_POLIZA
                      AND PCEBD.NU_CERTIFICADO != 0
                      AND PCEBD.NU_ENDOSO =
                             (SELECT NU_ULTIMO_ENDOSO
                                FROM POLIZACERTIFICADO
                               WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                     AND CD_AREA = P_CD_AREA
                                     AND NU_POLIZA = P_NU_POLIZA
                                     AND NU_CERTIFICADO = 0)
                      AND PCEBD.NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO
                      AND PCEBD.CD_DATO = REG.CD_DATO
                      AND PCEBD.CD_ENTIDAD = PC.CD_ENTIDAD
                      AND PCEBD.CD_AREA = PC.CD_AREA
                      AND PCEBD.NU_POLIZA = PC.NU_POLIZA
                      AND PCEBD.NU_CERTIFICADO = PC.NU_CERTIFICADO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            W_STAT := '44';

            BEGIN
               SELECT VA_DATO
                 INTO W_COTIZACION
                 FROM COTIZACIONITEMBIENDATO
                WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                      AND NU_COTIZACION = P_NU_COTIZACION
                      AND NU_ITEM = 0
                      AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO
                      AND CD_DATO = REG.CD_DATO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  W_COTIZACION := 0;
            END;

            W_STAT := '45';

            W_TOTAL_CERT := W_TOTAL_CERT + W_COTIZACION;

            BEGIN
               SELECT VA_DATO
                 INTO W_LIMITE
                 FROM POLIZACERTENDOSOBIENDATO
                WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                      AND CD_AREA = P_CD_AREA
                      AND NU_POLIZA = P_NU_POLIZA
                      AND NU_CERTIFICADO = 0
                      AND NU_ENDOSO =
                             (SELECT NU_ULTIMO_ENDOSO
                                FROM POLIZACERTIFICADO
                               WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                     AND CD_AREA = P_CD_AREA
                                     AND NU_POLIZA = P_NU_POLIZA
                                     AND NU_CERTIFICADO = 0)
                      AND NU_BIEN_ASEGURADO = 0
                      AND CD_DATO = REG.CD_DATO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  W_LIMITE := 0;
            END;

            W_STAT := '46';

            BEGIN
               SELECT DE_DATO
                 INTO W_DE_DATO
                 FROM DATO
                WHERE CD_DATO = REG.CD_DATO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  P_ERROR := 'ERROR: NO SE ENCONTRO REGISTRO EN TABLA DATO';
                  RAISE NO_PROCESAR;
            END;

            W_STAT := '47';

            IF W_LIMITE = 0 AND W_TOTAL_CERT <> 0
            THEN
               P_ERROR :=
                     'ERROR: NO FUE CONTRATADA LA COBERTURA-'
                  || W_DE_DATO
                  || 'EN LA POLIZA MATRIZ';
               RAISE NO_PROCESAR;
            END IF;

            W_STAT := '48';

            IF W_LIMITE < W_TOTAL_CERT
            THEN
               P_ERROR :=
                  'ERROR: EL ACUMULADO DE SUMA ASEGURADA EN LOS CERTIFICADOS EXCEDE EL LIMITE DEFINIDO EN LA POLIZA MATRIZ EN EL DATO -'
                  || W_DE_DATO;
               RAISE NO_PROCESAR;
            END IF;

            W_STAT := '49';

            BEGIN
               IF W_TP_TRANSA = 1
               THEN
                  W_STAT := '50';

                  IF W_EXISTE + 1 = W_NU_LOCALES
                  THEN
                     W_STAT := '51';

                     IF W_LIMITE <> W_TOTAL_CERT
                     THEN
                        W_RESTANTE := W_LIMITE - W_TOTAL_CERT;

                        P_ERROR :=
                              'ERROR: AUN QUEDAN '
                           || W_RESTANTE
                           || ' RESTANTES QUE APLICAR A LA COBERTURA'
                           || W_DE_DATO;
                        RAISE NO_PROCESAR;
                     END IF;
                  END IF;

                  W_STAT := '52';
               ELSIF W_TP_TRANSA = 4
                     OR (W_TP_TRANSA = 2 AND W_FE_DESDE = W_FE_HASTA)
               THEN
                  W_STAT := '53';

                  IF W_EXISTE + 1 = W_NU_LOCALES
                  THEN
                     IF W_LIMITE <> W_TOTAL_CERT
                     THEN
                        W_RESTANTE := W_LIMITE - W_TOTAL_CERT;

                        P_ERROR :=
                              'ERROR: AUN QUEDAN '
                           || W_RESTANTE
                           || ' RESTANTES QUE APLICAR A LA COBERTURA'
                           || W_DE_DATO;
                        RAISE NO_PROCESAR;
                     END IF;
                  END IF;
               END IF;
            END;
         END LOOP;
      END;

      W_STAT := '54';
   END IF;

   W_STAT := '60';

   BEGIN
      SELECT VA_COMPONENTE
        INTO W_MT_MAXIMO
        FROM EVENTOVALOR
       WHERE     CD_EVENTO = 920103
             AND FE_EFECTIVA_EVENTO <= W_FE_DESDE
             AND FE_INICIO_REGISTRO <= W_FE_COTIZACION
             AND ( (FE_TERMINO_EVENTO IS NULL
                    OR FE_TERMINO_EVENTO > W_FE_DESDE)
                  OR (FE_TERMINO_REGISTRO IS NULL
                      OR FE_TERMINO_REGISTRO > W_FE_COTIZACION))
             AND DE_INDICE_EVENTO = '|0|0';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_MAXIMO := 0;
   END;

   W_STAT := '61';

   BEGIN
      SELECT SUM (MT_SUMA_ASEGURADA)
        INTO W_MT_SUMA_ASEGURADA
        FROM COTIZACIONITEMBIENGARANT
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_GARANTIA IN (9213, 9214, 9220, 9221, 9222);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEGURADA := 0;
   END;

   W_STAT := '62';

   BEGIN
      SELECT SUM (VA_DATO)
        INTO W_TOTAL_RIESGO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO IN (10, 20, 30, 40, 50, 60, 70, 80, 90)
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_TOTAL_RIESGO := 0;
   END;

   W_STAT := '63';

   W_SUMATORIA := W_TOTAL_RIESGO + W_MT_SUMA_ASEGURADA;



   ----------------------
   BEGIN
      BEGIN
         SELECT MT_TASA
           INTO W_MT_TASA_BS_DOL
           FROM TASACAMBIO
          WHERE     CD_MONEDA = 2
                AND TP_TASA = 'V'
                AND FE_EFECTIVA_TASA = TRUNC (SYSDATE);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            W_MT_TASA_BS_DOL := 0;
      END;

      IF W_CD_MONEDA = 1
      THEN
         W_STAT := '64';

         W_MT_TASA := W_MT_TASA_BS_DOL;

         IF W_MT_TASA = 0
         THEN
            P_ERROR :=
               'ERROR: NO SE CONSIGUIO VALOR DE TASA DE CAMBIO PARA DOLARES A LA FECHA '
               || TRUNC (SYSDATE);
            RAISE NO_PROCESAR;
         END IF;
      ELSIF W_CD_MONEDA = 6
      THEN
         BEGIN
            SELECT MT_TASA
              INTO W_MT_TASA_BS_EUR
              FROM TASACAMBIO
             WHERE     CD_MONEDA = 6
                   AND TP_TASA = 'V'
                   AND FE_EFECTIVA_TASA = TRUNC (SYSDATE);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               P_ERROR :=
                  'ERROR: NO SE CONSIGUIO VALOR DE TASA DE CAMBIO PARA EUROS  A LA FECHA '
                  || TRUNC (SYSDATE);
               RAISE NO_PROCESAR;
         END;

         W_MT_TASA := ROUND ( (W_MT_TASA_BS_DOL / W_MT_TASA_BS_EUR), 5);
      ELSE
         W_MT_TASA := 1;
      END IF;
   END;

   -------------------

   W_STAT := '65';


   IF W_MT_TASA = 0
   THEN
      P_ERROR :=
         'ERROR: NO SE CONSIGUIO VALOR DE TASA DE CAMBIO PARA LA FECHA '
         || TRUNC (SYSDATE);
      RAISE NO_PROCESAR;
   ELSE
      W_LIMITE_MAXIMO := W_MT_MAXIMO * W_MT_TASA;
   --      IF W_SUMATORIA > W_LIMITE_MAXIMO
   --      THEN
   --         P_ERROR :=
   --            'USTED HA EXCEDIDO EL TOTAL PERMITIDO DE SUMA ASEGURADA PARA ESTE PRODUCTO , COTIZACION CALIFICA PARA SER EMITIDA POR MULTILINEA '
   --            || W_SUMATORIA
   --            || '|'
   --            || W_LIMITE_MAXIMO;
   --         RAISE NO_PROCESAR;
   --      END IF;
   END IF;

   W_STAT := '67';

   BEGIN
      SELECT VA_DATO
        INTO W_COTIZA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920013;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_COTIZA := 0;
   END;

   W_STAT := '68';

   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_MT_SUMA_TERREMOTO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO IN (10, 20, 30, 40, 50, 60, 70, 90)
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0)
             AND CD_DATO = 920024;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_TERREMOTO := 0;
   END;

   W_STAT := '69';

   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_TOTAL_RIESGO_ZONA_1
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO IN (920052);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_TOTAL_RIESGO_ZONA_1 := 0;
   END;


   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_TOTAL_RIESGO_ZONA_2
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO IN (920053);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_TOTAL_RIESGO_ZONA_2 := 0;
   END;


   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_TOTAL_RIESGO_ZONA_4
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO IN (920054);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_TOTAL_RIESGO_ZONA_4 := 0;
   END;

   W_TOTAL_RIESGO_TERREMOTO :=
      W_TOTAL_RIESGO_ZONA_1 + W_TOTAL_RIESGO_ZONA_2 + W_TOTAL_RIESGO_ZONA_4;


   W_STAT := '70';

   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_CANT_ZONAS
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO IN (920027, 920028, 920029);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_CANT_ZONAS := 0;
   END;

   IF W_CANT_ZONAS <> 0 AND W_TOTAL_RIESGO_TERREMOTO = 0
   THEN
      P_ERROR :=
         'ERROR: DEBE INGRESAR VALORES A RIESGO POR ZONA PARA LA COBERTURA TERREMOTO';
      RAISE NO_PROCESAR;
   END IF;


   IF W_TOTAL_RIESGO_TERREMOTO <> 0
   THEN
      IF W_TOTAL_RIESGO_TERREMOTO <> W_MT_SUMA_TERREMOTO
      THEN
         P_ERROR :=
               'ERROR: LOS VALORES TOTALES A RIESGO '
            || W_MT_SUMA_TERREMOTO
            || ' NO COINCIDEN CON EL MONTO DIGITADO 
            EN LOS VALORES A RIESGO POR ZONA '
            || W_TOTAL_RIESGO_TERREMOTO;
         RAISE NO_PROCESAR;
      END IF;
   END IF;

   W_STAT := '71';

   IF W_COTIZA = 0
   THEN
      NULL;
   --      UPDATE COTIZACIONITEM
   --         SET ST_COTIZACION = 2, CD_CAUSA_RECHAZO = 2
   --       WHERE CD_ENTIDAD = P_CD_ENTIDAD AND NU_COTIZACION = P_NU_COTIZACION;
   ELSE
      IF W_TP_TRANSA != 4
      THEN
         UPDATE COTIZACIONITEM
            SET ST_COTIZACION = 0, CD_CAUSA_RECHAZO = NULL
          WHERE CD_ENTIDAD = P_CD_ENTIDAD AND NU_COTIZACION = P_NU_COTIZACION;
      END IF;
   END IF;


   --- if   NVL (w_ST_COTIZACION, 0)  = 2 and
   ---           NVL (w_CD_CAUSA_RECHAZO, 0) = 2
   ----  then
   ---   P_ERROR :=
   ---            'ERROR: LA COTIZACIÓN SE ENCUENTRA RECHAZADA' ;
   ----     RAISE NO_PROCESAR;
   --- END IF;


   W_STAT := '72';

   -----------------------------------------------------YB Se calcula la tasa y  prima de reconstruccion de archivo --------------------------------------------------------------------------------

   BEGIN
      SELECT SUM (MT_PRIMA_BRUTA)
        INTO W_MT_PRIMA_NETA
        FROM COTIZACIONITEMBIENGARANT
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_GARANTIA NOT IN (9220, 9221, 9222, 9233);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_PRIMA_NETA := 0;
   END;

   W_STAT := '73';

   BEGIN
      SELECT SUM (VA_DATO)
        INTO W_VTR_RC
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO NOT IN (80, 110)
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VTR_RC := 0;
   END;

   W_STAT := '74';

   BEGIN
      SELECT VA_DATO
        INTO W_PERDIDA_RENTA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920039;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PERDIDA_RENTA := 0;
   END;

   W_STAT := '74.1';

   BEGIN
      SELECT VA_DATO
        INTO W_BIENES_REFRIG
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920030;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_BIENES_REFRIG := 0;
   END;

   W_STAT := '75';

   BEGIN
      SELECT VA_DATO
        INTO W_PORC_INDIRECTA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920040;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PORC_INDIRECTA := 0;
   END;

   W_STAT := '76';

   BEGIN
      SELECT VA_DATO
        INTO W_PERDIDA_INDIRECTA_70
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 70
             AND CD_DATO = 920024;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PERDIDA_INDIRECTA_70 := 0;
   END;

   W_STAT := '77';

   BEGIN
      SELECT VA_DATO
        INTO W_PERDIDA_INDIRECTA_90
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 90
             AND CD_DATO = 920024;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PERDIDA_INDIRECTA_90 := 0;
   END;

   W_STAT := '78';

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SUMA_REC
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920049;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SUMA_REC := 0;
   END;

   W_STAT := '79';


   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SUMA_HONORARIO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920051;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SUMA_HONORARIO := 0;
   END;



   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SUMA_DEMOLICION
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920050;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SUMA_DEMOLICION := 0;
   END;

   W_STAT := '80';

   -----------------------------------------------------SE COLOCA PARA REALIZAR EL CALCULO DE LA PRIMA COMERCIAL-----

   BEGIN        --EXTRAE EL VALOR DEL COMPONENTE PARA LA COMISION DEL PRODUCTO
      SELECT VA_COMPONENTE
        INTO W_PORC_COMISION_EVE
        FROM EVENTOVALOR
       WHERE     CD_EVENTO = '990292'
             AND FE_EFECTIVA_EVENTO <= W_FE_DESDE
             AND FE_INICIO_REGISTRO <= W_FE_COTIZACION
             AND ( (FE_TERMINO_EVENTO IS NULL
                    OR FE_TERMINO_EVENTO > W_FE_DESDE)
                  OR (FE_TERMINO_REGISTRO IS NULL
                      OR FE_TERMINO_REGISTRO > W_FE_COTIZACION))
             AND DE_INDICE_EVENTO = W_CD_CANAL_VENTA || '|0|0';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR :=
            'ERROR: NO SE ENCONTRO REGISTRO EN EL EVENTO (990292) PARA TARIFA  Y EL CANAL DE VENTA '
            || W_CD_CANAL_VENTA;
         RAISE NO_PROCESAR;
   END;

   W_STAT := '5';

   BEGIN --EXTRAE EL VALOR DEL COMPONENTE PARA LA COMISION MAXIMA DEL PRODUCTO
      SELECT VA_COMPONENTE
        INTO W_PORC_COMISION_MAX
        FROM EVENTOVALOR
       WHERE     CD_EVENTO = '920091'
             AND FE_EFECTIVA_EVENTO <= W_FE_DESDE
             AND FE_INICIO_REGISTRO <= W_FE_COTIZACION
             AND ( (FE_TERMINO_EVENTO IS NULL
                    OR FE_TERMINO_EVENTO > W_FE_DESDE)
                  OR (FE_TERMINO_REGISTRO IS NULL
                      OR FE_TERMINO_REGISTRO > W_FE_COTIZACION))
             AND DE_INDICE_EVENTO = W_CD_CANAL_VENTA || '|0|0';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR :=
            'ERROR: NO SE ENCONTRO REGISTRO EN EL EVENTO (920091) PARA TARIFA';
         RAISE NO_PROCESAR;
   END;

   W_STAT := '6';

   BEGIN                             -- EXTRAE LA COMISION DEL DATO % COMISION
      SELECT VA_DATO
        INTO W_COMISION
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920056;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT VA_DATO
              INTO W_COMISION
              FROM POLIZACERTENDOSOBIENDATO
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND CD_AREA = W_CD_AREA
                   AND NU_POLIZA = W_NU_POLIZA
                   AND NU_CERTIFICADO = 0
                   AND NU_ENDOSO =
                          (SELECT NU_ULTIMO_ENDOSO
                             FROM POLIZACERTIFICADO
                            WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                  AND CD_AREA = W_CD_AREA
                                  AND NU_POLIZA = W_NU_POLIZA
                                  AND NU_CERTIFICADO = 0)
                   AND NU_BIEN_ASEGURADO = 0
                   AND CD_DATO = 920056;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               P_ERROR := 'ERROR: NO SE ENCONTRO REGISTRO EL DATO COMISION';
               RAISE NO_PROCESAR;
         END;
   END;

   IF W_COMISION > W_PORC_COMISION_MAX
   THEN
      P_ERROR :=
         'LA COMISION SUPERA EL PORCENTAJE MAXIMO PERMITIDO PARA ESTE PRODUCTO'
         || ' ('
         || W_PORC_COMISION_MAX
         || '%)';
      RAISE NO_PROCESAR;
   END IF;

   IF W_CD_CANAL_VENTA = 3
   THEN
      IF W_COMISION <> W_PORC_COMISION_EVE
      THEN
         W_COMISION_TOTAL := W_PORC_COMISION_EVE;
         P_MENSAJE :=
            'LA COMISION NO PUEDE SER MODIFICADA PARA EL CANAL DE VENTA SELECCIONADO, SE PROCEDERÁ A AJUSTAR LA MISMA';
      ELSE
         W_COMISION_TOTAL := W_PORC_COMISION_EVE;
      END IF;
   ELSE
      W_COMISION_TOTAL := W_COMISION;
   END IF;


   W_IMPUESTO :=
      FUN_IMPUESTO_PROPERTY_CONFIG (P_CD_ENTIDAD,
                                    P_NU_COTIZACION,
                                    0,
                                    NVL (W_CD_AREA, 0),
                                    NVL (W_NU_POLIZA, 0),
                                    NVL (W_NU_CERTIFICADO, 0),
                                    W_ERROR);

   IF W_ERROR IS NOT NULL
   THEN
      P_ERROR := W_STAT || '-' || W_ERROR;
      RAISE NO_PROCESAR;
   END IF;


   W_STAT := '10';



   W_COMISION_PORC := W_COMISION_TOTAL / 100;

   W_TOTAL := 1 - W_COMISION_PORC - W_IMPUESTO;



   W_STAT := '81';

   W_TOTAL_PERDIDA :=
      ( (W_PERDIDA_INDIRECTA_90 + W_PERDIDA_INDIRECTA_70)
       * (W_PORC_INDIRECTA / 100));

   W_SUMA := W_VTR_RC + W_PERDIDA_RENTA + W_TOTAL_PERDIDA;

   W_STAT := '82';

   IF W_VTR_RC > 0
   THEN
      W_STAT := '83';

      W_TASA_TECNICA := ( (W_MT_PRIMA_NETA / W_SUMA) * 100);

      W_STAT := '84';
      
      BEGIN
        SELECT TO_NUMBER(VA_DATO) / 100
        INTO W_DCTO_RCGO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920004;
       EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
            P_ERROR := 'NO SE ENCONTRO DCTO / RCGO, DATO (920004)';
            RAISE NO_PROCESAR;
       END;        

     -- W_PRIMA_NETA := ( ( (W_SUMA_REC * W_TASA_TECNICA) / 100) / W_TOTAL);        COMENTADO ADR 14.11.2023 X TICKET 7169
      W_PRIMA_NETA := ( ( (W_SUMA_REC * W_TASA_TECNICA) / 100) / W_TOTAL) * (1 + W_DCTO_RCGO);
      W_PRIMA_BRUTA := ( (W_SUMA_REC * W_TASA_TECNICA) / 100);
      W_PRIMA_PRORRATA := ( ( (W_SUMA_REC * W_TASA_TECNICA) / 100) / W_TOTAL);
      W_MT_COMISION := ( (W_PRIMA_NETA * W_COMISION) / 100);

      W_STAT := '85';


      UPDATE COTIZACIONITEMBIENGARANT
         SET TA_RIESGO = ROUND (W_TASA_TECNICA, 6),
             MT_PRIMA_NETA = ROUND (W_PRIMA_NETA, 6),
             MT_PRIMA_BRUTA = ROUND (W_PRIMA_BRUTA, 6),
             MT_PRIMA_PRORRATA = ROUND (W_PRIMA_PRORRATA, 6),
             MT_COMISION = ROUND (W_MT_COMISION, 6)
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 10
             AND CD_GARANTIA = 9220;
   END IF;

   W_STAT := '86';


   IF W_SUMA_HONORARIO > 0
   THEN
      W_STAT := '87';
      
            BEGIN
        SELECT TO_NUMBER(VA_DATO) / 100
        INTO W_DCTO_RCGO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920004;
       EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
            P_ERROR := 'NO SE ENCONTRO DCTO / RCGO, DATO (920004)';
            RAISE NO_PROCESAR;
       END; 

      W_TASA_TECNICA := ( (W_MT_PRIMA_NETA / W_SUMA) * 100);


      W_STAT := '88';

      W_PRIMA_NETA :=
         ( ( (W_SUMA_HONORARIO * W_TASA_TECNICA) / 100) / W_TOTAL);
      W_PRIMA_BRUTA := ( (W_SUMA_HONORARIO * W_TASA_TECNICA) / 100);
      W_PRIMA_PRORRATA :=
         ( ( (W_SUMA_HONORARIO * W_TASA_TECNICA) / 100) / W_TOTAL);
      --W_MT_COMISION := ( (W_PRIMA_NETA * W_COMISION) / 100);

      W_PRIMA_NETA := W_PRIMA_NETA * (1 + W_DCTO_RCGO);     --AGG ADR 14.11.2023 POR TICKET 7169
      W_MT_COMISION := ( (W_PRIMA_NETA * W_COMISION) / 100);
      
      
      W_STAT := '89';

      UPDATE COTIZACIONITEMBIENGARANT
         SET TA_RIESGO = ROUND (W_TASA_TECNICA, 6),
             MT_PRIMA_NETA = ROUND (W_PRIMA_NETA, 6),
             MT_PRIMA_BRUTA = ROUND (W_PRIMA_BRUTA, 6),
             MT_PRIMA_PRORRATA = ROUND (W_PRIMA_PRORRATA, 6),
             MT_COMISION = ROUND (W_MT_COMISION, 6)
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 10
             AND CD_GARANTIA = 9222;
   END IF;


   IF W_SUMA_DEMOLICION > 0
   THEN
      W_STAT := '87';

      W_TASA_TECNICA := ( (W_MT_PRIMA_NETA / W_SUMA) * 100);


      W_STAT := '88';

      W_PRIMA_NETA :=
         ( ( (W_SUMA_DEMOLICION * W_TASA_TECNICA) / 100) / W_TOTAL);
      W_PRIMA_BRUTA := ( (W_SUMA_DEMOLICION * W_TASA_TECNICA) / 100);
      W_PRIMA_PRORRATA :=
         ( ( (W_SUMA_DEMOLICION * W_TASA_TECNICA) / 100) / W_TOTAL);
      W_MT_COMISION := ( (W_PRIMA_NETA * W_COMISION) / 100);

      W_STAT := '89';

      UPDATE COTIZACIONITEMBIENGARANT
         SET TA_RIESGO = ROUND (W_TASA_TECNICA, 6),
             MT_PRIMA_NETA = ROUND (W_PRIMA_NETA, 6),
             MT_PRIMA_BRUTA = ROUND (W_PRIMA_BRUTA, 6),
             MT_PRIMA_PRORRATA = ROUND (W_PRIMA_PRORRATA, 6),
             MT_COMISION = ROUND (W_MT_COMISION, 6)
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 10
             AND CD_GARANTIA = 9221;
   END IF;



   W_STAT := '90';

   BEGIN
      SELECT NVL (SUM (MT_SUMA_ASEGURADA), 0)
        INTO W_MT_OBLIG
        FROM COTIZACIONITEMBIENGARANT
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_GARANTIA IN
                    (9201, 9202, 9203, 9204, 9205, 9206, 9207, 9208);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   W_STAT := '91';

   IF W_MT_OBLIG = 0
   THEN
      P_ERROR :=
         'ERROR: NO SE PUEDE EMITIR EL CERTIFICADO SIN POSEER AL MENOS UN BIEN OBLIGATORIO';
      RAISE NO_PROCESAR;
   END IF;

   W_STAT := '92';

   IF W_TP_CONTRATO = 2 AND P_NU_CERTIFICADO = 0
   THEN
      BEGIN
         SELECT NVL (SUM (VA_DATO), 0)
           INTO W_MT_OBLIG
           FROM POLIZACERTENDOSOBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND CD_AREA = P_CD_AREA
                AND NU_POLIZA = P_NU_POLIZA
                AND NU_CERTIFICADO = 0
                AND NU_ENDOSO =
                       (SELECT NU_ULTIMO_ENDOSO
                          FROM POLIZACERTIFICADO
                         WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                               AND CD_AREA = P_CD_AREA
                               AND NU_POLIZA = P_NU_POLIZA
                               AND NU_CERTIFICADO = 0)
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO IN
                       (920124,
                        920224,
                        920324,
                        920424,
                        920524,
                        920624,
                        920724,
                        920924);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            W_MT_OBLIG := 0;
      END;

      W_STAT := '93';

      IF W_MT_OBLIG = 0
      THEN
         P_ERROR :=
            'ERROR: NO SE PUEDE EMITIR EL CERTIFICADO SIN POSEER AL MENOS UN BIEN OBLIGATORIO';
         RAISE NO_PROCESAR;
      END IF;
   END IF;

   ---------vidrios-------------


   ---- PERDIDA DE RENTA-------
   W_STAT := '94';

   BEGIN                            --EXTRAE LA SA DE LA COBERTURA DE INCENDIO
      SELECT (VA_DATO)
        INTO W_MT_SUMA_ASEG_EDIF
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 10
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEG_EDIF := 0;
   END;

   W_STAT := '95';


   BEGIN                            --EXTRAE LA SA DE LA COBERTURA DE INCENDIO
      SELECT (VA_DATO)
        INTO W_MT_SUMA_ASEG_EXIS
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 90
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEG_EXIS := 0;
   END;

   W_STAT := '96.1';

   BEGIN                            --EXTRAE LA SA DE LA COBERTURA DE INCENDIO
      SELECT (VA_DATO)
        INTO W_MT_SUMA_ASEG_EQ
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 60
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEG_EQ := 0;
   END;

   W_STAT := '96.2';

   IF W_MT_SUMA_ASEG_EQ = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO IN (920035, 920036, 920037);
   END IF;

   W_STAT := '96.3';

   BEGIN                            --EXTRAE LA SA DE LA COBERTURA DE INCENDIO
      SELECT NVL (VA_DATO, 0)
        INTO W_MT_SUMA_ASEG_MAQ
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 70
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEG_MAQ := 0;
   END;


   BEGIN                                          --EXTRAE LA SA de inundacion
      SELECT NVL (VA_DATO, 0)
        INTO W_MT_SUMA_INUNDACION
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920021;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_INUNDACION := 0;
   END;

   IF W_MT_SUMA_INUNDACION = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920020;
   END IF;


   W_STAT := '96.4';

   IF W_MT_SUMA_ASEG_MAQ = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920034;
   END IF;



   BEGIN   --EXTRAE LA SA DE LA COBERTURA DE INCENDIO  ----- PREGUNTAR A PEDRO
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_MT_SUMA_ASEG_IND
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO IN (70, 90)
             AND CD_DATO = 920047;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_MT_SUMA_ASEG_IND := 0;
   END;

   W_STAT := '96.6';

   IF W_MT_SUMA_ASEG_IND = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO in ( 920040 , 920099 , 920100);
   END IF;


   W_STAT := '97';


   IF W_BIENES_REFRIG > W_MT_SUMA_ASEG_EXIS
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = W_MT_SUMA_ASEG_EXIS
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920030;

      W_BIENES_REFRIG := W_MT_SUMA_ASEG_EXIS;
   END IF;

   IF W_BIENES_REFRIG = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920003;
   END IF;

   BEGIN
      SELECT VA_DATO
        INTO W_CARENCIA
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920003;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT VA_DATO
              INTO W_CARENCIA
              FROM POLIZACERTENDOSOBIENDATO
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND CD_AREA = P_CD_AREA
                   AND NU_POLIZA = P_NU_POLIZA
                   AND NU_CERTIFICADO = 0
                   AND NU_ENDOSO =
                          (SELECT NU_ULTIMO_ENDOSO
                             FROM POLIZACERTIFICADO
                            WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                                  AND CD_AREA = P_CD_AREA
                                  AND NU_POLIZA = P_NU_POLIZA
                                  AND NU_CERTIFICADO = 0)
                   AND NU_BIEN_ASEGURADO = 0
                   AND CD_DATO = 920003;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               W_CARENCIA := 0;
         END;
   END;


   IF W_CARENCIA = 0 AND W_BIENES_REFRIG > 0
   THEN
      P_ERROR :=
         ' ERROR : DEBE ASIGNAR UN VALOR EN EL DATO FACTORES PERÍODO DE CARENCIA ';
      RAISE NO_PROCESAR;
   END IF;



   W_STAT := '98';

   BEGIN
      SELECT NVL (SUM (VA_DATO), 0)
        INTO W_VTR_VALIDA_HURTO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND CD_DATO = 920024
             AND NU_BIEN_ASEGURADO IN (40, 50, 60, 70, 90)
             AND NU_BIEN_ASEGURADO NOT IN
                    (SELECT NU_BIEN_ASEGURADO
                       FROM COTIZACIONITEMBIEN
                      WHERE     FE_EXCLUSION IS NOT NULL
                            AND CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_VTR_VALIDA_HURTO := 0;
   END;

   W_STAT := '99';


   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_SA_HURTO
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920022;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_SA_HURTO := 0;
   END;

   W_STAT := '100';

   IF W_SA_HURTO > 0 AND W_VTR_VALIDA_HURTO = 0
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = 0
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920022;
   END IF;


   W_STAT := '48';

   BEGIN                                     --EXTRAE EL MAXIMO DE LA SA HURTO
      SELECT VA_COMPONENTE / 100
        INTO W_LIM_HURTO
        FROM EVENTOVALOR
       WHERE     CD_EVENTO = '920110'
             AND FE_EFECTIVA_EVENTO <= W_FE_DESDE
             AND FE_INICIO_REGISTRO <= W_FE_COTIZACION
             AND ( (FE_TERMINO_EVENTO IS NULL
                    OR FE_TERMINO_EVENTO > W_FE_DESDE)
                  OR (FE_TERMINO_REGISTRO IS NULL
                      OR FE_TERMINO_REGISTRO > W_FE_COTIZACION))
             AND DE_INDICE_EVENTO = '|0|0';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR := 'ERROR: NO SE ENCONTRO VALOR EN EL EVENTO (920110)';
         RAISE NO_PROCESAR;
   END;

   W_STAT := '49';

   W_LIM_SA_HURTO := W_SA_ROBO * W_LIM_HURTO;


   IF W_SA_HURTO > W_LIM_SA_HURTO
   THEN
      UPDATE COTIZACIONITEMBIENDATO
         SET VA_DATO = W_LIM_SA_HURTO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 120
             AND CD_DATO = 920022;
   END IF;


   IF W_NU_LOCALES = 0
   THEN
      P_ERROR := 'ERROR: EL DATO TOTAL DE LOCALES DEBEN SER MAYOR A CERO';
      RAISE NO_PROCESAR;
   END IF;



   ------------------------prima minima --------
   W_STAT := '122';

   BEGIN
      SELECT ROUND (SUM (MT_PRIMA_NETA), 2)
        INTO W_PRIMA_TOTAL
        FROM COTIZACIONITEMBIENGARANT
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PRIMA_TOTAL := 0;
   END;

   W_STAT := '123';

   BEGIN
      --SELECT ROUND (VA_COMPONENTE * W_MT_TASA * W_NU_LOCALES, 2)
      -- comentado el dia 04/09/2018 solicitado por el usuario ya que la misma no trabaja con localidades
      SELECT ROUND (VA_COMPONENTE * W_MT_TASA, 2)
        INTO W_PRIMA_MINIMA
        FROM EVENTOVALOR
       WHERE     CD_EVENTO = '920117'
             AND FE_EFECTIVA_EVENTO <= W_FE_DESDE
             AND FE_INICIO_REGISTRO <= W_FE_COTIZACION
             AND ( (FE_TERMINO_EVENTO IS NULL
                    OR FE_TERMINO_EVENTO > W_FE_DESDE)
                  OR (FE_TERMINO_REGISTRO IS NULL
                      OR FE_TERMINO_REGISTRO > W_FE_COTIZACION))
             AND DE_INDICE_EVENTO = '|0|0';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_ERROR := 'ERROR: NO SE ENCONTRO VALOR EN EL EVENTO (920117)';
         RAISE NO_PROCESAR;
   END;

   W_STAT := '109';



   IF W_PRIMA_TOTAL < W_PRIMA_MINIMA
   THEN
      W_PRIMA_FULL := 0;

      BEGIN
         FOR REG
            IN (SELECT DISTINCT (NU_BIEN_ASEGURADO)
                  FROM COTIZACIONITEMBIENGARANT
                 WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                       AND NU_COTIZACION = P_NU_COTIZACION
                       AND NU_ITEM = 0)
         LOOP
            W_STAT := '110';

            BEGIN
               FOR REP
                  IN (SELECT *
                        FROM COTIZACIONITEMBIENGARANT
                       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                             AND NU_COTIZACION = P_NU_COTIZACION
                             AND NU_ITEM = 0
                             AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO)
               LOOP
                  W_STAT := '110.1';

                  BEGIN
                     SELECT W_PRIMA_FULL
                            + ROUND (
                                 (MT_PRIMA_NETA
                                  * ( (W_PRIMA_MINIMA / W_PRIMA_TOTAL))),
                                 2)
                       INTO W_PRIMA_FULL
                       FROM COTIZACIONITEMBIENGARANT
                      WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                            AND NU_COTIZACION = P_NU_COTIZACION
                            AND NU_ITEM = 0
                            AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO
                            AND CD_GARANTIA = REP.CD_GARANTIA;
                  END;

                  W_STAT := '110.2';
               END LOOP;
            END;

            UPDATE COTIZACIONITEMBIENGARANT
               SET MT_PRIMA_NETA =
                      ROUND (
                         MT_PRIMA_NETA * (W_PRIMA_MINIMA / W_PRIMA_TOTAL),
                         2),
                   MT_COMISION =
                      ROUND (
                         DECODE (
                            MT_COMISION,
                            0, 0,
                            MT_COMISION * (W_PRIMA_MINIMA / W_PRIMA_TOTAL)),
                         2),
                   MT_PRIMA_PRORRATA =
                      ROUND (
                         MT_PRIMA_PRORRATA * (W_PRIMA_MINIMA / W_PRIMA_TOTAL),
                         2),
                   MT_PRIMA_BRUTA =
                      ROUND (
                         MT_PRIMA_BRUTA * (W_PRIMA_MINIMA / W_PRIMA_TOTAL),
                         2)
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND NU_COTIZACION = P_NU_COTIZACION
                   AND NU_ITEM = 0
                   AND NU_BIEN_ASEGURADO = REG.NU_BIEN_ASEGURADO;
         END LOOP;
      END;



      W_STAT := '111';

      --W_PRIMA_FULL

      W_STAT := '112';



      IF W_PRIMA_FULL <> W_PRIMA_MINIMA
      THEN
         -------VERIFICAR PROC DESPUES DE LA REUNION
         W_STAT := '113';

         UPDATE COTIZACIONITEMBIENGARANT
            SET MT_PRIMA_NETA =
                   MT_PRIMA_NETA + (W_PRIMA_MINIMA - W_PRIMA_FULL),
                MT_PRIMA_BRUTA =
                   MT_PRIMA_BRUTA + (W_PRIMA_MINIMA - W_PRIMA_FULL),
                MT_PRIMA_PRORRATA =
                   MT_PRIMA_PRORRATA + (W_PRIMA_MINIMA - W_PRIMA_FULL),
                MT_COMISION =
                   DECODE (
                      MT_COMISION,
                      0, 0,
                        (MT_PRIMA_NETA + (W_PRIMA_MINIMA - W_PRIMA_FULL))
                      * W_PORC_COMISION
                      / 100)
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND NU_BIEN_ASEGURADO =
                       (SELECT MIN (NU_BIEN_ASEGURADO)
                          FROM COTIZACIONITEMBIENGARANT
                         WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                               AND NU_COTIZACION = P_NU_COTIZACION
                               AND NU_ITEM = 0)
                AND CD_GARANTIA =
                       (SELECT MIN (CD_GARANTIA)
                          FROM COTIZACIONITEMBIENGARANT
                         WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                               AND NU_COTIZACION = P_NU_COTIZACION
                               AND NU_ITEM = 0
                               AND NU_BIEN_ASEGURADO =
                                      (SELECT MIN (NU_BIEN_ASEGURADO)
                                         FROM COTIZACIONITEMBIENGARANT
                                        WHERE CD_ENTIDAD = P_CD_ENTIDAD
                                              AND NU_COTIZACION =
                                                     P_NU_COTIZACION
                                              AND NU_ITEM = 0));
      END IF;
   END IF; 

   IF    W_TP_TRANSA = 2  --W_TP_TRANSA IN (2, 4)
   THEN
      BEGIN
         SELECT TO_NUMBER (VA_DATO)
           INTO W_SUMA_MOTIN
           FROM COTIZACIONITEMBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO = 920019;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_ERROR := 'NO SE ENCONTRO SUMA MOTIN, DATO (920019)';
            RETURN;
      END;

      BEGIN
         SELECT TO_NUMBER (VA_DATO)
           INTO W_SUMA_DAGUA
           FROM COTIZACIONITEMBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO = 920026;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_ERROR := 'NO SE ENCONTRO SUMA MOTIN, DATO (920026)';
            RETURN;
      END;
    /*
      IF W_SUMA_MOTIN <> 1
      THEN
         P_MENSAJE :=
            'ADVERTENCIA: PARA MANTENER EL HISTORICO DE LA SUMA ASEGURADA DE MOTIN, EL VALOR DEL DATO DEBE SER IGUAL A 1';
      END IF;

      IF W_SUMA_DAGUA > 100
      THEN
         P_MENSAJE :=
            'ADVERTENCIA: PARA MANTENER EL HISTORICO DE LA SUMA ASEGURADA DE DAÑOS POR AGUA, EL VALOR DEL DATO DEBE SER EL DE LA EMISION';
      END IF;

      IF W_SUMA_MOTIN <> 1 AND W_SUMA_DAGUA > 100
      THEN
         P_MENSAJE :=
            'ADVERTENCIA: PARA MANTENER EL HISTORICO DE LA SUMA ASEGURADA DE DAÑOS POR AGUA, EL VALOR DEL DATO DEBE SER EL DE LA EMISION Y PARA MANTENER EL HISTORICO DE LA SUMA ASEGURADA DE MOTIN, EL VALOR DEL DATO DEBE SER IGUAL A 1';
      END IF; */ --comentado Adr. 04.01.2024 x solicitud 7499
   END IF;

   ----- solicitud ticket 5490 -----

   BEGIN
      SELECT NVL (VA_DATO, 0)
        INTO W_PORC_PI
        FROM COTIZACIONITEMBIENDATO
       WHERE     CD_ENTIDAD = P_CD_ENTIDAD
             AND NU_COTIZACION = P_NU_COTIZACION
             AND NU_ITEM = 0
             AND NU_BIEN_ASEGURADO = 0
             AND CD_DATO = 920040;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         W_PORC_PI := 0;
   END;
   

   IF W_PORC_PI > 0
   THEN
      BEGIN
         SELECT NVL (SUM (VA_DATO), 0)
           INTO W_VTR_PI
           FROM COTIZACIONITEMBIENDATO
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND CD_DATO = 920024
                AND NU_BIEN_ASEGURADO IN (70, 90)
                AND NU_BIEN_ASEGURADO NOT IN
                       (SELECT NU_BIEN_ASEGURADO
                          FROM COTIZACIONITEMBIEN
                         WHERE     FE_EXCLUSION IS NOT NULL
                               AND CD_ENTIDAD = P_CD_ENTIDAD
                               AND NU_COTIZACION = P_NU_COTIZACION
                               AND NU_ITEM = 0);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            W_VTR_PI := 0;
      END;

      IF W_VTR_PI = 0
      THEN

         UPDATE COTIZACIONITEMBIENDATO
            SET VA_DATO = 0
          WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                AND NU_COTIZACION = P_NU_COTIZACION
                AND NU_ITEM = 0
                AND NU_BIEN_ASEGURADO = 0
                AND CD_DATO IN (920040, 920099, 920100);
      END IF;

      IF W_VTR_PI > 0
      THEN
         BEGIN
            SELECT NVL (VA_DATO, 0)
              INTO W_PI_MAQ
              FROM COTIZACIONITEMBIENDATO
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND NU_COTIZACION = P_NU_COTIZACION
                   AND NU_ITEM = 0
                   AND CD_DATO = 920099
                   AND NU_BIEN_ASEGURADO = 0
                   AND NU_BIEN_ASEGURADO NOT IN
                          (SELECT NU_BIEN_ASEGURADO
                             FROM COTIZACIONITEMBIEN
                            WHERE     FE_EXCLUSION IS NOT NULL
                                  AND CD_ENTIDAD = P_CD_ENTIDAD
                                  AND NU_COTIZACION = P_NU_COTIZACION
                                  AND NU_ITEM = 0);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               W_PI_MAQ := 0;
         END;

         IF W_MT_SUMA_ASEG_MAQ = 0
         THEN
            UPDATE COTIZACIONITEMBIENDATO
               SET VA_DATO = 0
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND NU_COTIZACION = P_NU_COTIZACION
                   AND NU_ITEM = 0
                   AND NU_BIEN_ASEGURADO = 0
                   AND CD_DATO IN (920099);

            W_PI_MAQ := 0;
         END IF;

         BEGIN
            SELECT NVL (VA_DATO, 0)
              INTO W_PI_EXIS
              FROM COTIZACIONITEMBIENDATO
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND NU_COTIZACION = P_NU_COTIZACION
                   AND NU_ITEM = 0
                   AND CD_DATO = 920100
                   AND NU_BIEN_ASEGURADO= 0
                   AND NU_BIEN_ASEGURADO NOT IN
                          (SELECT NU_BIEN_ASEGURADO
                             FROM COTIZACIONITEMBIEN
                            WHERE     FE_EXCLUSION IS NOT NULL
                                  AND CD_ENTIDAD = P_CD_ENTIDAD
                                  AND NU_COTIZACION = P_NU_COTIZACION
                                  AND NU_ITEM = 0);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               W_PI_EXIS := 0;
         END;

         IF W_MT_SUMA_ASEG_EXIS = 0
         THEN
            UPDATE COTIZACIONITEMBIENDATO
               SET VA_DATO = 0
             WHERE     CD_ENTIDAD = P_CD_ENTIDAD
                   AND NU_COTIZACION = P_NU_COTIZACION
                   AND NU_ITEM = 0
                   AND NU_BIEN_ASEGURADO = 0
                   AND CD_DATO IN (920100);

            W_PI_EXIS := 0;
         END IF;


         IF W_PI_EXIS = 0 AND W_PI_MAQ = 0
         THEN
            P_ERROR :=
               'ERROR: DEBE SELECCIONAR AL MENOS UN BIEN, PARA EL CALCULO APLICADO DE PERDIDA INDIRECTA';
            RAISE NO_PROCESAR ;
         END IF;
      END IF;
   END IF;
------------ hasta aqui ticket 5490 --------------
EXCEPTION
   WHEN NO_PROCESAR
   THEN
      NULL;
   WHEN OTHERS
   THEN
      P_ERROR :=
            'VALIDA_PRODUCTO_CAPITAL '
         || ', en  '
         || W_STAT
         || ' ** '
         || SQLERRM;
END PROC_VALIDA_CAPITAL_CONFIG;
/
