#!/bin/bash

#Test dir creation ==============================================
read -p "Test number: " test_number

test_dir=$"./testset/test_$test_number"
paraview_dir=$"$test_dir/paraview"

if [ ! -d './testset' ]; then
    mkdir './testset'
fi

if [ -d $test_dir ]; then
  echo "Directory '$test_dir' already exists."
  exit 1
fi

mkdir $test_dir
mkdir $paraview_dir
#======================================== Test dir creation - End

#Compilation ==============================================
cd src

gfortran -c 1_geometry_func.f95
gfortran -c 2_parameters.f95
gfortran -c 3_auxiliary_func.f95
gfortran -c 4_initialization_func.f95
gfortran -c 5_collision_func.f95
gfortran -c 6_adsorption_func.f95
gfortran -c 7_thermalization_func.f95
gfortran -c 9_boundary_conditions_func.f95
gfortran -c 8_propagation_func.f95
gfortran -c 10_data_func.f95
gfortran -c main.f95
gfortran main.o 1_geometry_func.o 2_parameters.o 3_auxiliary_func.o 4_initialization_func.o 5_collision_func.o 6_adsorption_func.o 7_thermalization_func.o 8_propagation_func.o 9_boundary_conditions_func.o 10_data_func.o -o ../main_executable

mv *.o *.mod compiled
cd ..
#======================================== Compilation - End



#================================== Program Execution - Beginning ============================================

start_time=$(date +%s)

#Execute program
./main_executable<<<"$test_number"

end_time=$(date +%s)
duration=$(( end_time - start_time ))

#================================== Program Execution - End ==================================================


#Copy program to test directory
mkdir $test_dir/program_copy
cp ./src/*.f95 $test_dir/program_copy


#Show Running time ==============================================
echo ' '
if [ "$duration" -lt 60 ]; then
    echo "Running time: $duration seconds"
elif [ "$duration" -lt 3600 ]; then
    minutes=$(( duration / 60 ))
    seconds=$(( duration % 60 ))
    echo "Running time: $minutes min $seconds s"
elif [ "$duration" -lt 86400 ]; then
    hours=$(( duration / 3600 ))
    remaining=$(( duration % 3600 ))
    minutes=$(( remaining / 60 ))
    seconds=$(( remaining % 60 ))
    echo "Running time: $hours h $minutes min $seconds s"
else
    days=$(( duration / 86400 ))
    remaining=$(( duration % 86400 ))
    hours=$(( remaining / 3600 ))
    remaining=$(( remaining % 3600 ))
    minutes=$(( remaining / 60 ))
    seconds=$(( remaining % 60 ))
    echo "Running time: $days d $hours h $minutes min $seconds s"
fi
echo ' '
# #======================================== Show Running time - End



# #================================== Post-Processing - Beginning ============================================

# #Paraview ==============================================
# read -p "Convert to Paraview [y/n] " paraview_conv

# if [ "$paraview_conv" = "y" ]; then
#     echo 'Converting data to Paraview'
#     source ./bash_files/venv_activation.sh
#     start_time=$(date +%s)

#     python3 ./python_files/paraview_converter.py <<<"$test_number"

#     end_time=$(date +%s)
#     duration=$(( end_time - start_time ))
#     echo 'Done'
#     echo ' '
#     if [ "$duration" -lt 60 ]; then
#         echo "Running time: $duration seconds"
#     elif [ "$duration" -lt 3600 ]; then
#         minutes=$(( duration / 60 ))
#         seconds=$(( duration % 60 ))
#         echo "Running time: $minutes min $seconds s"
#     fi
# fi
# echo ' '
# #======================================== Paraview - End

# #Error plot ==============================================
# read -p "Plot Errors [y/n] " plot_res

# if [ "$plot_res" = "y" ]; then
#     bash ./bash_files/plot_errors.sh<<<"$test_number"
#     echo 'Done'
# fi
# echo ' '
# #======================================== Error plot - End

# #Tortuosity plot ==============================================
# read -p "Plot Toruosity [y/n] " plot_tortuosity

# if [ "$plot_tortuosity" = "y" ]; then
#     tortuosity_input_file="${test_dir}/tortuosity.dat"
#     tortuosity_output_file="${test_dir}/tortuosity.png"
#     touch $tortuosity_output_file
#     gnuplot -e "input_file='${tortuosity_input_file}'; output_file='${tortuosity_output_file}'" ./gnuplot_files/plot_tortuosity.plt<<<"$test_number"
#     echo 'Done'
# fi
# echo ' '
# #======================================== Tortuosity plot - End

# #Density plot ==============================================
# read -p "Plot Density with GNUPLOT [y/n] " plot_dens

# if [ "$plot_dens" = "y" ]; then
#     bash ./bash_files/plot_density.sh<<<$test_number
#     echo 'Done'
# fi
# echo ' '
# #======================================== Density plot - End

# #Black vector plot ==============================================
# read -p "Plot Black Vectors with GNUPLOT [y/n] " plot_vec_black

# if [ "$plot_vec_black" = "y" ]; then
#     bash ./bash_files/plot_vector_black.sh<<<$test_number
#     echo 'Done'
# fi
# echo ' '
# #======================================== Black vector plot - End

# #Concentration plot ==============================================
# read -p "Plot Concentration with GNUPLOT [y/n] " plot_conc

# if [ "$plot_conc" = "y" ]; then
#     bash ./bash_files/plot_concentration.sh<<<$test_number
#     echo 'Done'
# fi
# echo ' '
# #======================================== Concentration plot - End

# #Temperature plot ==============================================
# read -p "Plot Temperature with GNUPLOT [y/n] " plot_temp

# if [ "$plot_temp" = "y" ]; then
#     bash ./bash_files/plot_temperature.sh<<<$test_number
#     echo 'Done'
# fi
# #======================================== Temperature plot - End

# #================================== Post-Processing - End ==================================================




# echo ' '
# read -p "Plot Colored Vectors with GNUPLOT [y/n] " plot_vec_color

# if [ "$plot_vec_color" = "y" ]; then
#     bash ./bash_files/plot_vector_colored.sh<<<$test_number
#     echo 'Done'
# fi

#for i in {1..5}
#do
#  echo -e "\a"  # This will produce a bell sound
#  sleep 1       # Wait for 1 second between beeps
#done