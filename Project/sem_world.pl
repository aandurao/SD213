/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/

character('Yara').
character('Theon').
character('Balon').
character('Melisandre').

character('Matthos_Seaworth').
character('Davos_Seaworth').
character('Stanis').
character('Robert').
character('Renly').
character('Loras').
character('Margaery').
character('Cersei').
character('Brienne_of_Tarth').
character('Eddard').
character('Catelyn').
character('Sansa').
character('Arya').
character('Bran').
character('Robb').
character('Rickon').
character('Tyrion').
character('Daenerys').
character('Viserys').
character('Khal_Drogo').
character('Jon').
character('Lysa').
character('Robin').
character('Tommen').
character('Myrcella').
character('Joeffrey').
character('Bronn').


woman('Yara').
woman('Melisandre').
woman('Margaery').
woman('Cersei').
woman('Brienne_of_Tarth').
woman('Catelyn').
woman('Sansa').
woman('Arya').
woman('Myrcella').
woman('Daenerys').
woman('Lysa').
man('Robin').
man('Bronn').
man('Joeffrey').
man('Tommen').
man('Viserys').
man('Jon').
man('Khal_Drogo').
man('Bran').
man('Robb').
man('Rickon').
man('Matthos_Seaworth').
man('Davos_Seaworth').
man('Stanis').
man('Robert').
man('Renly').
man('Loras').
man('Theon').
man('Balon').
man('Eddard').
man('Tyrion').

blonde('Melisandre').
blonde('Cersei').

old('Eddard').

king('Robert').

lannister('Tyrion').
lannister('Cersei').
lannister('Tommen').
lannister('Myrcella').
lannister('Joeffrey').

targaryen('Daenerys').
targaryen('Viserys').

stark('Eddard').
stark('Sansa').
stark('Arya').
stark('Robb').
stark('Bran').
stark('Rickon').

tully('Catelyn').

tyrrel('Loras').
tyrrel('Margaery').

baratheon('Renly').

greyjoy('Balon').
greyjoy('Yara').
greyjoy('Theon').

arryn('Jon').
arryn('Lysa').
arryn('Robin').


lovers('Cersei', 'Robert') :- !, writeln('Yes they do !\n').
lovers('Stanis', 'Melisandre') :- !, writeln('Yes they do !\n').
lovers('Renly', 'Margaery') :- !, writeln('Yes they do !\n').
lovers('Catelyn', 'Eddard') :- !, writeln('Yes they do !\n').
lovers('Daenerys', 'Khal_Drogo') :- !, writeln('Yes they do !\n').
lovers('Jon', 'Lysa') :- !, writeln('Yes they do !\n').
love(X, Y) :- write('\n\t===> No, '), write(X), write(' and '), write(Y), writeln(' don\'t love each other!\n').

defend('Robb', 'Theon').
defend('Jon', 'Eddard').
defend('Eddard', 'Robert').
defend('Brienne_of_Tarth', 'Renly').
defend('Davos_Seaworth', 'Stanis').
defend('Bronn', 'Tyrion').

kills('Cersei', 'Loras').
kills('Cersei', 'Margaery').
kills('Joeffrey', 'Eddard').
kills('Khal_Drogo', 'Viserys').
kills('Stanis', 'Renly').
kilss('Daenerys', 'Khal_Drogo').

parent('Balon', 'Yara').
parent('Balon', 'Theon').
parent('Eddard', 'Sansa').
parent('Eddard', 'Arya').
parent('Eddard', 'Bran').
parent('Eddard', 'Robb').
parent('Eddard', 'Rickon').
parent('Jon', 'Robin').
parent('Lysa', 'Robin').
parent('Cersei', 'Tommen').
parent('Cersei', 'Joeffrey').
parent('Cersei', 'Myrcella').

spouse(X, Y) :-
	love(X, Y).