#!/bin/bash

declare -a BenchArray=(
        "blackscholes"
        "bodytrack"
        "canneal"
        "fluidanimate"
        "freqmine"
        "rtview"
        "streamcluster"
        "swaptions"
)

for bench in "${BenchArray[@]}"; do
    python plot_tlb.py "false" "${bench}" ../TLB/${bench}.*
done

for bench in "${BenchArray[@]}"; do
    python plot_tlb.py "true" "${bench}" ../TLB/${bench}.*
done