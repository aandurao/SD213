/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/




boy(boy).
girl(girl).
nice(_).

% dream(_, _) :- writeln('\n***** Continue to dream! *****\n').

% If X is a girl, then it is 'animate'
% animate(X) :- girl(X).

% Add contraints on the execution of talk: X and Y should both be animate
% talk(X,Y,_Z) :- <condition on X>, <<condition on Y>.

