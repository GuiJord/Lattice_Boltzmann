import numpy as np
import matplotlib.pyplot as plt

#================================== Parameters - Beginning =================================================================

nx = 50
ny = 50

L = 10

lattice = np.zeros((nx,ny))

lattice[:,0:ny//2-L] = 2
lattice[:,ny//2+L:ny] = 2

# lattice[:,0] = 2
# lattice[:,-1] = 2

#================================== Parameters - End =================================================================

filename = 'geometry.npy'
np.save(filename, lattice)
print(f'Lattice saved as {filename}')

plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('simple_geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()