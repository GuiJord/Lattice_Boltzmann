import numpy as np
from pyevtk.hl import gridToVTK
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



def paraview_plot(matrix,file_name,directory):
    u = matrix[:,:,1]

    x = np.linspace(0, u.shape[0] - 1, u.shape[0])
    y = np.linspace(0, u.shape[1] - 1, u.shape[1])
    z = np.array([0.0])  # Single z-plane

    rho = matrix[:, :, 0]
    u   = matrix[:, :, 1]
    ux = matrix[:, :, 2]
    uy = matrix[:, :, 3]

    rho_ = np.ascontiguousarray(rho[:, :, np.newaxis])
    u_ = np.ascontiguousarray(u[:, :, np.newaxis])
    ux_ = np.ascontiguousarray(ux[:, :, np.newaxis])
    uy_ = np.ascontiguousarray(uy[:, :, np.newaxis])
    
    if data_format == 1:
        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_})

    elif data_format == 2:
        C = matrix[:,:,4]
        C_ = np.ascontiguousarray(C[:, :, np.newaxis])

        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_,
            "concentration": C_})

    elif data_format == 3:
        T = matrix[:,:,4]
        T_ = np.ascontiguousarray(T[:, :, np.newaxis])

        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_,
            "temperature": T_})

    elif data_format == 4:
        C = matrix[:,:,4]
        C_ = np.ascontiguousarray(C[:, :, np.newaxis])
        C_a = matrix[:,:,5]
        C_a_ = np.ascontiguousarray(C_a[:, :, np.newaxis])

        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_,
            "concentration": C_,
            "ads concentration": C_a_})

    elif data_format == 5:
        C = matrix[:,:,4]
        C_ = np.ascontiguousarray(C[:, :, np.newaxis])
        T = matrix[:,:,5]
        T_ = np.ascontiguousarray(T[:, :, np.newaxis])

        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_,
            "concentration": C_,
            "temperature": T_})

    elif data_format == 6:
        C = matrix[:,:,4]
        C_ = np.ascontiguousarray(C[:, :, np.newaxis])
        C_a = matrix[:,:,5]
        C_a_ = np.ascontiguousarray(C_a[:, :, np.newaxis])
        T = matrix[:,:,6]
        T_ = np.ascontiguousarray(T[:, :, np.newaxis])

        gridToVTK(
        os.path.join(directory, file_name),
        x, y, z,
        pointData={
            "u": u_,
            "ux": ux_,
            "uy": uy_,
            "density": rho_,
            "concentration": C_,
            "ads concentration": C_a_,
            "temperature": T_})

test = int(input("Test: "))

print('1 - density, velocity, vel_x, vel_y')
print('2 - density, velocity, vel_x, vel_y, conc')
print('3 - density, velocity, vel_x, vel_y, temp')
print('4 - density, velocity, vel_x, vel_y, conc, ads conc')
print('5 - density, velocity, vel_x, vel_y, conc, temp')
print('6 - density, velocity, vel_x, vel_y, conc, ads conc, temp')

data_format = int(input())

if data_format == 1:
    data_length = 4
elif data_format == 2:
    data_length = 5
elif data_format == 3:
    data_length = 5
elif data_format == 4:
    data_length = 6
elif data_format == 5:
    data_length = 6
elif data_format == 6:
    data_length = 7

directory = f'./testset/test_{test}/paraview'
N, file_names = get_file_names(directory)

for i in range(N):
    print(f'Progress: {round(i/N*100,2)}%')
    file_path = os.path.join(directory, file_names[i] + '.dat')
    nx, ny, matrix = interpret_dat_file(file_path)

    paraview_plot(matrix,file_names[i],directory)

    #Optional: remove original .dat file
    #os.remove(file_path)