        In cadrul acestui workshop, ne propunem sa realizam o aplicatie de tip client-server(o clona de Twitter cu functionalitatile de baza 
    ale acestuia - creare cont, publicare twit, urmarire utilizatori, like, twit, comentarii). Partea de back-end este implementata
    in Erlang, iar pentru partea de front-end ne folosim de Angular si Bootstrap.
	    Pana acum, pe partea de Erlang, am utilizat biblioteca Mochiweb pentru crearea server-ului. Ne-am gandit sa stocam datele in 
    doua tabele: o tabela pentru conturi care contine id-urile utilizatorilor, username-urile, lista de urmaritori si de urmariti si o 
    tabela pentru twit-uri, cu campuri pentru username, mesaj, data postarii, likes si distribuiri. Am creat un record(account) pentru 
    datele utilizatorilor, un record(twit) pentru twit-uri si mai multe endpoint-uri pentru obtinerea datelor de la server("get-twits", 
    "get-accounts") si pentru postarea lor("post-twits", "post-accounts").
	    Pe partea de interfata cu utilizatorii, folosim Angular si Bootstrap. Pana acum, am impartit proiectul in mai multe componente si am implementat 
    componentele care se ocupa cu preluarea twit-urilor de la server("twit-item"), afisarea acestora("post-twit"), postarea de noi 
    twit-uri("twit-submit"), preluarea de la server si afisarea datelor personale ale utilizatorilor("user-info").
