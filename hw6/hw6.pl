
/*** Exercise 1 ***/

/* Fact Database */
redefine_system_predicate(when).
when(275,10).
when(261,12).
when(381,11).
when(398,12).
when(399,12).
where(275,owen102).
where(261,dear118).
where(381,cov216).
where(398,dear118).
where(399,cov216).
enroll(mary,275).
enroll(john,275).
enroll(mary,261).
enroll(john,381).
enroll(jim,399).

/* Part (a) - schedule[3] gives classrooms and times of their classes (student, location, time) */
schedule(Name,Place,Time) :- enroll(Name,Class), where(Class,Place), when(Class,Time).

/* Part (b) - usage[2] gives all times a classroom is used (location, time) */
usage(Place,Time) :- where(Class,Place), when(Class,Time).

/* Part (c) - conflict[2] computes if two classes are assigned to same place at same time (Class, Class) */
conflict(Class1,Class2) :- where(Class1,P), where(Class2,P), when(Class1,T), when(Class2,T), Class1 \= Class2.

/* Part (d) - meet[2] checks if pair of students have class in same room at same time or have back-to-back classes, ignoring conflicting classes (name1, name2) */
meet(Student1,Student2) :- schedule(Student1,P,T), schedule(Student2,P,T), Student1 \= Student2.
meet(Student1,Student2) :- schedule(Student1,P,T1), schedule(Student2,P,T2), T1 =:= T2-1, Student1 \= Student2.


/*** Exercise 2 ***/

/* Part (a) - rdup[2] removes duplicates from an ordered list L, binding result to M (L,M) */
rdup(L,M) :- L=[], M=[].
rdup(L,M) :- append(RemainingL, [LastL], L), rdup(RemainingL, RecursRes), member(LastL, RecursRes), M=RecursRes.
rdup(L,M) :- append(RemainingL, [LastL], L), rdup(RemainingL, RecursRes), not(member(LastL, RecursRes)), append(RecursRes, [LastL], M).

/* Part (b) - flat[2] binds to F the flat list of all elements in L (L,F) */
flat(L,F) :- F=L. /*dummy*/
/* flat([1,[1,2],[2]], [1,1,2,2]). => true */

/* Part (c) - project[3] selects elements from list L by positions in list I and collects them in a result list R (I,L,R) */
project(I,L,R) :- I=I. /*dummy*/

