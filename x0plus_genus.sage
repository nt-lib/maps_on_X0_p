def genus_X0_plus(p):
    assert p > 4
    g = Gamma0(p).genus()
    if p% 4 == 3:
        ram = BQFClassGroup(-4*p).order()+BQFClassGroup(-p).order()
    else:
        ram = BQFClassGroup(-4*p).order()
    gplus_4 = 2*g+2-ram
    assert gplus_4%4 == 0
    return gplus_4//4

for p in prime_range(5,250000):
    gplus = genus_X0_plus(p)
    g = Gamma0(p).genus()
    if (2*g-2) > 3*(2*(gplus-2)-2):
        print(p)
        
"""
The primes > 1000 printed by the above code are
1019
1031
1091
1151
1223
1319
1439
1511
1559
2351
"""
