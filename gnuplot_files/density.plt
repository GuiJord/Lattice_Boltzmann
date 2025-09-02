set terminal pngcairo size 1000,(1000*ny/nx) enhanced font 'Courier,10'
set output output_file

set xlabel 'x'
set ylabel 'y'
set xrange[0:nx]
set yrange[0:ny]
set size ratio -1
set pm3d interpolate 2,2
#set grid
#set key right top box width 1 height 0.8 spacing 1
set cbrange [0.95:1.05]         # Colorbar range (adjust as needed)



unset key                 # Optional: removes legend


# Build shell command safely
#cmd = sprintf("paste '%s' '%s'", coord_file, input_file)
#plot "<".cmd using 1:2:3 with image notitle
plot input_file every ::1 using (int($0/ny)):(int($0)%ny):1 with image notitle