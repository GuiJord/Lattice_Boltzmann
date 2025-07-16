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
set ylabel 'Tortuosity (|{/Symbol t}|)'
set y2label 'log(Error)'         # Label for second Y axis
set y2tics                        # Enable second Y axis tics
set grid


# Tics
set tics out

#set yrange [0:0.13]       # Linear tortuosity
set y2range [-10:0]       

# Plot columns 2,3 as Y against column 1 (X)
plot \
    input_file using (log($1)):(log($2)) with lines title 'tortuosity',\
    input_file using (log($1)):(log($3)) with lines title 'error' axes x1y2