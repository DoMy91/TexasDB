# TexasDB
Progetto per l'esame di Basi di Dati 

Si vuole realizzare un database per la gestione di un penitenziario del Texas, stato nel quale vige la pena di morte. Il penitenziario è composto da 3 sezioni (general population, administrative-segregation e death-row) classificate in base al livello di custodia dei detenuti ospitati.
Ogni sezione include N celle, identificate da un numero di cella univoco all’interno della rispettiva sezione di appartenenza, che hanno capienze differenti a seconda della sezione.
Tutte le sezioni devono essere sorvegliate 24/24h e si vuole tenere traccia di tutti i turni effettuati dagli agenti. Tali turni sono fissati e sono della durata di 6 ore ciascuno.
Al momento dell’immatricolazione del detenuto viene assegnato a quest’ultimo un numero di matricola che identifica univocamente tale immatricolazione e vengono registrate le sue informazioni, quali altezza, peso, tipo di condanna ricevuta, colore degli occhi, colore dei capelli e data d’immatricolazione.
Si vogliono memorizzare inoltre le informazioni relative all’occupazione delle celle da parte dei detenuti nel tempo, in quanto sono possibili trasferimenti da una cella all’altra (es. isolamento in caso di cattiva condotta).
Inoltre per ogni detenuto si vogliono conoscere:
- Informazioni anagrafiche;
- Dettagli riguardanti il reato commesso e sulle vittime nel caso in cui ve ne siano. Un detenuto può aver commesso più reati e un reato può essere stato eseguito da più detenuti (Co-Defendants) e ci possono esser state o meno delle vittime. In tal caso, se il numero delle vittime è minore di 5 e sono noti i loro dati anagrafici, si memorizzeranno anche i loro dettagli, altrimenti si registrerà solo il numero totale delle vittime;
- Informazioni relative all’avvocato difensore. Il carcere mette a disposizione dei detenuti un’elenco di avvocati da cui scegliere nel caso in cui il detenuto non ne abbia uno proprio;
- Storia dei colloqui effettuati.
Siccome nel carcere vengono eseguite le esecuzioni per i condannati alla pena capitale, si vuole tener traccia di tutte le esecuzioni programmate e di quelle che sono già state eseguite, quest’ultime identificate da un numero univoco di esecuzione. Ogni esecuzione dovrà avvenire in presenza di testimoni le cui informazioni anagrafiche dovranno essere registrate. Un’esecuzione prevista può anche essere rinviata più volte prima che venga eseguita o addirittura essere annullata e convertita in ergastolo per il detenuto.
