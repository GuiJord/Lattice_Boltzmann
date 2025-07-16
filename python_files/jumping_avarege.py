import numpy as np
import os
import re

def get_file_names(directory):
    try:
        files = [
            f for f in os.listdir(directory)
            if os.path.isfile(os.path.join(directory, f)) and re.match(r'^paraview_\d+\.dat$', f)
        ]
        # Sort files by the numeric value after 'paraview_'
        sorted_files = sorted(
            files,
            key=lambda x: int(re.search(r'(\d+)', x).group(1))
        )
        file_names = [os.path.splitext(file)[0] for file in sorted_files]
        return len(file_names), file_names
    except FileNotFoundError:
        print(f"The directory '{directory}' does not exist.")
        return 0, []
    except Exception as e:
        print(f"An error occurred: {e}")
        return 0, []

def interpret_dat_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # First line contains nx and ny as space-separated integers
    try:
        nx, ny = map(int, lines[0].strip().split())
    except ValueError:
        raise ValueError("First line must contain two integers: nx and ny.")

    processed_lines = []
    for i, line in enumerate(lines[1:], start=2):  # start=2 for real line number
        line = line.strip()
        if not line:
            continue  # Skip empty lines
        values = line.split()
        if len(values) != data_length:
            print(f"Warning: Skipping malformed line {i} with {len(values)} values: {line}")
            continue
        processed_lines.append(" ".join(values))
    # Convert to NumPy array
    data = np.loadtxt(processed_lines, dtype=np.float64)

    try:
        matrix = data.reshape((nx, ny, data_length), order='C')
    except ValueError as e:
        raise ValueError(f"Data cannot be reshaped to ({nx}, {ny}, {data_length}): {e}")
    return nx, ny, matrix

def compression(matrix):
    matrix_new = np.zeros((nx_,ny_))
    for x in range(nx_):
        for y in range(ny_):
            avg = r*np.sum(matrix[x*h:(x+1)*h,y*h:(y+1)*h])
            matrix_new[x,y] = avg
    return matrix_new

r = 0.1
compress = 1-r
h = 1/r

nx_ = r*nx
ny_ = r*ny

test = int(input("Test: "))
directory = f'./testset/test_{test}/paraview'
N, file_names = get_file_names(directory)


for i in range(N):
    print(f'Progress: {round(i/N*100,2)}%')
    file_path = os.path.join(directory, file_names[i] + '.dat')
    nx, ny, matrix = interpret_dat_file(file_path)