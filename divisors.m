// this file contains some helper functions to enumerate all divisors of a certain
// degree


function DegreeTypes_of_Degree(degree,curve)
//{A degree type of degree d is a list of pairs of integers [(n1,d1),...,(nk,dk)] such that
//The sum n1*d1+...+nk*dk is d. The values of di are restriced to the numbers for which the curve
//has a place of that degree. And the tuples are also sorted such that di >= d(i+1) and if di = d(i+1) then ni >= n(i+1).
//This function returns all degree types satisfying the above restrictions.
//}
    occurring_degrees := [i : i in [1..degree] | HasPlace(curve,i) ];
    degree_types_old:= [<[<0,0>],degree>];
    degree_types_new:= [<[<0,0>],degree>];
    degree_types_done := [];
    for d in Reverse(occurring_degrees) do
        for n in Reverse([1..Floor(degree/d)]) do
            for degree_type in degree_types_old do
                for i in [1..Floor(degree_type[2]/(n*d))] do
                    d_t := <degree_type[1] cat [<n,d> : j in [1..i]],degree_type[2]-n*d*i>;
                    degree_types_new := Append(degree_types_new, d_t);
                end for;
            end for;
            degree_types_done := degree_types_done cat [d_t[1][2..#d_t[1]] : d_t in degree_types_new | d_t[2] eq 0];
            degree_types_new := [d_t : d_t in degree_types_new | d_t[2] gt 0];
            degree_types_old := degree_types_new;
        end for;
    end for;
    return degree_types_done;
end function;



function Divisors_of_DegreeType(degree_type,curve)
    divisors_old:={<DivisorGroup(curve) ! 0,[]>};
    divisors_new:=divisors_old;
    for d in degree_type do;
        divisors_new:={<D1[1]+d[1]*D2,Append(D1[2],D2)> : D1 in divisors_old, D2 in Places(curve,d[2]) | D2 notin D1[2]};
        //divisors_new:={D1+D2 : D1 in divisors_old, D2 in Places(curve,d)};
        divisors_old:=divisors_new;
    end for;
    return divisors_new;
end function;

function Divisors_of_Degree(degree,curve)
    return &join [Divisors_of_DegreeType(degree_type,curve) : degree_type in DegreeTypes_of_Degree(degree,curve)];
end function;