#!/bin/bash

read -p "Test number: " test_number

folder=$"./testset/test_${test_number}/paraview"

i=1
number_files=$(ls -1 $folder/*.dat | wc -l)

if [ ! -d $folder ]; then
    echo 'No such test exists'
    exit 1
fi

for file in $folder/*.dat; do
    read -r nx ny <<< "$(head -1 $file)"
    # You could extract output name from filename
    output_file="${file%.dat}_density.png"

    #gnuplot -e "coord_file='"./testset/test_${test_number}"/points.dat';input_file='${file}'; output_file='${output_file}'; nx=$nx; ny=$ny" gnuplot_files/density.plt
    gnuplot -e "input_file='${file}'; output_file='${output_file}'; nx=$nx; ny=$ny" gnuplot_files/density.plt

    bash ./bash_files/progress_bar.sh "$number_files" "$i"

    i=$((i+1))
done

echo

mkdir $folder/plot_density

mv $folder/*_density.png $folder/plot_density