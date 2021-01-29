/*Il trigger si attiva ogni qualvolta si inserisce o si aggiorna una tupla nella relazione placed,che ha lo
scopo di memorizzare i periodi di permanenza nelle celle dei vari detenuti.Nel momento in cui
viene inserita una tupla il trigger andra' a decrementare il numero di posti liberi della cella
inserita.L'aggiornamento della data di fine invece segna che il detenuto non si trova piu' in tale
cella e viene quindi incrementato di 1 il numero di posti liberi della cella.Viene inoltre effettuato il
troncamento delle date in modo da garantire il rispetto della primary key(reg_num,start_date) in
quanto un detenuto non puo' cambiare cella piu' volte in uno stesso giorno.*/

CREATE OR REPLACE TRIGGER T_PLACED
BEFORE INSERT OR UPDATE OF END_DATE ON PLACED
FOR EACH ROW
BEGIN
IF INSERTING THEN
	:NEW.START_DATE:=TRUNC(:NEW.START_DATE);
	UPDATE CELL SET FREE_SEATS=FREE_SEATS-1 
	WHERE CLH=:NEW.CLH AND CELL_NUM=:NEW.CELL_NUM;
	DBMS_OUTPUT.PUT_LINE('OFFENDER N.'||:NEW.REG_NUM||' PLACED IN CELL:'||:NEW.CLH||' '||:NEW.CELL_NUM);
END IF;
IF UPDATING THEN
	:NEW.END_DATE:=TRUNC(:NEW.END_DATE);
	IF(:OLD.END_DATE IS NULL)
	THEN
		UPDATE CELL SET FREE_SEATS=FREE_SEATS+1 
		WHERE CLH=:NEW.CLH AND CELL_NUM=:NEW.CELL_NUM;
		DBMS_OUTPUT.PUT_LINE('OFFENDER N.'||:NEW.REG_NUM||' REMOVED FROM CELL:'||:NEW.CLH||' '||:NEW.CELL_NUM);
	END IF;
END IF;
END;