reset
set terminal pngcairo size 1000,(1000*ny/nx) enhanced font "Courier,10"
set output output_file

ever = 10
vec_size = 12
vel_min = 0.005

# Plot appearance
set size ratio -1
set xrange [0:nx]
set yrange [0:ny]
unset key

# Turbo colormap
set cbrange [0:0.25]        # Set fixed color range
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
set autoscale cbfix        # Prevent auto-scaling from overriding
set cblabel "Velocity Magnitude"
set colorbox
# Plot: background image (velocity magnitude) + vectors overlay
plot input_file using \
    (floor($0 / ny)):( $0 - ny * floor($0 / ny) ):( $2 ) \
    with image, \
'' using \
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? $0 - ny * floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$3 / sqrt($3**2 + $4**2) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$4 / sqrt($3**2 + $4**2) : 1/0 ) \
    with vectors head filled lc rgb "black"