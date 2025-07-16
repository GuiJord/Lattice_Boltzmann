import numpy as np
import matplotlib.pyplot as plt

#================================== Parameters - Beginning =================================================================

nx = 200*10
ny = 100*10
d = 10*10
l = 20*10
tol = 0

def curve(x):
    # f = 0.5*x
    # f = np.inf
    # f = 5*np.sqrt(x)
    # f = x**2
    # f = x**1.3
    # f = 0.015*x**2
    # f = np.exp(0.195*x-6)
    f = np.sqrt(1+x**2/15)
    #f = np.sqrt(1+x**2/10)*np.sin(x/100)
    return f

#================================== Parameters - End =================================================================

#================================== Functions - Beginning =================================================================

def area_under_curve(x,y):
    if y - curve(x) >= tol:
        return True
    else:
        return False

def area_definition():
    y_last = 0
    for x in range(nx_half):
        while True:
            if area_under_curve(x,y_last):
                one_forth_lattice[x,y_last:] = 1
                break
            else:
                y_last += 1
    return

#================================== Functions - End =================================================================

#===================================================================================================
#Symmetry generation
nx_half = nx//2
ny_half = ny//2

one_forth_lattice = np.zeros((nx_half,ny_half),dtype=int)

area_definition()

middle_perpendicular = np.ones((l,ny_half),dtype=int)

top_half_lattice = np.vstack((one_forth_lattice[::-1],middle_perpendicular,one_forth_lattice))

middle_paralel = np.zeros((nx+l,d),dtype=int)

lattice = np.hstack((top_half_lattice[:,::-1],middle_paralel,top_half_lattice))

#===================================================================================================
#Save geometry
filename = "channel_geometry.dat"
np.savetxt(f'{filename}',lattice, fmt="%d")
print(f'Lattice saved as {filename}')

#===================================================================================================
#Plot lattice
plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('channel_geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()