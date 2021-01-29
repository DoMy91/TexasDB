/*Questo trigger si attiva in seguito all’inserimento di un’esecuzione eseguita,andando ad impostare il
campo release_date relativo al detenuto giustiziato al valore della data d’esecuzione.Tale azione
inneschera’ il trigger T_Registration2 che effettuera’ la cancellazione delle tuple nel DB relative al
detenuto giustiziato e la liberazione del posto da lui occupato in precedenza.*/

CREATE OR REPLACE TRIGGER T_EXECUTED
AFTER INSERT ON EXECUTED_EXEC
FOR EACH ROW
DECLARE
	ROW_SCHED SCHED_EXEC%ROWTYPE;
BEGIN
	SELECT * INTO ROW_SCHED FROM SCHED_EXEC
	WHERE SCHED_EXEC_ID=:NEW.SCHED_EXEC_ID;
	UPDATE REGISTRATION SET RELEASE_DATE=ROW_SCHED.DATE_EXEC
	WHERE REG_NUMBER=ROW_SCHED.REG_NUM;
END;	

