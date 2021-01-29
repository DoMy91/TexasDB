/*La procedura change_cell si occupa dello spostamento di cella di un detenuto.Riceve in input la
matricola del detenuto,la sezione,il numero della cella nella quale deve essere spostato e la data
dello spostamento.Verifica se il detenuto si trova in carcere,evita che un detenuto non condannato a
morte venga spostato in una cella appartenente alla sezione death-row e viceversa e controlla che la
cella di destinazione sia diversa dalla cella nella quale si trova il detenuto.Infine,se la cella di
destinazione ha posti liberi,aggiorna la relazione placed per riportare lo spostamento avvenuto.*/

CREATE OR REPLACE PROCEDURE CHANGE_CELL(REG_NO NUMBER,CUSTODY_LEV VARCHAR2,CELL_N NUMBER,N_DATE DATE) IS
SENTENCE_TYPE CHAR(3);
ROW_PLACED PLACED%ROWTYPE;
U_CUSTODY_LEV VARCHAR2(4);
EXC1 EXCEPTION;
EXC2 EXCEPTION;
EXC3 EXCEPTION;
BEGIN
	U_CUSTODY_LEV:=UPPER(CUSTODY_LEV);
	SELECT SENTENCE INTO SENTENCE_TYPE FROM OFFENDER_IN
	WHERE REG_NUMBER=REG_NO;
	IF(SENTENCE_TYPE='DRW' AND U_CUSTODY_LEV<>'DRW')
	THEN
		RAISE EXC1;
	ELSIF(SENTENCE_TYPE<>'DRW' AND U_CUSTODY_LEV='DRW')
	THEN
		RAISE EXC2;
	END IF;
	SELECT * INTO ROW_PLACED FROM PLACED
	WHERE REG_NUM=REG_NO AND END_DATE IS NULL;
	IF(ROW_PLACED.CLH=U_CUSTODY_LEV AND ROW_PLACED.CELL_NUM=CELL_N)
	THEN
		RAISE EXC3;
	END IF;
	UPDATE PLACED SET END_DATE=N_DATE WHERE(REG_NUM=REG_NO AND END_DATE IS NULL);
	INSERT INTO PLACED VALUES(REG_NO,U_CUSTODY_LEV,CELL_N,N_DATE,NULL);
	COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	RAISE_APPLICATION_ERROR(-20001,'OFFENDER NOT IN PRISON ACTUALLY');
	WHEN EXC1 THEN
	RAISE_APPLICATION_ERROR(-20001,REG_NO ||' SHOULD BE IN DRW SECTION');
	WHEN EXC2 THEN
	RAISE_APPLICATION_ERROR(-20002,REG_NO ||' SHOULD NOT BE IN DRW SECTION');
	WHEN EXC3 THEN
	RAISE_APPLICATION_ERROR(-20003,REG_NO ||' ALREADY BEEN IN THIS CELL');
END;