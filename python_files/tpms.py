import numpy as np
import matplotlib.pyplot as plt

c = -1.3
# Step 1: Define the implicit function
def implicit_func(x, y, z):
    return np.sin(2*x)*np.cos(y)*np.sin(z) + np.sin(x)*np.sin(2*y)*np.cos(z) + np.cos(x)*np.sin(y)*np.sin(2*z) - np.cos(2*x)*np.cos(2*y) - np.cos(2*y)*np.cos(2*z) - np.cos(2*z)*np.cos(2*x) + c

# Step 2: Define the domain and resolution
x_min, x_max = -39.3, 39.3
y_min, y_max = -20, 20
resolution = 0.1

# Create a 2D grid for x and y
x = np.arange(x_min, x_max, resolution)
y = np.arange(y_min, y_max, resolution)
X, Y = np.meshgrid(x, y, indexing='ij')

# Fix the z-value
desired_z_value = -1.33  # Replace with your desired z-value

# Step 3: Evaluate the implicit equation on the 2D grid
F = implicit_func(X, Y, desired_z_value)

# Step 4: Threshold to determine filled and empty regions
volume_matrix_2d = np.zeros_like(F, dtype=int)
surface_threshold = 0.05  # Tolerance for the surface
volume_matrix_2d[F > 0] = 2  # Internal points
volume_matrix_2d[np.abs(F) < surface_threshold] = 2  # Surface points

# Step 5: Visualize the resulting 2D matrix
plt.imshow(volume_matrix_2d.T, cmap='gray', origin='lower', extent=(x_min, x_max, y_min, y_max))
# plt.title(f"2D Slice of the Volume Matrix at z = {desired_z_value}")
# plt.colorbar(label='0: Empty, 1: Filled')
# plt.xlabel("X-axis")
# plt.ylabel("Y-axis")
# plt.show()

matrix = volume_matrix_2d
# Print the dimensions of the resulting 2D slice
#print('nx:', len(matrix[0]))
#print('ny:', len(matrix[1]))

# Number of columns to add on the left and right
left_padding = int(0.2*len(matrix))
right_padding = int(0.2*len(matrix))

# Add zeros to the left and right
matrix = np.pad(matrix, ((left_padding, right_padding),(0, 0)), mode='constant', constant_values=0)

plt.imshow(matrix.T, cmap='gray', origin='lower', extent=(x_min, x_max, y_min, y_max))
# plt.title(f"2D Slice of the Volume Matrix at z = {desired_z_value}")
# plt.colorbar(label='0: Empty, 1: Filled')
# plt.xlabel("X-axis")
# plt.ylabel("Y-axis")
# plt.show()

# Pad the matrix to itself (concatenate left and right)
#rotated_matrix_cw = np.rot90(matrix, k=-2)  # Rotate 90 degrees clockwise
#extended_matrix = np.vstack((matrix, matrix[::-1], matrix))  # Duplicate the matrix left and right
#extended_matrix = np.vstack((matrix, matrix, matrix))
## Visualize the extended matrix
##plt.imshow(extended_matrix.T, cmap='gray', origin='lower')#, extent=(x_min, x_max, y_min, y_max))
##plt.title(f"Extended 2D Slice Padded with Itself at z = {desired_z_value}")
##plt.colorbar(label='0: Empty, 1: Filled')
##plt.xlabel("X-axis")
##plt.ylabel("Y-axis")
##plt.show()
#
## Print the dimensions of the extended matrix
#print('Extended dimensions:')
#print('nx:', len(extended_matrix))
#print('ny:', len(extended_matrix[0]))
#
## Number of columns to add on the left and right
#left_padding = 80
#right_padding = 80
#
## Add zeros to the left and right
#extended_matrix = np.pad(extended_matrix, ((left_padding, right_padding),(0, 0)), mode='constant', constant_values=0)
#
## Visualize the extended matrix
#plt.imshow(extended_matrix.T, cmap='gray', origin='lower')#, extent=(x_min, x_max, y_min, y_max))
#plt.title(f"Extended 2D Slice Padded with Itself at z = {desired_z_value}")
#plt.colorbar(label='0: Empty, 1: Filled')
#plt.xlabel("X-axis")
#plt.ylabel("Y-axis")
#plt.show()
#
#print('Extended dimensions:')
#print('nx:', len(extended_matrix))
#print('ny:', len(extended_matrix[0]))

print('nx:', len(matrix))
print('ny:', len(matrix[0]))


def surround_with_twos(matrix):
    # Create a padded version of the matrix to handle edge cases
    padded_matrix = np.pad(matrix, pad_width=1, mode='constant', constant_values=0)
    result_matrix = padded_matrix.copy()
    
    # Find all locations of 1s in the padded matrix
    rows, cols = np.where(padded_matrix == 1)
    
    # Surround each 1 with 2s
    for r, c in zip(rows, cols):
        # Iterate over the neighbors of the (r, c) position
        for dr in [-1, 0, 1]:
            for dc in [-1, 0, 1]:
                # Skip the center cell itself
                if dr == 0 and dc == 0:
                    continue
                # Set the neighbor cell to 2 if it's not already 1
                if result_matrix[r + dr, c + dc] == 0:
                    result_matrix[r + dr, c + dc] = 2
    
    # Remove the padding before returning
    return result_matrix[1:-1, 1:-1]

def plot_matrix(matrix):
    # Define a color map: 0 -> white, 1 -> black, 2 -> gray
    cmap = plt.cm.get_cmap('gray', 3)  # 3 distinct colors
    plt.imshow(matrix, cmap=cmap, interpolation='none')
    plt.colorbar(ticks=[0, 1, 2], label='Value')
    plt.title("Matrix Visualization")
    plt.show()

# if input('Adsorption?[y/n] ') == 'y':
#     matrix = surround_with_twos(matrix)

#plot_matrix(matrix.T)
plt.axis('off')
plt.savefig('TPMS.png', bbox_inches='tight', pad_inches=0, dpi=400)

np.save('geometry',matrix)