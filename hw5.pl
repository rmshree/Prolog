/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/
% Part 1

year_1953_1996_novels(X):-
	novel(X,Y),
	isMember(Y, [1953,1996]).

period_1800_1900_novels(X):-
	novel(X,Y), 
	between(1800, 1900,Y).
	
lotr_fans(X):-
	fan(X,Y), 
	isMember(the_lord_of_the_rings,Y).

author_names(X):-
    setof(X, tt(X), Answers), 
    member(X,Answers).
    
tt(X):-
	author(X,Ys), 
	member(E,Ys), 
	fan(chandler,Xs), 
	member(E,Xs).
    
fans_names(X):-
	fan(X,Ys),
	member(E,Ys),
	author(brandon_sanderson, Xs),
	member(E,Xs).

mutual_novels(X):-
	ab(X),
	ab(X),
	ab(X).

ab(X):-
	fan(ross,A),
	fan(monica,B),
	member(X,A),
	member(X,B).

ab(X):-
	fan(ross,A),
	fan(phoebe,C),
	member(X,A),
	member(X,C).

ab(X):-
	fan(phoebe,C),
	fan(monica,B),
	member(X,C),
	member(X,B).

% Part 2

%isMember(X,Y) says that element X is a member of set Y

isMember(H,[H | _]) :- !.
isMember(H,[_ | T]) :- isMember(H,T).

%isIntersection(X,Y,Z) says that the intersection of X and Y is Z

isIntersection([ ], X, [ ]).
isIntersection([X|R], Y, [X|Z]) :- 
isMember(X, Y), !, isIntersection(R, Y, Z).

isIntersection([X|R], Y, Z) :- isIntersection(R, Y, Z).

%isUnion(X,Y,Z) says that the union of X and Y is Z

isUnion([],X,X).
   isUnion([X|R],Y,Z) :- 
        isMember(X,Y), !, 
        isUnion(R,Y,Z).
   isUnion([X|R],Y,[X|Z]) :- 
        isUnion(R,Y,Z).

%isEqual(X,Y) says that the sets X and Y are equal

isEqual([], []).
isEqual([X|Xs], Ys) :-
  select(X, Ys, Zs),
  isEqual(Xs, Zs).
  
%powerSet(X,Y) says that the powerset of X is Y.
 
powerSet(Es, Uss) :-
   list_all(Es, [[]], Uss).

lists([]      , _) --> [].
lists([Es|Ess], E) --> [[E|Es]], lists(Ess, E).

list_all([]    , Uss , Uss).
list_all([E|Es], Uss0, Uss) :-
   list_all(Es, Uss0, Uss1),
   phrase(lists(Uss1,E), Uss, Uss1). 

% Part 3

opposite(left, right).
opposite(right, left).

unsafe(state(A, B, B, _)) :- opposite(A, B).
unsafe(state(A, _, C, C)) :- opposite(A, C).

safe(A) :- \+ unsafe(A).

solve:-
    go(state(left, left, left, left), state(right, right, right, right)).

go(A, C):-
    stack(A, [], Stack),
    path(A, C, Stack).


path(A, A, Stack):-
    nl,
    print_stack(Stack).

path(A, C, Current):-
    move(A, B),
    \+ member(B, Current),
    stack(B, Current, Next),
    path(B, C, Next).

move(A, B):-
    A == B -> fail; % No possible safe movements from last move
    arc(A, B),
    safe(B).

% Possible arcs you can take
arc(state(A, A, G, C), state(B, B, G, C)):- opposite(A, B). 
arc(state(A, W, A, C), state(B, W, B, C)):- opposite(A, B). 
arc(state(A, W, G, A), state(B, W, G, B)):- opposite(A, B). 
arc(state(A, W, G, C), state(B, W, G, C)):- opposite(A, B). 

% Methods
stack(H, T, [H|T]).

print_stack([]).
print_stack(S):-
    stack(H, T, S),
    print_stack(T),
    write(H), nl.
