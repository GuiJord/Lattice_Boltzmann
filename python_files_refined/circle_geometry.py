import numpy as np
import matplotlib.pyplot as plt

#================================== Parameters - Beginning =================================================================

#Lattice size
nx = 800
ny = 250

#Radius
radius = 20

#Center
center_x = nx // 4
center_y = ny // 2+5 

#================================== Parameters - End =================================================================

lattice = np.zeros((nx, ny), dtype=int)

#Put circle in lattice
for x in range(nx):
    for y in range(ny):
        if (x - center_x) ** 2 + (y - center_y) ** 2 <= radius ** 2:
            lattice[x, y] = 2

#Save lattice
filename = 'geometry.npy'
np.save(filename, lattice)
print(f'Lattice saved as {filename}')

#Save lattice figure
plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('circle_geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()