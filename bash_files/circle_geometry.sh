#!/bin/bash

source ./bash_files/venv_activation.sh

python3 ./python_files/circle.py
python3 ./python_files/geometry.py
rm ./geometry.npy