-- 1. VARIANTA TESTS

DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    dummy_price NUMBER;
BEGIN
    start_time := SYSTIMESTAMP;

    FOR bond_row IN (
        SELECT OBLIGACIJAS_ID FROM OBLIGACIJAS_1
    ) LOOP
        dummy_price := CalculateBondPrice_1(bond_row.OBLIGACIJAS_ID);
    END LOOP;

    end_time := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Laiks: ' || (end_time - start_time) || ' sekundes');
END;
/


-- 2. VARIANTA TESTS
DECLARE
    bond Obligacija;
    bondPrice NUMBER;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN
    start_time := SYSTIMESTAMP;

    FOR bond_record IN (SELECT OBLIGACIJAS_ID, NOMINALA_VERTIBA, KUPONS, DZESANAS_DATUMS, EMITENTS_REF 
                        FROM OBLIGACIJAS_2) LOOP
        
        bond := Obligacija(bond_record.OBLIGACIJAS_ID, bond_record.NOMINALA_VERTIBA, bond_record.KUPONS, bond_record.DZESANAS_DATUMS, bond_record.EMITENTS_REF);
        bondPrice := bond.CalculateBondPrice_2;
    END LOOP;

    end_time := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Laiks: ' || (end_time - start_time) || ' sekundes');
END;
/