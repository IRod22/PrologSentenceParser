concat_space(T1, T2, T3) :- atom_concat(T1, T4, S1), atom_concat(S1, T2, T3), T4 = ' '.
concat_space(T1, T2, T3) :- T4 = ' ', atom_concat(S1, T2, T3), atom_concat(T1, T4, S1).
with_period(T1, T2) :- atom_concat(T1, '.', T2).

is(noun(chef)).
is(det(the)).
is(det(a)).
is(pronoun(he)).
is(pronoun(she)).
is(pronoun(it)).
is(verb(is)).

pg(noun(N), Text) :- is(noun(Text)), N = n(Text).
pg(det(D), Text) :- is(det(Text)), D = det(Text).
pg(verb(V), Text) :- is(verb(Text)), V = v(Text).
pg(noun_phrase(NP), Text) :- pg(noun(NP), Text).
pg(noun_phrase(NP), Text) :- concat_space(T1, T2, Text),
    pg(det(D), T1),
    pg(noun(N), T2),
    NP = np(D, N).
pg(noun_phrase(NP), Text) :- NP = np(D, N),
    pg(det(D), T1),
    pg(noun(N), T2),
    concat_space(T1, T2, Text).
pg(verb_phrase(VP), Text) :- pg(verb(VP), Text).
pg(verb_phrase(VP), Text) :- concat_space(T1, T2, Text),
    pg(noun_phrase(NP), T2),
    pg(verb(V), T1),
    VP = vp(V, NP).
pg(verb_phrase(VP), Text) :- VP = vp(V, NP),
    pg(noun_phrase(NP), T2),
    pg(verb(V), T1),
    concat_space(T1, T2, Text).
pg(sentence(S), Text) :- with_period(T, Text),
    concat_space(T1, T2, T),
    pg(noun_phrase(NP), T1),
    pg(verb_phrase(VP), T2),
    S = s(NP, VP).
pg(sentence(S), Text) :- S = s(NP, VP),
    pg(noun_phrase(NP), T1),
    pg(verb_phrase(VP), T2),
    concat_space(T1, T2, T),
    with_period(T, Text).