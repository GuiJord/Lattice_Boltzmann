reset
set terminal pngcairo size 1000,(1000*ny/nx) enhanced font "Courier,10"
set output output_file

ever = 15
vec_size = 15
vel_min = 0.001

# Set plot appearance
set size ratio -1
set xrange [0:nx]
set yrange [0:ny]
unset key

# Color palette for velocity magnitude
set cbrange [0:0.21]        # Set fixed color range
set palette defined (\
    0.0  '#30123B', \
    0.1  '#4144C6', \
    0.2  '#4685EB', \
    0.3  '#3CB9EA', \
    0.4  '#38D7B9', \
    0.5  '#50E08D', \
    0.6  '#A8E54C', \
    0.7  '#F8E621', \
    0.8  '#F89411', \
    0.9  '#E04014', \
    1.0  '#900C1B' )
set cblabel "Velocity Magnitude"
set colorbox
#Plot using column-major indexing
#$0 is the data point index (starting from 0)
#Position: x = floor($0 / ny), y = $0 - ny * floor($0 / ny)
#Vectors: normalized (vx, vy), colored by magnitude (column 2)
plot input_file using \
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? $0 - ny * floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$3 / sqrt($3**2 + $4**2) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$4 / sqrt($3**2 + $4**2) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? $2 : 1/0 ) \
    with vectors head filled lc palette