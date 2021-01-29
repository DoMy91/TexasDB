/*Questo trigger si attiva nel momento in cui viene aggiornato il numero di posti liberi di una
cella,ossia nel momento in cui si prova ad inserire un detenuto in tale cella.Il trigger controlla che
vi sia almeno un posto libero per ospitare il detenuto e che una cella non contenga piu' detenuti di
quella che sia la sua capienza (4 posti per la sez standard e 1 posto per adms e drw).*/

CREATE OR REPLACE TRIGGER T_CELL
BEFORE UPDATE OF FREE_SEATS ON CELL
FOR EACH ROW
DECLARE
	EXC1 EXCEPTION;
	EXC2 EXCEPTION;
BEGIN
 	IF(:NEW.FREE_SEATS<0) THEN
    		RAISE EXC1;
 	END IF;
 	IF(((:NEW.CLH='DRW' OR :NEW.CLH='ADMS') AND :NEW.FREE_SEATS>1) OR (:NEW.CLH='STD' AND :NEW.FREE_SEATS>4)) THEN
    		RAISE EXC2;
 	END IF;
EXCEPTION
 	WHEN EXC1 THEN
 	RAISE_APPLICATION_ERROR(-20010,'NO FREE SEATS IN CELL '||:NEW.CLH||' '||:NEW.CELL_NUM);
 	WHEN EXC2 THEN
 	RAISE_APPLICATION_ERROR(-20011,'TOO MANY FREE SEATS IN CELL '||:NEW.CLH||' '||:NEW.CELL_NUM);
END;