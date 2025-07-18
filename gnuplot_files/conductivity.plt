set terminal pngcairo size 1000,(1000*ny/nx) enhanced font 'Courier,10'
set output output_file

set xlabel 'x'
set ylabel 'y'
set xrange[0:nx]
set yrange[0:ny]

ever = 15
vec_size = 15
vel_min = 0.005

set size ratio -1
#set grid
#set key right top box width 1 height 0.8 spacing 1
set cbrange [0:0.13333333]         # Colorbar range (adjust as needed)

# line styles
set palette defined ( 0 '#ff00ff', 1 '#ffff00' )

unset key                 # Optional: removes legend

set autoscale cbfix        # Prevent auto-scaling from overriding
set cblabel "Conductivity"
set colorbox
# Plot: background image (velocity magnitude) + vectors overlay
plot input_file every ::1 using \
    (floor($0 / ny)):( $0 - ny * floor($0 / ny) ):( $7 ) \
    with image, \
'' using \
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? $0 - ny * floor($0 / ny) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$3 / sqrt($3**2 + $4**2) : 1/0 ) :\
    ( (int(floor($0 / ny)) % ever == 0 && int($0 - ny * floor($0 / ny)) % ever == 0 && sqrt($3**2 + $4**2) > vel_min) ? vec_size*$4 / sqrt($3**2 + $4**2) : 1/0 ) \
    with vectors head filled lc rgb "black"