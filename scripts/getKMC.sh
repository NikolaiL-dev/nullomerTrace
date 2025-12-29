#!/usr/bin/env bash

wd=$(dirname `dirname "$0"`)

mkdir -p ${wd}/kmers4genomes ${wd}/.tmp ${wd}/kspaces ${wd}/nullomers/plane ${wd}/tools ${wd}/genomes

wget -q -O ${wd}/tools/KMC3.2.4.linux.x64.tar.gz https://github.com/refresh-bio/KMC/releases/download/v3.2.4/KMC3.2.4.linux.x64.tar.gz
tar -xvzf ${wd}/tools/KMC3.2.4.linux.x64.tar.gz -C ${wd}/tools/
rm ${wd}/tools/KMC3.2.4.linux.x64.tar.gz

