import numpy as np
from numpy import random
import matplotlib.pyplot as plt

#================================== Parameters - Beginning =================================================================

nx = 200 
ny = 200
porosity = 0.3          #porosity

allow_overlap = True
d_max = 10              #maxmimum distance between circles

r_min = 6               #minimum radius
r_max = 18              #maximum radius

#restriction zone
left_right_restriction = 0
top_bottom_restriction = 0

#================================== Parameters - End =================================================================

#===================================================================================================
#Generate particles
x_max = nx - 1
y_max = ny - 1

possible_x = np.linspace(0,nx,nx+1)
possible_y = np.linspace(0,ny,ny+1)

lattice = np.zeros((nx,ny))

area_total = nx*ny
area_circles = 0
possible_radius = np.linspace(r_min,r_max,(r_max+1)-r_min)

area_circles_max = area_total*porosity

n_kinds = (r_max+1)-r_min

circles_kinds = []
kinds_sizes = []
generated_circles = np.array([[0,0,0]])       #x_pos,y_pos,radius

def kinds():
    for i in range(n_kinds):
        circle_coords = []
        r = possible_radius[i]
        for x in range(-r_max,r_max+1):
            for y in range(-r_max,r_max+1):
                # Calculate distance from the center
                if x*x + y*y <= r*r:
                    circle_coords.append((x, y))

        circles_kinds.append(circle_coords)
        size = len(circle_coords)
        kinds_sizes.append(size)
    return

def is_not_overlaping(x,y,r):

    for cx, cy, cr in generated_circles:
        distance = np.sqrt((x - cx)**2 + (y - cy)**2)
        if distance - r - cr < d_max:
            return False
    return True


def generate_random_circles(max_attempts=10000):
    global area_circles, generated_circles
    attempt = 0
    while area_circles <= area_circles_max:

        x = random.choice(possible_x)
        y = random.choice(possible_y)
        r_kind = random.randint(0,n_kinds)
        r = possible_radius[r_kind]
        
        if is_not_overlaping(x,y,r) or allow_overlap:
            generated_circles = np.append(generated_circles,[[x,y,r]],axis=0)
            for x_,y_ in circles_kinds[r_kind]:
                
                x_new = int(x + x_)
                y_new = int(y + y_)

                if x_new >= 0 and x_new <= x_max and y_new >= 0 and y_new <= y_max:
                    if lattice[x_new,y_new] == 0:
                        lattice[x_new,y_new] = 2
                        area_circles = area_circles + 1
        attempt = attempt + 1
        if attempt == max_attempts:
            print('Reached maximum attempts')
            
            break
    return  print(f'Porosity: {round(area_circles/area_total*100,2)}%')

def add_restriction_zone(lattice):
    lattice[:left_right_restriction,:].fill(0)
    lattice[nx-left_right_restriction:,:].fill(0)
    lattice[:,:top_bottom_restriction].fill(0)
    lattice[:,ny-top_bottom_restriction:].fill(0)
    return 

kinds()

generate_random_circles(max_attempts=10000)

add_restriction_zone(lattice)

filename = 'geometry.npy'
np.save(filename,lattice)
print(f'Lattice saved as {filename}')

#===================================================================================================
#Plot lattice
plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('particle_geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()