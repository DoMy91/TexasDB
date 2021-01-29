/*Questo trigger si occupa di prelevare i dati inseriti nella tabella globale temporanea tt1 dal trigger
t_registration1 e inserisce il detenuto nella cella opportuna.Inoltre il trigger si attiva anche in
caso di update del campo release_date della relazione registration,che segna la fine della
permanenza in carcere del detenuto.Viene quindi liberato il posto della cella che occupava
(mediante l’update di end_date sulla relazione PLACED) e vengono cancellate tutte le tuple
relative a tale matricola relativamente agli spostamenti di cella,ai colloqui e ai periodi di tutela
degli avvocati.*/

CREATE OR REPLACE TRIGGER T_REGISTRATION2
AFTER INSERT OR UPDATE OF RELEASE_DATE ON REGISTRATION
FOR EACH ROW
DECLARE
	ROW_TT1 TT1%ROWTYPE;
BEGIN
	IF INSERTING THEN
		SELECT * INTO ROW_TT1 FROM TT1
		WHERE REG_NUM=:NEW.REG_NUMBER;
		INSERT INTO PLACED VALUES(:NEW.REG_NUMBER,ROW_TT1.CLH,ROW_TT1.CELL_N,:NEW.DATE_REC,NULL);
	END IF;
	IF UPDATING THEN
		IF :OLD.RELEASE_DATE IS NULL THEN
			UPDATE PLACED SET END_DATE=:NEW.RELEASE_DATE
			WHERE REG_NUM=:NEW.REG_NUMBER AND END_DATE IS NULL;
			DELETE FROM PLACED WHERE REG_NUM=:NEW.REG_NUMBER;
			DELETE FROM VISIT WHERE REG_NUM=:NEW.REG_NUMBER;
			DELETE FROM PROTECT WHERE REG_NUM=:NEW.REG_NUMBER;
		END IF;
	END IF;
END;