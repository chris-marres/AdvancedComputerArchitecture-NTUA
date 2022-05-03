#!/bin/bash

## Modify the following paths appropriately
PARSEC_PATH=~/chris/parsec-3.0
PIN_EXE=~/chris/pin-3.22-98547-g7a303a835-gcc-linux/pin
PIN_TOOL=~/chris/helpcode/pintool/obj-intel64/simulator.so

CMDS_FILE=~/chris/helpcode/cmds_simlarge.txt
outDir=~/chris/outputs/prefetching

export LD_LIBRARY_PATH=$PARSEC_PATH/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib/

## Triples of <cache_size>_<associativity>_<block_size>
CONFS="1 2 4 8 16 32 64"

L1size=32
L1assoc=8
L1bsize=64
L2size=1024
L2assoc=8
L2bsize=128
TLBe=64
TLBa=4
TLBp=4096

counter=1

for BENCH in $@; do
	cmd=$(cat ${CMDS_FILE} | grep "$BENCH")
for conf in $CONFS; do
	## Get parameters
    L2prf=$(echo $conf)

	outFile=$(printf "%s.dcache_cslab.prefetching_%02d.out" $BENCH ${L2prf})
	outFile="$outDir/$outFile"

	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $outFile -L1c ${L1size} -L1a ${L1assoc} -L1b ${L1bsize} -L2c ${L2size} -L2a ${L2assoc} -L2b ${L2bsize} -TLBe ${TLBe} -TLBp ${TLBp} -TLBa ${TLBa} -L2prf ${L2prf} -- $cmd"
	
	printf "#######################################################################################\n"
	printf "Now running benchmark: %s with configuration: %s. %d/56\n" $BENCH $conf $counter
	printf "#######################################################################################\n\n"
	time $pin_cmd
	printf "\n#######################################################################################\n"
	printf "Finished benchmark: %s with configuration: %s. %d/56\n" $BENCH $conf $counter
	printf "#######################################################################################\n\n\n"
	((counter+=1))

done
done
