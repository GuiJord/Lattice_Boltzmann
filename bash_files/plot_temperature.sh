#!/bin/bash

read -p "Test number: " test_number

folder=$"./testset/test_${test_number}/paraview"

i=0
number_files=$(ls -1 $folder/*.dat | wc -l)

if [ ! -d $folder ]; then
    echo 'No such test exists'
    exit 1
fi

for file in $folder/*.dat; do
    read -r nx ny <<< "$(head -1 $file)"
    # You could extract output name from filename
    output_file="${file%.dat}_temperature.png"

    gnuplot -e "input_file='${file}'; output_file='${output_file}'; nx=$nx; ny=$ny" gnuplot_files/temperature.plt
    i=$((i+1))
    progress=$(echo "scale=2;$i*100/$number_files" | bc)
    echo "Progress: ${progress}%"
done


mkdir $folder/plot_temperature

mv $folder/*temperature.png $folder/plot_temperature