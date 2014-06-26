:- dynamic livro/3.
:- dynamic usuario/2.
:- dynamic emprestimo/2.

tabela(usuario(Nome,Id)).
tabela(livro(Titulo,Autor,Cod)).
tabela(emprestimo(Id,Cod)).

%%%%%%%%%%%%%%%%%%%Interface*%%%%%%%%%%%%%%%%%%%%%%%%%
menu :-	carregar, write('Opcao a - Cadastrar livro; '), nl, %ok
	write('Opcao b - Cadastrar usuário; ' ), nl, %rever
	write('Opcao c - Efetuar empréstimo; '), nl, %cuidado com cut
	write('Opcao d - Efetuar devolução;'), nl,  %aprender a remover
	write('Opcao e - Buscar livro;'), nl, %ok
	write('Opcao f - Buscar usuário;'), nl,
	write('Opcao g - Buscar empréstimo;'), nl,
	write('Opcao h - Remover usuário;'), nl,%aprender a remover
	write('Opcao i - Remover livro;'), nl, %aprender a remover
	read(Opcao),executa_m(Opcao), salva_arquivo.
executa_m(X):- (X=a,cadastra_livroi);
	     (X=b,cadastra_usuarioi);
	     (X=c,efetua_emprestimoi);
         (X=d,devolucaoi);
	     (X=e,busca_livroi);
	     (X=f,busca_usuarioi);
	     (X=g,busca_emprestimoi);
   	     (X=h,remove_usuarioi);
	     (X=i,remove_livroi).

get_titulo(T):- write('Insira o título do livro:'),nl,read(T).
get_autor(A):- write('Insira o nome do autor:'),nl,read(A).
get_nome(N):- write('Insira o nome do usuário:'),nl,read(N).
get_id(I):- write('Insira um identificador:'),nl,read(I).

%Opção A
cadastra_livroi:-get_titulo(T), get_autor(A),get_id(I), insert(livro,[T,A,I],L),write(L),nl,write('Livro adicionado a base de dados.'),nl.

%Opção B
cadastra_usuarioi:-get_nome(N),get_id(I),insert(usuario,[N,I],L),write(L),nl,write('Usuário adicionado a base de dados.'),nl.

%Opção C
efetua_emprestimoi:- get_id(I),get_titulo(T),insert(emprestimo,[I,T],L),write(L),nl,write('empréstimo efetuado.').

%Opção D
devolucaoi:- get_id(I),retract(emprestimo(I,_)), write('Livro devolvido').

%Opção E
busca_livroi:- write('Opcao a - Buscar por título; '), nl,
	       write('Opcao b - Buscar por autor; ' ),nl,
 	       write('Opcao c - Buscar por código; ' ),nl,
	       read(Opcao),executa_bl(Opcao).
executa_bl(X):- (X=a,busca_titulo);
	        (X=b,busca_autor);
		(X=c,busca_codigo).

busca_titulo:-get_titulo(T),busca_titulo(T,_,_,L1,L2),write('Titulo: '),write(T),nl,write('Lista dos autores e os respectivos códigos de cada exemplar encontrado: '),nl,write(L1),nl,write(L2),nl,nl.
busca_autor:-get_autor(A),busca_autor(_,A,_,L1,L2), write('Autor: '),write(T),nl,write('Lista dos títulos e os respectivos códigos de cada exemplar encontrado: '),nl,write(L1),nl,write(L2),nl,nl.
busca_codigo:-get_id(C),busca_codigo(_,_,C,L1,L2), write('Código: '),write(T),nl,write('Lista dos títulos e os respectivos autores de cada exemplar encontrado: '),nl,write(L1),nl,write(L2),nl,nl.

%Opção F
busca_usuarioi:- write('Opcao a - Buscar por nome; '), nl,
	       write('Opcao b - Buscar por id; ' ),nl,
	       read(Opcao),executa_bu(Opcao).
executa_bu(X):- (X=a,busca_nome);
	        (X=b,busca_id).

busca_nome:-get_nome(N),busca_nome(N,L1), write('Nome: '),write(N),nl,write('Lista dos IDs encontrados: '),nl,write(L1),nl,nl.
busca_id:-get_id(I),busca_id(I,L1), write('ID: '),write(N),nl,write('Lista dos nomes encontrados: '),nl,write(L1),nl,nl.

%Opção G
busca_emprestimoi:- write('Opcao a - Buscar por id de usuário; '), nl,
	       write('Opcao b - Buscar por código do livro; ' ),nl,
	       read(Opcao),executa_be(Opcao).
executa_be(X):- (X=a,busca_emp_idi);
	        (X=b,busca_emp_codi).
busca_emp_idi:-get_id(I),busca_emp_id(I,L),write('Id do usuário: '), write(I),nl,write('Código dos livros emprestados: '),write(L).
busca_emp_codi:- get_id(I),busca_emp_cod(I,L),write('Código do livro: '), write(I),nl,write('Usuário com o livro: '),write(L).
%Opção H
remove_usuarioi:- write('Opcao a - Remover por id; '), nl,
	       write('Opcao b - Remover por nome; ' ),nl,
	       read(Opcao),executa_ru(Opcao).
executa_ru(X):- (X=a,remove_us_id);
	        (X=b,remove_us_nome).
	        
remove_us_id:-get_id(I),retract(usuario(_,I)), write('Livro deletado').
remove_us_nome:- get_nome(N),retract(usuario(N,_)), write('Livro deletado').
%Opção I
remove_livroi:- write('Opcao a - Remover por id; '), nl,
	       write('Opcao b - Remover por título; ' ),nl,
  	       write('Opcao c - Remover por autor; ' ),nl,
	       read(Opcao),executa_rel(Opcao).
executa_rel(X):- (X=a,remove_l_id);
	        (X=b,remove_l_titulo);
   	        (X=c,remove_l_autor).
	        
remove_l_id:- get_id(I),retract(livro(_,_,I)), write('Livro deletado').
remove_l_titulo:- get_autor(A),retract(livro(_,A,_)), write('Livro deletado').
remove_l_autor:- get_titulo(T),retract(livro(T,_,_)), write('Livro deletado').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
insert(Tab, Args, Termo):- Termo =.. [Tab|Args], assertz(Termo).

busca_livro(T,A,C,L1):-carregar,findall(livro(T,A,C),livro(T,A,C),L1).
busca_usuario(N,I,L1):-carregar,findall(usuario(N,I),usuario(N,I),L1).
busca_emp(I,C,L1):-carregar,findall(emprestimo(I,C),emprestimo(I,C),L1).
carregar:-
	open('ttt.txt', append, S), write(S,''),close(S),
	['ttt.txt'].

salva_arquivo :-
	tell('ttt.txt'),
	listing(livro),
	listing(emprestimo),
	listing(usuario), 
	told.
