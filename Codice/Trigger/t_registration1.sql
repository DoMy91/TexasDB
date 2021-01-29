/*Questo trigger si attiva prima dell'inserimento di una tupla nella relazione REGISTRATION, che
contiene i dati delle immatricolazioni dei vari detenuti.Innanzitutto il trigger controlla che il
detenuto che si sta tentando di immatricolare non si trovi gia' in carcere,esaminando la vista
OFFENDER_IN contenente i dati relativi alle immatricolazioni dei detenuti che si trovano
attualmente presso il carcere.In seguito il trigger controlla che la data di immatricolazione del
detenuto sia successiva a tutte le date di uscita di quel detenuto dal carcere,se presenti,in modo da
evitare la sovrapposizione di periodi di immatricolazione diversi relativi ad uno stesso
detenuto.Infine viene ricercata una cella libera nella sezione appropriata (se disponibile) in grado di
ospitare il detenuto,mediante la function get_free_cell().Di default un detenuto condannato
alla pena capitale viene inserito nella sezione 'DRW' altrimenti viene inserito nella sezione
'STD'.Vengono poi inseriti in una tabella globale temporanea la matricola e la cella destinata ad
ospitare il detenuto.Tali dati verranno utilizzati dal trigger t_registration2 che si attivera' in
seguito all'inserimento della tupla nella relazione registration e che inserira' il detenuto nella
rispettiva cella.Viene utilizzata tale memoria globale tt1 come area di scambio tra i due
trigger,per evitare che il trigger t_registration2 debba nuovamente ricalcolare il numero della
cella che dovra' ospitare il detenuto.*/

CREATE OR REPLACE TRIGGER T_REGISTRATION1
BEFORE INSERT ON REGISTRATION
FOR EACH ROW
DECLARE
	CLEVEL CHAR(3);
	FREE_CELL NUMBER;
	CNT1 NUMBER;
	EXC1 EXCEPTION;
   	EXC2 EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO CNT1 FROM OFFENDER_IN WHERE OFF_SSN=:NEW.OFF_SSN;
	IF CNT1>0 THEN
		RAISE EXC1;
	END IF;
	SELECT COUNT(*) INTO CNT1 FROM REGISTRATION
	WHERE OFF_SSN=:NEW.OFF_SSN AND RELEASE_DATE>:NEW.DATE_REC;
	IF CNT1>0 THEN
		RAISE EXC2;
	END IF;
	IF(:NEW.SENTENCE <>'DRW') THEN
		CLEVEL:='STD';
	ELSE
		CLEVEL:='DRW';
	END IF;
	FREE_CELL:=GET_FREE_CELL(CLEVEL);
	:NEW.REG_NUMBER:=MAT.NEXTVAL;
	INSERT INTO TT1 VALUES(:NEW.REG_NUMBER,CLEVEL,FREE_CELL);
EXCEPTION
	WHEN EXC1 THEN
	RAISE_APPLICATION_ERROR(-20001,'OFFENDER '||:NEW.OFF_SSN||' ALREADY IN PRISON');
	WHEN EXC2 THEN
	RAISE_APPLICATION_ERROR(-20001,'NOT VALID DATE');
END;


CREATE GLOBAL TEMPORARY TABLE TT1(
REG_NUM NUMBER(7,0),
CLH VARCHAR2(4),
CELL_N NUMBER(4,0));