% ===============================================================================
% greek_philosopher.pl
% Resolution Refutation of "Socrates is mortal" in First-Order Predicate Logic
% - Demonstrates Steps 1..8 programmatically where appropriate
% - Run with: ?- [greek_philosopher].  ?- main.
% ===============================================================================
% Predicates used for display and automated resolution are below.
% ===============================================================================
% STEP 1: Predicate logic representation (as Prolog terms)
% ===============================================================================
% MANUAL CONVERSION STEP 1:
% Translating English sentences to First-Order Logic (FOL)
%
% Predicates:
%   Man(x)         - x is a man
%   Mortal(x)      - x is mortal
%   Greek(x)       - x is a Greek
%   Philosopher(x) - x is a philosopher
%   Thinker(x)     - x is a thinker
%
% FOL Statements:
%   1. ∀x (Man(x) → Mortal(x))              - All men are mortal
%   2. ∀x (Greek(x) → Man(x))               - All Greeks are men
%   3. ∀x (Philosopher(x) → Thinker(x))     - All philosophers are thinkers
%   4. Greek(Socrates) ∧ Philosopher(Socrates) - Socrates is Greek and philosopher
%
% Goal to prove: Mortal(Socrates)
% ===============================================================================
%
% Predicates:
%   man(X), mortal(X), greek(X), philosopher(X), thinker(X)
%
% FOL stored as terms (for demo and printing)
fol_statement(1, 'All men are mortal', forall(x, implies(man(x), mortal(x)))).
fol_statement(2, 'All Greeks are men', forall(x, implies(greek(x), man(x)))).
fol_statement(3, 'All philosophers are thinkers', forall(x, implies(philosopher(x), thinker(x)))).
fol_statement(4, 'Socrates is a Greek and a philosopher', and(greek(socrates), philosopher(socrates))).

goal_statement('Socrates is mortal', mortal(socrates)).

show_step1 :-
    write('================================================================================'), nl,
    write('STEP 1: PREDICATE LOGIC REPRESENTATION'), nl,
    write('================================================================================'), nl, nl,
    forall(fol_statement(N, English, FOL),
           (write('  '), write(N), write('. '), write(English), nl,
            write('     FOL: '), write(FOL), nl)),
    nl,
    goal_statement(GoalEnglish, GoalFOL),
    write('Goal to prove: '), write(GoalEnglish), nl,
    write('Goal FOL: '), write(GoalFOL), nl, nl.

% ===============================================================================
% STEP 2: NEGATION OF GOAL
% ===============================================================================
% MANUAL CONVERSION STEP 2:
% For Resolution Refutation, we assume the negation of what we want to prove
% and show that this leads to a contradiction (empty clause).
%
% Original Goal: Mortal(Socrates)
% Negated Goal:  ¬Mortal(Socrates)
%
% Knowledge Base with negated goal:
%   1. ∀x (Man(x) → Mortal(x))
%   2. ∀x (Greek(x) → Man(x))
%   3. ∀x (Philosopher(x) → Thinker(x))
%   4. Greek(Socrates) ∧ Philosopher(Socrates)
%   5. ¬Mortal(Socrates)  [Negated goal - added to KB]
% ===============================================================================

negated_goal(not(mortal(socrates))).

show_step2 :-
    write('================================================================================'), nl,
    write('STEP 2: NEGATION OF GOAL'), nl,
    write('================================================================================'), nl, nl,
    goal_statement(_, Goal),
    write('Original Goal: '), write(Goal), nl,
    negated_goal(NegGoal),
    write('Negated Goal (added to KB): '), write(NegGoal), nl, nl.

% ===============================================================================
% STEP 3: IMPLICATION REMOVAL (programmatic demo)
% ===============================================================================
% MANUAL CONVERSION STEP 3:
% Convert implications (→) to disjunctions using the equivalence:
% (P → Q) ≡ (¬P ∨ Q)
%
% After implication removal:
%   1. ∀x (¬Man(x) ∨ Mortal(x))
%   2. ∀x (¬Greek(x) ∨ Man(x))
%   3. ∀x (¬Philosopher(x) ∨ Thinker(x))
%   4. Greek(Socrates) ∧ Philosopher(Socrates)
%   5. ¬Mortal(Socrates)
% ===============================================================================
%
% remove_implication/2 - small demo: (implies(P,Q) -> or(not(P),Q))
remove_implication(implies(P,Q), or(not(P),Q)) :- !.
% Handle forall wrapper with inner implication
remove_implication(forall(Var, implies(P,Q)), forall(Var, or(not(P),Q))) :- !.
% propagate into conjunctions
remove_implication(and(A,B), and(A2,B2)) :-
    remove_implication(A, A2),
    remove_implication(B, B2), !.
% default - no implication found (identity)
remove_implication(Formula, Formula).

demo_remove_implications :-
    write('================================================================================'), nl,
    write('DEMO: IMPLICATION REMOVAL'), nl,
    write('================================================================================'), nl, nl,
    forall(fol_statement(N,Desc,Formula),
           ( write(N), write('. '), write(Desc), nl,
             write('   Original: '), write(Formula), nl,
             remove_implication(Formula, NewF),
             write('   After implication removal: '), write(NewF), nl, nl )),
    nl.

% ===============================================================================
% STEP 4: NEGATION MOVEMENT (demo)
% ===============================================================================
% MANUAL CONVERSION STEP 4:
% Apply De Morgan's laws and double negation elimination to move negations
% inward to literal level.
%
% In our case, all negations are already at the literal level.
% Result: Same as Step 3 (no changes needed)
% ===============================================================================
%
% For this simple KB negations are already atomic; demonstrate identity movement.
demo_negation_movement :-
    write('================================================================================'), nl,
    write('DEMO: NEGATION MOVEMENT'), nl,
    write('================================================================================'), nl, nl,
    write('In this KB negations are already at literal level; no De Morgan steps needed.'), nl, nl.

% ===============================================================================
% STEP 5: STANDARDIZATION (demo)
% ===============================================================================
% MANUAL CONVERSION STEP 5:
% Ensure each quantifier has unique variable names to avoid variable conflicts
% during resolution.
%
% After standardization:
%   1. ∀x1 (¬Man(x1) ∨ Mortal(x1))
%   2. ∀x2 (¬Greek(x2) ∨ Man(x2))
%   3. ∀x3 (¬Philosopher(x3) ∨ Thinker(x3))
%   4. Greek(Socrates) ∧ Philosopher(Socrates)
%   5. ¬Mortal(Socrates)
% ===============================================================================
%
% standardize_demo(+Term,-Standardized)
% Uses copy_term/2 and numbervars/4 to show standardized variable naming (demo).
standardize_demo(Term, Std) :-
    copy_term(Term, Copy),
    numbervars(Copy, 0, _, [singletons(true)]),
    Std = Copy.

demo_standardization :-
    write('================================================================================'), nl,
    write('DEMO: STANDARDIZATION (rename variables apart)'), nl,
    write('================================================================================'), nl, nl,
    after_implication_removal(1, F1),
    after_implication_removal(2, F2),
    after_implication_removal(3, F3),
    standardize_demo(F1, S1),
    standardize_demo(F2, S2),
    standardize_demo(F3, S3),
    write('1: '), write(S1), nl,
    write('2: '), write(S2), nl,
    write('3: '), write(S3), nl, nl.

% ===============================================================================
% STEP 6: SKOLEMIZATION (demo)
% ===============================================================================
% MANUAL CONVERSION STEP 6:
% Replace existential quantifiers with Skolem functions/constants.
% 
% In our problem, there are NO existential quantifiers (∃).
% We can drop the universal quantifiers (∀) as variables are now implicitly
% universally quantified.
%
% After Skolemization (dropping ∀):
%   1. ¬Man(x1) ∨ Mortal(x1)
%   2. ¬Greek(x2) ∨ Man(x2)
%   3. ¬Philosopher(x3) ∨ Thinker(x3)
%   4. Greek(Socrates) ∧ Philosopher(Socrates)
%   5. ¬Mortal(Socrates)
% ===============================================================================
%
% No existential quantifiers in our KB; show an explanatory message.
demo_skolemization :-
    write('================================================================================'), nl,
    write('DEMO: SKOLEMIZATION'), nl,
    write('================================================================================'), nl, nl,
    write('No existential quantifiers (∃) are present in this KB, so no Skolemization needed.'), nl, nl.

% ===============================================================================
% STEP 7: CONVERSION TO CNF (and clause extraction)
% ===============================================================================
% MANUAL CONVERSION STEP 7:
% Convert all formulas to CNF - a conjunction of disjunctive clauses.
% Each clause is a disjunction of literals.
%
% Statement 4 contains a conjunction (∧), so we split it into two clauses:
%   Greek(Socrates) ∧ Philosopher(Socrates) 
%   becomes:
%   Greek(Socrates)
%   Philosopher(Socrates)
%
% FINAL CNF CLAUSES (Clause Set):
%   C1: {¬Man(x), Mortal(x)}
%   C2: {¬Greek(x), Man(x)}
%   C3: {¬Philosopher(x), Thinker(x)}
%   C4: {Greek(Socrates)}
%   C5: {Philosopher(Socrates)}
%   C6: {¬Mortal(Socrates)}
% ===============================================================================
%
% After implication removal (statics) we keep these CNF clauses as facts (same as before).
% We split the conjunction in statement 4 into two clauses.
after_implication_removal(1, forall(x, or(not(man(x)), mortal(x)))).
after_implication_removal(2, forall(x, or(not(greek(x)), man(x)))).
after_implication_removal(3, forall(x, or(not(philosopher(x)), thinker(x)))).
after_implication_removal(4, and(greek(socrates), philosopher(socrates))).
after_implication_removal(5, not(mortal(socrates))).  % negated goal

% Clause representation (CNF clauses) - literal form using not/1 for negation
kb_clause(c1, [not(man(X)), mortal(X)]).
kb_clause(c2, [not(greek(X)), man(X)]).
kb_clause(c3, [not(philosopher(X)), thinker(X)]).
kb_clause(c4, [greek(socrates)]).
kb_clause(c5, [philosopher(socrates)]).
kb_clause(c6, [not(mortal(socrates))]).

clause_description(c1, 'All men are mortal').
clause_description(c2, 'All Greeks are men').
clause_description(c3, 'All philosophers are thinkers').
clause_description(c4, 'Socrates is Greek').
clause_description(c5, 'Socrates is a philosopher').
clause_description(c6, 'Negated goal (for refutation)').

demo_cnf_split :-
    write('================================================================================'), nl,
    write('DEMO: CNF CONVERSION / SPLIT CONJUNCTIONS'), nl,
    write('================================================================================'), nl, nl,
    fol_statement(4, Desc, and(A,B)),
    write('Original (statement 4): '), write(Desc), nl,
    write('As conjunction: '), write(and(A,B)), nl,
    write('Split into separate unit clauses:'), nl,
    write('  '), write(A), nl,
    write('  '), write(B), nl, nl.

show_step7 :-
    write('================================================================================'), nl,
    write('STEP 7: CNF CLAUSES (After all transformations)'), nl,
    write('================================================================================'), nl, nl,
    forall((kb_clause(ID, Clause), clause_description(ID, Desc)),
           (write(ID), write(': '), write(Clause), nl,
            write('    '), write(Desc), nl)),
    nl.

% ===============================================================================
% STEP 8: RESOLUTION REFUTATION PROCESS
% ===============================================================================
% MANUAL CONVERSION STEP 8:
% Apply the resolution rule repeatedly to derive the empty clause (□ or ⊥).
%
% RESOLUTION RULE:
% If we have two clauses: {L, A1, A2, ...} and {¬L, B1, B2, ...}
% where L unifies with the corresponding literal in the other clause,
% we can derive the resolvent: {A1, A2, ..., B1, B2, ...}
%
% The empty clause □ represents a contradiction, proving our original goal.
%
% RESOLUTION STEPS:
% -------------------------------------------------------------------------------
%
% STEP 8.1: Resolve C4 and C2 to derive C7
%   C4: {Greek(Socrates)}
%   C2: {¬Greek(x), Man(x)}
%   Unification: x = Socrates
%   After unification: {¬Greek(Socrates), Man(Socrates)}
%   Resolving Greek(Socrates) with ¬Greek(Socrates)
%   Resolvent C7: {Man(Socrates)}
%
% STEP 8.2: Resolve C7 and C1 to derive C8
%   C7: {Man(Socrates)}
%   C1: {¬Man(x), Mortal(x)}
%   Unification: x = Socrates
%   After unification: {¬Man(Socrates), Mortal(Socrates)}
%   Resolving Man(Socrates) with ¬Man(Socrates)
%   Resolvent C8: {Mortal(Socrates)}
%
% STEP 8.3: Resolve C8 and C6 to derive empty clause
%   C8: {Mortal(Socrates)}
%   C6: {¬Mortal(Socrates)}
%   Resolving Mortal(Socrates) with ¬Mortal(Socrates)
%   Resolvent: {} (EMPTY CLAUSE □)
%
% CONCLUSION:
% We derived the empty clause (□), which is a contradiction!
% This proves that our assumption ¬Mortal(Socrates) is FALSE.
% Therefore, Mortal(Socrates) is TRUE.
% Q.E.D. - Socrates is mortal.
% ===============================================================================
%
% Improved complementary/resolve using actual unification and printing bindings.

% complementary(+Lit1,+Lit2)
% Succeeds when Lit1 and Lit2 are complementary (one is not(...), other is the positive literal)
% It relies on Prolog unification to produce bindings if applicable.
complementary(L1, L2) :-
    ( L1 = not(A1), A1 = L2 -> true
    ; L2 = not(A2), A2 = L1 -> true
    ).

% show_bindings(+Template) - prints current bindings of variables in Template
show_bindings(T) :-
    term_variables(T, Vars),
    ( Vars = [] ->
        true
    ;
        write('  Current variable bindings: '), write(Vars), nl
    ).

% resolve_clauses(+Clause1,+Clause2,-Resolvent)
% Selects complementary literals (using unification), shows bindings, returns resolvent.
resolve_clauses(Clause1, Clause2, Resolvent) :-
    select(Lit1, Clause1, Rest1),
    select(Lit2, Clause2, Rest2),
    complementary(Lit1, Lit2),        % THIS performs unification if needed
    show_bindings(Lit1),
    append(Rest1, Rest2, Resolvent).

% Derivation clauses: show how C7, C8 and empty are derived
derive_clause(c7, [man(socrates)]) :-
    kb_clause(c4, C4),
    kb_clause(c2, C2),
    resolve_clauses(C4, C2, [man(socrates)]).

derive_clause(c8, [mortal(socrates)]) :-
    derive_clause(c7, C7),
    kb_clause(c1, C1),
    resolve_clauses(C7, C1, [mortal(socrates)]).

derive_clause(empty, []) :-
    derive_clause(c8, C8),
    kb_clause(c6, C6),
    resolve_clauses(C8, C6, []).

proof_succeeds :- derive_clause(empty, []).

% show_step8 prints the resolution steps with detail
show_step8 :-
    write('================================================================================'), nl,
    write('STEP 8: RESOLUTION REFUTATION PROCESS'), nl,
    write('================================================================================'), nl, nl,
    % Step 1
    kb_clause(c4, C4), kb_clause(c2, C2),
    write('RESOLUTION STEP 1:'), nl,
    write('  C4: '), write(C4), nl,
    write('  C2: '), write(C2), nl,
    write('  Resolve C4 and C2 => C7'), nl,
    resolve_clauses(C4, C2, C7),
    write('  Resolvent C7: '), write(C7), nl, nl,
    % Step 2
    kb_clause(c1, C1),
    write('RESOLUTION STEP 2:'), nl,
    write('  C7: '), write(C7), nl,
    write('  C1: '), write(C1), nl,
    write('  Resolve C7 and C1 => C8'), nl,
    resolve_clauses(C7, C1, C8),
    write('  Resolvent C8: '), write(C8), nl, nl,
    % Step 3
    kb_clause(c6, C6),
    write('RESOLUTION STEP 3:'), nl,
    write('  C8: '), write(C8), nl,
    write('  C6: '), write(C6), nl,
    write('  Resolve C8 and C6 => Empty clause'), nl,
    resolve_clauses(C8, C6, Empty),
    write('  Resolvent: '), write(Empty), nl, nl,
    ( Empty = [] ->
        write('*** EMPTY CLAUSE DERIVED: [] - CONTRADICTION FOUND! ***'), nl, nl
    ;
        write('ERROR: Empty clause not derived.'), nl, nl
    ).

% automated_proof performs the resolution programmatically and checks for empty clause
automated_proof :-
    write('================================================================================'), nl,
    write('AUTOMATED VERIFICATION'), nl,
    write('================================================================================'), nl, nl,
    kb_clause(c4, C4), kb_clause(c2, C2), kb_clause(c1, C1), kb_clause(c6, C6),
    resolve_clauses(C4, C2, C7),
    write('Step 1 result C7 = '), write(C7), nl,
    resolve_clauses(C7, C1, C8),
    write('Step 2 result C8 = '), write(C8), nl,
    resolve_clauses(C8, C6, EmptyClause),
    write('Step 3 result EmptyClause = '), write(EmptyClause), nl, nl,
    ( EmptyClause = [] ->
        write('*** AUTOMATED CHECK: EMPTY CLAUSE VERIFIED! Proof is VALID! ***'), nl, nl
    ;
        write('*** AUTOMATED CHECK FAILED: No empty clause derived ***'), nl, nl
    ).

% ===============================================================================
% MAIN: Runs all steps and demos - suitable for producing the screenshot required
% ===============================================================================
main :-
    write('================================================================================'), nl,
    write('RESOLUTION REFUTATION PROOF: THE GREEK PHILOSOPHER PROBLEM'), nl,
    write('================================================================================'), nl, nl,
    write('Given Facts:'), nl,
    write('  1. All men are mortal'), nl,
    write('  2. All Greeks are men'), nl,
    write('  3. All philosophers are thinkers'), nl,
    write('  4. Socrates is a Greek and a philosopher'), nl, nl,
    write('Goal: Prove that Socrates is mortal'), nl,
    write('Method: Resolution Refutation (with demo transformations)'), nl, nl,

    % Show each step (1..2 textual, 3..6 demos, 7 cnf, 8 resolution)
    show_step1,
    show_step2,
    demo_remove_implications,
    demo_negation_movement,
    demo_standardization,
    demo_skolemization,
    demo_cnf_split,
    show_step7,
    show_step8,
    automated_proof,

    write('================================================================================'), nl,
    write('CONCLUSION'), nl,
    write('================================================================================'), nl,
    write('The empty clause has been derived; the negated goal leads to contradiction.'), nl,
    write('Therefore: Mortal(Socrates) is TRUE. Q.E.D.'), nl, nl,
    write('*** END OF PROOF ***'), nl, nl,
    !.

% ===============================================================================
% Small helpers / tests (optional)
% ===============================================================================
test_resolve :-
    kb_clause(c4, C4), kb_clause(c2, C2),
    write('C4 = '), write(C4), nl,
    write('C2 = '), write(C2), nl,
    resolve_clauses(C4, C2, R), write('Resolvent = '), write(R), nl.

% ===============================================================================
% End of file
% ===============================================================================