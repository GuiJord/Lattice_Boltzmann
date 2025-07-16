import numpy as np
import matplotlib.pyplot as plt

#================================== Parameters - Beginning =================================================================

nx = 10
ny = 10

L = 0

lattice = np.zeros((nx,ny))

# lattice[:,0:ny//2-L] = 2
# lattice[:,ny//2-L:ny//2+1-L] = 3

# lattice[:,ny//2+L:ny] = 2
# lattice[:,ny//2+L-1:ny//2+L] = 3

lattice[:,0] = 2
lattice[:,1] = 3

lattice[:,-1] = 2
lattice[:,-2] = 3

#================================== Parameters - End =================================================================

filename = 'geometry.npy'
np.save(filename, lattice)
print(f'Lattice saved as {filename}')

plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('simple_geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()