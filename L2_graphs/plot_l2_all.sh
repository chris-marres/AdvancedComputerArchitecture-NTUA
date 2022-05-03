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
    python plot_l2.py "false" "${bench}" ../L2/${bench}.*
done

for bench in "${BenchArray[@]}"; do
    python plot_l2.py "true" "${bench}" ../L2/${bench}.*
done