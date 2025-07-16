#!/bin/bash

read -p "Test number: " test_number

folder=$"./testset/test_${test_number}"

if [ ! -d $folder ]; then
    echo 'No such test exists'
    exit 1
fi

gnuplot -e "input_file='$folder/convergence.dat'; output_file='$folder/errors.png'" ./gnuplot_files/plot_error.plt