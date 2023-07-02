/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2022                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/



% ----------------------
% Phrase structure rules
% ----------------------

% Phrases have three arguments:
% xp(FXP, PXP, TXP)
% FXP is the feature structure, e.g. [gloss:love,  num:plur,pers:3,subj:dp(_),  cpl:[dp(_)]]
% 	(gloss indicates a string used for output and trace)
% PXP is the predicative structure, e.g. love(_,_)
% TXP is the tree structure, used for display, e.g. v(love)


% att	is used to access to slots in feature structures
% link	implements semantic linking


% sentence
s(FVP,PS,TS) --> dp(FDP,PDP,TDP), vp(FVP,PVP,TVP), {	% determiner phrase + verb phrase
		att(FVP, subj, dp(FDP)),
		att(FDP, num, Num), 	% checking for number agreement 
		att(FVP, num, Num),		% between subject and verb
		link(1, PVP, PDP, PS),
		TS  = s(TDP,TVP) }.

s(FVP,PVP,TS) --> [it], vp(FVP,PVP,TVP), {	% impersonal verb  (it rains)
		att(FVP, subj, [it]),
		TS  = s(TVP) }.


% verb phrase
vp(FV,PV,TVP) --> v(FV,PV,TV), {			  % non transitive verb, eg. 'sleep'
		att(FV, cpl, []),
		TVP = vp(TV) }.

vp(FV,PVP,TVP) --> v(FV,PV,TV), dp(FDP,PDP,TDP), { % transitive verb, eg. 'love'
		att(FV, cpl, [dp(FDP)]),
		link(2, PV,PDP,PVP),
		TVP  = vp(TV,TDP) }.

vp(FV,PVP,TVP) --> v(FV,PV,TV), pp(FPP,PPP,TPP), { % transitive verb, indirect object: 'dream'
		att(FV, cpl, [pp(P)]),
		att(FPP, gloss, P),
		link(2, PV,PPP,PVP),
		TVP  = vp(TV,TPP) }.

vp(FV,PVP,TVP) --> v(FV,PV,TV), dp(FDP,PDP,TDP), dp(FDP2,PDP2,TDP2), { % ditransitive verb, eg. 'give'
		att(FV, cpl, [dp(FDP),dp(FDP2)]),
		link(_, PV,PDP,PVP),	% performs some variable unification
		link(_, PV,PDP2,PVP),	% performs some (other) variable unification
		TVP  = vp(TV, TDP, TDP2) }.

vp(FV,PVP,TVP) --> v(FV,PV,TV), pp(FPP,PPP,TPP), pp(FPP2,PPP2,TPP2), { % ditransitive verb, eg. 'talk'
    att(FV, cpl, [pp(P1),pp(P2)]),
    att(FPP, gloss, P1),
    att(FPP2, gloss, P2),
    link(2, PV,PPP,PVP),    % unifies 2nd variable    (thanks, Qingjie!)
    link(3, PV,PPP2,PVP),    % unifies 3rd variable
    TVP = vp(TV, TPP, TPP2) }.

vp(FV,PVP,TVP) --> v(FV,PV,TV), cp(FCP,PCP,TCP), { % verb + cp: eg. 'dreams', 'believes'...
		att(FV, cpl, [cp(P)]),
		att(FCP, gloss, P),
		link(_, PV,PCP,PVP),
		TVP  = vp(TV, TCP) }.

vp(FV,PA,TVP) --> v(FV,_PV,TV), adj(_FADJ,PA,TADJ), { % verb + adj: eg. 'is', 'looks', 'seems'...
		att(FV, cpl, [adj(_)]),
		TVP  = vp(TV, TADJ) }.


% noun phrases
dp(FDP,PPN,TDP) --> pn(FDP,PPN,TPN), {	% proper noun
		TDP = dp(TPN) }.

dp(FN,PNP,TDP) --> det(FDET,TDET), np(FN,PNP,TN), { % 'the woman'
		att(FDET, num, Num), 
		att(FN, num, Num),
		TDP = dp(TDET,TN) }.

dp(FN,PNP,TDP) --> np(FN,PNP,TN), {	% 'women'
		att(FN, num, plur), 
		TDP = dp(TN) }.


np(FN,PN,TNP) --> n(FN,PN,TN), {	% 'woman'
		TNP = np(TN) }.

np(FNP,PNP1,TNP) --> adj(_FADJ,PA,TADJ), np(FNP,PNP1,TNP1), {	% 'nice woman'
		link(_,PNP1,PA,_PNP),
		TNP = np(TADJ, TNP1) }.

np(FN,PNP,TNP) --> n(FN,PN,TN), pp(_FPP,PPP,TPP), {	% 'room of the woman'
		link(_,PN,PPP,PNP),
		TNP = np(TN, TPP) }.


% prepositional phrases
pp(FP, PDP,TPP) --> p(FP,TP), dp(_FDP,PDP,TDP), {
		TPP = pp(TP, TDP) }.


% subordinate clauses
cp(FC, PS,TCP) --> c(FC, TC), s(_FS, PS,TS), {
		TCP = cp(TC, TS) }.


% -------
% Lexicon
% -------
det([gloss:the, num:sing], det(the)) --> [the].
det([gloss:the, num:plur], det(the)) --> [the].
det([gloss:a,   num:sing], det(a))   --> [a].
det([gloss:all, num:plur], det(all)) --> [all].

n([gloss:child, num:sing], child(_), n(child)) --> [child].
n([gloss:child, num:plur], child(_), n(child)) --> [children].
n([gloss:game,  num:sing], game(_),  n(game))  --> [game].
n([gloss:game,  num:plur], game(_),  n(game))  --> [games].
n([gloss:woman,  num:sing], woman(_),  n(woman))  --> [woman].
n([gloss:woman,  num:plur], woman(_),  n(woman))  --> [women].
n([gloss:man,   num:sing], man(_),   n(man))   --> [man].
n([gloss:man,   num:plur], man(_),   n(man))   --> [men].
n([gloss:room,  num:sing], room(_),  n(room))  --> [room].
n([gloss:house, num:plur], house(_), n(house)) --> [house].
n([gloss:hall, num:plur],  hall(_),  n(hall))  --> [hall].
n([gloss:garden, num:plur],garden(_),n(garden)) --> [garden].

n([gloss:daughter, num:sing],daughter(_,_),n(daughter)) --> [daughter].
n([gloss:parent, num:sing],parent(_,_),n(parent)) --> [parent].
n([gloss:king, num:sing],king(_),n(king)) --> [king].
n([gloss:spouse, num:sing],spouse(_,_),n(spouse)) --> [spouse].

% proper nouns
pn([gloss:yara, num:sing], yara, pn(yara)) --> ['Yara'].
pn([gloss:theon,  num:sing], theon, pn(theon))   --> ['Theon'].
pn([gloss:balon, num:sing], balon, pn(balon)) --> ['Balon'].
pn([gloss:melisandre,  num:sing], melisandre, pn(melisandre))   --> ['Melisandre'].
pn([gloss:matthos_seaworth,  num:sing], matthos_seaworth, pn(matthos_seaworth))   --> ['Matthos_Seaworth'].
pn([gloss:davos_seaworth,  num:sing], davos_seaworth, pn(davos_seaworth))   --> ['Davos_Seaworth'].
pn([gloss:stanis,  num:sing], stanis, pn(stanis))   --> ['Stanis'].
pn([gloss:robert,  num:sing], robert, pn(robert))   --> ['Robert'].
pn([gloss:renly,  num:sing], renly, pn(renly))   --> ['Renly'].
pn([gloss:loras,  num:sing], loras, pn(loras))   --> ['Loras'].
pn([gloss:margaery,  num:sing], margaery, pn(margaery))   --> ['Margaery'].
pn([gloss:cersei,  num:sing], cersei, pn(cersei))   --> ['Cersei'].
pn([gloss:brienne_of_tarth,  num:sing], brienne_of_tarth, pn(brienne_of_tarth))   --> ['Brienne_of_Tarth'].
pn([gloss:eddard,  num:sing], eddard, pn(eddard))   --> ['Eddard'].
pn([gloss:catelyn,  num:sing], catelyn, pn(catelyn))   --> ['Catelyn'].
pn([gloss:sansa,  num:sing], sansa, pn(sansa))   --> ['Sansa'].
pn([gloss:arya,  num:sing], arya, pn(arya))   --> ['Arya'].
pn([gloss:bran,  num:sing], bran, pn(bran))   --> ['Bran'].
pn([gloss:robb,  num:sing], robb, pn(robb))   --> ['Robb'].
pn([gloss:rickon,  num:sing], rickon, pn(rickon))   --> ['Rickon'].
pn([gloss:tyrion,  num:sing], tyrion, pn(tyrion))   --> ['Tyrion'].
pn([gloss:daenerys,  num:sing], daenerys, pn(daenerys))   --> ['Daenerys'].
pn([gloss:viserys,  num:sing], viserys, pn(viserys))   --> ['Viserys'].
pn([gloss:khal_drogo,  num:sing], khal_drogo, pn(khal_drogo))   --> ['Khal_Drogo'].
pn([gloss:jon,  num:sing], jon, pn(jon))   --> ['Jon'].
pn([gloss:lysa,  num:sing], lysa, pn(lysa))   --> ['Lysa'].
pn([gloss:robin,  num:sing], robin, pn(robin))   --> ['Robin'].
pn([gloss:joeffrey,  num:sing], joeffrey, pn(joeffrey))   --> ['Joeffrey'].
pn([gloss:tommen,  num:sing], tommen, pn(tommen))   --> ['Tommen'].
pn([gloss:myrcella,  num:sing], myrcella, pn(myrcella))   --> ['Myrcella'].

% verbs
v([gloss:sleep,  num:sing,pers:3,subj:dp(_), cpl:[]], sleep(_), v(sleep)) --> [sleeps].
v([gloss:sleep,  num:plur,pers:3,subj:dp(_), cpl:[]], sleep(_), v(sleep)) --> [sleep].

v([gloss:play,  num:sing,pers:3,subj:dp(_),  cpl:[]], play(_), v(play)) --> [plays].
v([gloss:play,  num:plur,pers:3,subj:dp(_),  cpl:[]], play(_), v(play)) --> [play].

v([gloss:love,  num:sing,pers:3,subj:dp(_),  cpl:[dp(_)]], love(_,_), v(love)) --> [loves].
v([gloss:love,  num:plur,pers:3,subj:dp(_),  cpl:[dp(_)]], love(_,_), v(love)) --> [love].

v([gloss:defend,  num:sing,pers:3,subj:dp(_),  cpl:[dp(_)]], defend(_,_), v(defend)) --> [defends].
v([gloss:defend,  num:plur,pers:3,subj:dp(_),  cpl:[dp(_)]], defend(_,_), v(defend)) --> [defend].

v([gloss:kills,  num:sing,pers:3,subj:dp(_),  cpl:[dp(_)]], kills(_,_), v(kills)) --> [kills].
v([gloss:kills,  num:plur,pers:3,subj:dp(_),  cpl:[dp(_)]], kills(_,_), v(kills)) --> [kill].


v([gloss:dream,num:sing,pers:3,subj:dp(_),   cpl:[pp(of)]],   dream(_,_),   v(dream)) --> [dreams].
v([gloss:dream,num:plur,pers:3,subj:dp(_),   cpl:[pp(of)]],   dream(_,_),   v(dream)) --> [dream].
v([gloss:dream,num:sing,pers:3,subj:dp(_),   cpl:[cp(that)]], dream(_,_),   v(dream)) --> [dreams].
v([gloss:dream,num:plur,pers:3,subj:dp(_),   cpl:[cp(that)]], dream(_,_),   v(dream)) --> [dream].

v([gloss:believe,num:sing,pers:3,subj:dp(_), cpl:[cp(that)]], believe(_,_), v(believe)) --> [believes].
v([gloss:believe,num:plur,pers:3,subj:dp(_), cpl:[cp(that)]], believe(_,_), v(believe)) --> [believe].

v([gloss:give, num:sing,pers:3,subj:dp(_),   cpl:[dp(_),dp(_)]],give(_,_,_), v(give)) --> [gives].
v([gloss:give, num:plur,pers:3,subj:dp(_),   cpl:[dp(_),dp(_)]],give(_,_,_), v(give)) --> [give].

v([gloss:talk,num:sing,pers:3,subj:dp(_),    cpl:[pp(with)]], talk(_,_), v(talk)) --> [talks].
v([gloss:talk,num:plur,pers:3,subj:dp(_),    cpl:[pp(with)]], talk(_,_), v(talk)) --> [talk].
v([gloss:talk,num:sing,pers:3,subj:dp(_),    cpl:[pp(with), pp(about)]], talk(_,_,_), v(talk)) --> [talks].
v([gloss:talk,num:plur,pers:3,subj:dp(_),    cpl:[pp(with), pp(about)]], talk(_,_,_), v(talk)) --> [talk].


v([gloss:look,num:sing,pers:3,subj:dp(_), cpl:[adj(_)]], look, v(look)) --> [looks].
v([gloss:look,num:plur,pers:3,subj:dp(_), cpl:[adj(_)]], look, v(look)) --> [look].

v([gloss:be,num:sing,pers:3,subj:dp(_),   cpl:[adj(_)]], be, v(be)) --> [is].
v([gloss:be,num:plur,pers:3,subj:dp(_),   cpl:[adj(_)]], be, v(be)) --> [are].
v([gloss:be,num:sing,pers:3,subj:dp(_),   cpl:[pp(in)]], be, v(be)) --> [is].
v([gloss:be,num:plur,pers:3,subj:dp(_),   cpl:[pp(in)]], be, v(be)) --> [are].

v([gloss:rain,num:sing,pers:3, subj:[it],  cpl:[]], [rain], v(rain)) --> [rains].

% adj.
adj([gloss:nice],  nice(_),  adj(nice))  --> [nice].
adj([gloss:small], small(_), adj(small)) --> [small].
adj([gloss:large], large(_), adj(large)) --> [large].
adj([gloss:big],   big(_),   adj(big))	 --> [big].
adj([gloss:happy], happy(_), adj(happy)) --> [happy].
adj([gloss:quiet], quiet(_), adj(quiet)) --> [quiet].
adj([gloss:black], black(_), adj(black)) --> [black].
adj([gloss:white], white(_), adj(white)) --> [white].

adj([gloss:blonde], blonde(_), adj(blonde)) --> [blonde].
adj([gloss:old], old(_), adj(old)) --> [old].
adj([gloss:lannister], lannister(_), adj(lannister)) --> [lannister].
adj([gloss:stark], stark(_), adj(stark)) --> [stark].
adj([gloss:baratheon], baratheon(_), adj(baratheon)) --> [baratheon].
adj([gloss:tyrrel], tyrrel(_), adj(tyrrel)) --> [tyrrel].
adj([gloss:tully], tully(_), adj(tully)) --> [tully].
adj([gloss:greyjoy], greyjoy(_), adj(greyjoy)) --> [greyjoy].

% prep
p([gloss:on],   p(on))	   --> [on].
p([gloss:in],   p(in))	   --> [in].
p([gloss:with], p(with))   --> [with].
p([gloss:about],p(about))  --> [about].
p([gloss:of],   p(of))	   --> [of].
p([gloss:to],   p(to))	   --> [to].

% complementizer
c([gloss:that], c(that))   --> [that].
c([gloss:when], c(when))   --> [when].
