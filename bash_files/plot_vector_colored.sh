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
    output_file="${file%.dat}_vector_color.png"

    gnuplot -e "input_file='${file}'; output_file='${output_file}'; nx=$nx; ny=$ny" gnuplot_files/vectors_colored.plt

    bash ./bash_files/progress_bar.sh "$number_files" "$i"

    i=$((i+1))
done

echo

mkdir $folder/plot_vector_colored

mv $folder/*vector_color.png $folder/plot_vector_colored