CREATE OR REPLACE FUNCTION CalculateBondPrice_1 (
    p_obligacijas_id IN NUMBER
)
RETURN NUMBER
IS
    v_atlaide               NUMBER(15, 2);
    v_kupona_maksajums      NUMBER(15, 2);
    v_gadi_lidz_terminam    NUMBER;
    v_tagad_kupona_vert     NUMBER(15, 2) := 0;
    v_tagad_nomin_vert      NUMBER(15, 2);
    v_obligacijas_vert      NUMBER(15, 2) := 0;
    v_nomin_vert            NUMBER(15, 2);
    v_kupons                NUMBER(15, 2);
    v_dzesanas_datums       DATE;
    v_emitenta_id           NUMBER;
BEGIN
    SELECT NOMINALA_VERTIBA, KUPONS, DZESANAS_DATUMS, EMITENTA_ID
    INTO v_nomin_vert, v_kupons, v_dzesanas_datums, v_emitenta_id
    FROM OBLIGACIJAS_1
    WHERE OBLIGACIJAS_ID = p_obligacijas_id;

    SELECT 
        CASE
            WHEN KREDITA_REITINGS = 'AAA' THEN 0.1
            WHEN KREDITA_REITINGS = 'AA'  THEN 0.09
            WHEN KREDITA_REITINGS = 'A'   THEN 0.08
            WHEN KREDITA_REITINGS = 'BBB' THEN 0.07
            WHEN KREDITA_REITINGS = 'BB'  THEN 0.06
            WHEN KREDITA_REITINGS = 'B'   THEN 0.05
            WHEN KREDITA_REITINGS = 'CCC' THEN 0.04
            WHEN KREDITA_REITINGS = 'CC'  THEN 0.03
            WHEN KREDITA_REITINGS = 'C'   THEN 0.02
            WHEN KREDITA_REITINGS = 'D'   THEN 0.01
            ELSE 0.0
        END
    INTO v_atlaide
    FROM EMITENTI_1
    WHERE EMITENTA_ID = v_emitenta_id;

    v_kupona_maksajums := v_nomin_vert * v_kupons;
    v_gadi_lidz_terminam := TRUNC(MONTHS_BETWEEN(v_dzesanas_datums, SYSDATE) / 12);

    FOR i_year IN 1 .. v_gadi_lidz_terminam LOOP
        v_tagad_kupona_vert := v_tagad_kupona_vert + 
            (v_kupona_maksajums / POWER(1 + v_atlaide, i_year));
    END LOOP;

    v_tagad_nomin_vert := v_nomin_vert / POWER(1 + v_atlaide, v_gadi_lidz_terminam);
    v_obligacijas_vert := v_tagad_kupona_vert + v_tagad_nomin_vert;
    RETURN v_obligacijas_vert;
END;
/


CREATE OR REPLACE TYPE BODY Obligacija AS 
    MEMBER FUNCTION CalculateBondPrice_2 RETURN NUMBER IS
        v_atlaide NUMBER(15, 2);
        v_kupona_maksajums NUMBER(15, 2);
        v_gadi_lidz_terminam NUMBER;
        v_tagad_kupona_vert NUMBER(15, 2) := 0;
        v_tagad_nomin_vert NUMBER(15, 2);
        v_obligacijas_vert NUMBER(15, 2) := 0;
    BEGIN
        SELECT CASE
                    WHEN i.KREDITA_REITINGS = 'AAA' THEN 0.1
                    WHEN i.KREDITA_REITINGS = 'AA' THEN 0.09
                    WHEN i.KREDITA_REITINGS = 'A' THEN 0.08
                    WHEN i.KREDITA_REITINGS = 'BBB' THEN 0.07
                    WHEN i.KREDITA_REITINGS = 'BB' THEN 0.06
                    WHEN i.KREDITA_REITINGS = 'B' THEN 0.05
                    WHEN i.KREDITA_REITINGS = 'CCC' THEN 0.04
                    WHEN i.KREDITA_REITINGS = 'CC' THEN 0.03
                    WHEN i.KREDITA_REITINGS = 'C' THEN 0.02
                    WHEN i.KREDITA_REITINGS = 'D' THEN 0.01
                    ELSE 0.0
               END
        INTO v_atlaide
        FROM EMITENTI_2 i
        WHERE REF(i) = self.EMITENTS_REF;
        
        v_kupona_maksajums := self.NOMINALA_VERTIBA * self.KUPONS;
        v_gadi_lidz_terminam := TRUNC(MONTHS_BETWEEN(self.DZESANAS_DATUMS, SYSDATE) / 12);
        
        FOR Year IN 1 .. v_gadi_lidz_terminam LOOP
            v_tagad_kupona_vert := v_tagad_kupona_vert + 
                (v_kupona_maksajums / POWER(1 + v_atlaide, Year));
        END LOOP;
        
        v_tagad_nomin_vert := self.NOMINALA_VERTIBA / POWER(1 + v_atlaide, v_gadi_lidz_terminam);
        v_obligacijas_vert := v_tagad_kupona_vert + v_tagad_nomin_vert;
        RETURN v_obligacijas_vert;
    END;
END;
/
