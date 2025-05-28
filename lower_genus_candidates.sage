def lower_genus_candidates(J):
    """Let J be the modular abelian variety J_0(p) then with p a prime, then we return the isogeny factors
    of J that could potentially correspond to a map X_0(p) -> C where C is a curve of genus at least 2.
    Note, we only return candidates that do not come from involutions.
    """
    candidates = []
    gJ = J.dimension()
    dec = J.decomposition()
    # the map needs to come from an involution if the dimension is to large so we skip it
    dec = [A for A in dec if 2*gJ-2 >= 3*(2*A.dimension()-2)]
    for S in Subsets(J.decomposition()):
        if not S:
            continue
        A = sum(S)
        g = A.dimension()
        if g==1 or g==gJ:
            continue
        if 2*gJ-2 < 3*(2*g-2):
            # the map needs to come from an involution so we skip it.
            continue
        d = lcm(A.modular_kernel().invariants())
        if 2*gJ-2 >= d*(2*g-2):
            candidates.append([A,g,d,floor((2*gJ-2)/(2*g-2))])
    return candidates

@parallel(6)
def lower_genus_candidates_parallel(p):
    J = J0(p)
    gplus = (J.modular_symbols().atkin_lehner_operator()-1).kernel().dimension()/2
    candidates = lower_genus_candidates(J)
    return len(candidates), J.dimension(), gplus,[A[1:] for A in candidates]

if __name__ == "main":
    done = {}
    todo = prime_range(20,3000)
    candidates = lower_genus_candidates_parallel(list(todo))
    for p in todo:
        while not (p in done):
            answer = next(candidates)
            done[answer[0][0][0]] = answer[1]
        print(p, done[p])
    