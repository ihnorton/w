codons = """
UUU F      
CUU L      
AUU I      
GUU V
UUC F      
CUC L      
AUC I      
GUC V
UUA L      
CUA L      
AUA I      
GUA V
UUG L      
CUG L      
AUG M      
GUG V
UCU S      
CCU P      
ACU T      
GCU A
UCC S      
CCC P      
ACC T      
GCC A
UCA S      
CCA P      
ACA T      
GCA A
UCG S      
CCG P      
ACG T      
GCG A
UAU Y      
CAU H      
AAU N      
GAU D
UAC Y      
CAC H      
AAC N      
GAC D
CAA Q      
AAA K      
GAA E
CAG Q      
AAG K      
GAG E
UGU C      
CGU R      
AGU S      
GGU G
UGC C      
CGC R      
AGC S      
GGC G
CGA R      
AGA R      
GGA G
UGG W      
CGG R      
AGG R      
GGG G
UAG Stop   
UGA Stop   
UAA Stop
"""
codonmap = [c => p for (c,p) in map(x->split(chomp(x)), split(chomp(codons),"\n"))]

codon(i,str) = str[i:i+2]

function calc_prot(rna)
    res = []
    i = 1 
    while i < length(rna)-2
        next = codonmap[codon(i,rna)]
        next == "Stop" && break
        push!(res, next)
        i += 3 
    end
    println(join(res))
end

input = chomp(readline(open(ARGS[1])))
calc_prot(input)
