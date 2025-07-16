read -p "Test number: " test_number

test_dir=$"./testset/test_$test_number"

echo 'Generate Concentration Maps'
bash bash_files/plot_concentration.sh <<< $test_number
echo 'Generate Temperature Maps'
bash bash_files/plot_temperature.sh <<< $test_number

input="$(printf "%s\n2\n3\n10" "$test_number")"
python3 python_files_refined/video_maker.py <<< "$input"
input="$(printf "%s\n3\n3\n10" "$test_number")"
python3 python_files_refined/video_maker.py <<< "$input"

cd $test_dir

ffmpeg -i concentration_video.mp4 -i temperature_video.mp4 -filter_complex "[0:v][1:v]hstack=inputs=2" video_side_by_side.mp4
ffmpeg -i video_side_by_side.mp4 -vf "fps=10,scale=1400:-1:flags=lanczos" -c:v gif gif_side_by_side.gif