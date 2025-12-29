from itertools import product
from sys import argv

k      = int(argv[1])
output = argv[2]

with open(output, "w") as fa:
    for c, kmer in enumerate(product("ACGT", repeat=k)):
        fa.write(f">{c}\n")
        fa.write(f"{"".join(kmer)}\n")
