import numpy as np
import matplotlib.pyplot as plt
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


test = int(input("Test: "))
directory = f'./testset/test_{test}/paraview'
N, file_names = get_file_names(directory)

data_length = 5
flux_left  = np.array([]) 
flux_mid   = np.array([]) 
flux_right = np.array([]) 

time_steps = np.linspace(0,N-1,N)


for i in range(N):
    print(f'Progress: {round(i/N*100,2)}%')
    file_path = os.path.join(directory, file_names[i] + '.dat')
    print(file_path)
    nx, ny, matrix = interpret_dat_file(file_path)

    rho = matrix[:, :, 0]
    u  = matrix[:, :, 1]
    ux = matrix[:, :, 2]
    uy = matrix[:, :, 3]

    flux = rho*ux + rho*uy

    flux_left = np.append(flux_left,sum(flux[2,:]))
    flux_mid = np.append(flux_mid,sum(flux[nx//2,:]))
    flux_right = np.append(flux_right,sum(flux[-2,:]))


plt.plot(time_steps,flux_left)
plt.plot(time_steps,flux_mid)
plt.plot(time_steps,flux_right)
plt.savefig('figura_teste.png')