/*La procedura change_sentence viene utilizzata per cambiare la condanna di un detenuto
immatricolato. Sono ammessi tutti i cambi di sentenza,eccetto i seguenti:[DRW=>STD] e
[LFT=>STD].
I cambi di sentenza [STD=>DRW],[LFT=>DRW] e [DRW=>LFT] causano anche uno
spostamento di cella del detenuto (a differenza del cambio [STD=>LFT]),oltre all'aggiornamento
del campo sentence nella tabella registration.Nel caso in cui venga annullata la sentenza di morte
di un detenuto e convertita quindi in ergastolo (LFT) viene anche cancellata l'esecuzione prevista
(se presente) per tale detenuto.*/ 

CREATE OR REPLACE PROCEDURE CHANGE_SENTENCE(REG_NO NUMBER,NEW_SENTENCE VARCHAR2,NEW_SENTENCE_DATE DATE) IS
 OLD_SENTENCE CHAR(3);
 U_NEW_SENTENCE CHAR(3);
 ROW_PLACED PLACED%ROWTYPE;
 EXC1 EXCEPTION;
 EXC2 EXCEPTION;
 CLEVEL CHAR(3);
 FREE_CELL NUMBER;
 BEGIN
    U_NEW_SENTENCE:=UPPER(NEW_SENTENCE);
    SELECT SENTENCE INTO OLD_SENTENCE FROM OFFENDER_IN
    WHERE REG_NUMBER=REG_NO;
    IF (OLD_SENTENCE=U_NEW_SENTENCE) THEN
            RAISE EXC1;
    END IF;
    IF(OLD_SENTENCE='STD' OR (OLD_SENTENCE='LFT' AND U_NEW_SENTENCE='DRW') OR (OLD_SENTENCE='DRW' AND U_NEW_SENTENCE='LFT')) THEN
         IF(NOT(OLD_SENTENCE='STD' AND U_NEW_SENTENCE='LFT')) THEN
		IF U_NEW_SENTENCE='DRW' THEN
                   	CLEVEL:='DRW';
            	ELSE
                    	CLEVEL:='STD';
			DELETE FROM SCHED_EXEC WHERE REG_NUM=REG_NO;
            	END IF;
            	FREE_CELL:=GET_FREE_CELL(CLEVEL);
            	UPDATE PLACED SET END_DATE=NEW_SENTENCE_DATE WHERE(REG_NUM=REG_NO AND END_DATE IS NULL);
            	INSERT INTO PLACED VALUES(REG_NO,CLEVEL,FREE_CELL,NEW_SENTENCE_DATE,NULL);
	END IF;
        UPDATE REGISTRATION SET SENTENCE=U_NEW_SENTENCE WHERE REG_NUMBER=REG_NO;
	COMMIT;
    	ELSE
        	RAISE EXC2;
    END IF;
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,'OFFENDER NOT IN PRISON ACTUALLY');
    WHEN EXC1 THEN
    RAISE_APPLICATION_ERROR(-20002,'SENTENCE IS ALREADY '||NEW_SENTENCE);
    WHEN EXC2 THEN
    RAISE_APPLICATION_ERROR(-20003,'IMPOSSIBLE FROM '||OLD_SENTENCE||' TO '||NEW_SENTENCE);
 END;