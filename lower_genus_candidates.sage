import  time

def modular_kernel_invariants(S, decomposition):
    """compute the invarants of the modular kernel corresponding to a subset S of the decomposition
    This function should return the same as sum(S).modular_kernel().invariants(). It assumes that
    decomposition is the decomposition of the ambient abelian variety
    """
    S_c = [Si for Si in decomposition if Si not in S]
    assert len(decomposition) == len(S) + len(S_c)
    A = sum(S)
    B = sum(S_c)
    J = A.ambient_variety()
    mod_ker = (J.lattice()/(A.lattice()+B.lattice()))
    return list(mod_ker.invariants())

def lower_genus_candidates(J, verbose = False):
    """Let J be the modular abelian variety J_0(p) then with p a prime, then we return the isogeny factors
    of J that could potentially correspond to a map X_0(p) -> C where C is a curve of genus at least 2.
    Note, we only return candidates that do not come from involutions.
    """
    candidates = []
    gJ = J.dimension()
    dec = J.decomposition()
    # the map needs to come from an involution if the dimension is to large so we skip it
    small_factors = [A for A in dec if 2*gJ-2 >= 3*(2*A.dimension()-2)]
    for i,S in enumerate(Subsets(small_factors)):
        if verbose: t = time.monotonic()
        if not S:
            continue
        g = sum([A.dimension() for A in S])
        if g==1 or g==gJ:
            continue
        if 2*gJ-2 < 3*(2*g-2):
            # the map needs to come from an involution so we skip it.
            continue

        ker = modular_kernel_invariants(S, dec)
        d = lcm(ker)
        # the following code computes the modular kernel as well using sage builtin
        # functions but in some examples I tried it is a factor 10 slower
        # A = sum(S)
        # ker2 = A.modular_kernel().invariants()
        # assert ker==ker2

        if 2*gJ-2 >= d*(2*g-2):
            candidates.append([S,g,d,floor((2*gJ-2)/(2*g-2))])
        if verbose:
            print(f"done {i} out of {2**len(dec)} in {time.monotonic()-t} seconds")
    return candidates

@parallel(6)
def lower_genus_candidates_parallel(p):
    J = J0(p)
    gplus = (J.modular_symbols().atkin_lehner_operator()-1).kernel().dimension()/2
    candidates = lower_genus_candidates(J)
    return len(candidates), J.dimension(), gplus,[A[1:] for A in candidates]

