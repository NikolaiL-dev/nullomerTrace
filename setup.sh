#!/usr/bin/env bash

wd=$(dirname "$0")
threads=16

echo "Getting the genomes..."
python ${wd}/scripts/getGenomes.py
echo "[OK]"

echo "Installing the kmc tool..."
bash ${wd}/scripts/getKMC.sh
echo "[OK]"

echo "Calculating nullomers for each of the genomes..."
for k in {11..14}; do
	python ${wd}/scripts/createKmerSpace.py ${k} ${wd}/kspaces/k${k}.fa
	${wd}/tools/bin/kmc -k${k} -fm -t${threads} -ci1 -j${wd}/kspaces/k${k}.stats ${wd}/kspaces/k${k}.fa ${wd}/kspaces/k${k} ${wd}/.tmp
	for fa in `awk '{print $1}' ${wd}/genomes/config.tsv | grep -Ev "#"`; do
		${wd}/tools/bin/kmc -k${k} -fm -t${threads} -ci1 -j${wd}/kmers4genomes/${fa}_k${k}.stats ${wd}/genomes/${fa} ${wd}/kmers4genomes/${fa}_k${k} ${wd}/.tmp
		${wd}/tools/bin/kmc_tools simple ${wd}/kspaces/k${k} -ci1 ${wd}/kmers4genomes/${fa}_k${k} -ci1 kmers_subtract ${wd}/nullomers/${fa}_k${k}
		${wd}/tools/bin/kmc_tools transform ${wd}/nullomers/${fa}_k${k} dump ${wd}/nullomers/plane/${fa}_k${k}.txt
	done
done
echo "[OK]"
