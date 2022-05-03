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
    python plot_l1.py "false" "${bench}" ../L1/${bench}.*
done

for bench in "${BenchArray[@]}"; do
    python plot_l1.py "true" "${bench}" ../L1/${bench}.*
done