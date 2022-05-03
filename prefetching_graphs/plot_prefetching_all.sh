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
    python plot_prefetching.py "${bench}" ../prefetching/${bench}.*
done