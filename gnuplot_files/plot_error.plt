# This variable can be set inside the script or passed in via -e from Bash
# Example: gnuplot -e "input_file='your_file.dat'" plot_data.plt

if (!exists("input_file")) {
    print "Error: 'input_file' variable is not defined!"
    exit
}

set terminal pngcairo size 1000,600 enhanced font 'Courier,10'
set output output_file

set notitle 
set xlabel 'Time Step (t)'
set ylabel 'Error log10'
set grid
set key right top box width 1 height 0.8 spacing 1

# Plot columns 2 as Y against column 1 (X)
plot \
    input_file using 1:2 with lines title 'density' lw 2, \
    input_file using 1:3 with lines title 'u' lw 2, \
    input_file using 1:4 with lines title 'u_{x}' lw 2, \
    input_file using 1:5 with lines title 'u_{y}' lw 2