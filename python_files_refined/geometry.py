import numpy as np
import matplotlib.pyplot as plt

#===================================================================================================

lattice = np.load('geometry.npy')     #2D matrix file with values 0 (fluid), 1 (solid), 2 (adsorption)

nx = len(lattice)                     #lattice length on the x direction
ny = len(lattice[0])                  #lattice length on the y direction

#===================================================================================================

mask_solid_x = np.array([],dtype=int)   #array with the x coordinates of solid points
mask_solid_y = np.array([],dtype=int)   #array with the y coordinates of solid points

mask_ads_x = np.array([],dtype=int)     #array with the x coordinates of adsorption points 
mask_ads_y = np.array([],dtype=int)     #array with the y coordinates of adsorption points

mask_ads_frontier_x = np.array([],dtype=int)    #array with the x coordinates of frontier points 
mask_ads_frontier_y = np.array([],dtype=int)    #array with the y coordinates of frontier points 

#===================================================================================================
#Loops the array to classify points into each category
for x in range(nx):
    for y in range(ny):
        if lattice[x,y] == 1:
            mask_solid_x = np.append(mask_solid_x,x+1)
            mask_solid_y = np.append(mask_solid_y,y+1)   
        elif lattice[x,y] == 2:
            mask_ads_x = np.append(mask_ads_x,x+1)
            mask_ads_y = np.append(mask_ads_y,y+1)
            #if the frontier between adsorption reagion and fluid is not defined, this will check it
            for i in [-1,0,1]:
                for j in [-1,0,1]:
                    x_new = x + i
                    y_new = y + j
                    if x_new >= 0 and y_new >= 0 and x_new < nx and y_new < ny:
                        if lattice[x_new,y_new] == 0:
                            lattice[x_new,y_new] = 3
                            mask_ads_frontier_x = np.append(mask_ads_frontier_x,x_new+1)
                            mask_ads_frontier_y = np.append(mask_ads_frontier_y,y_new+1)


#Get the number of adsorption neighbors ==============================================
ex = [1,0,-1,0,1,-1,-1,1]
ey = [0,1,0,-1,1,1,-1,-1]

num_neighb_ads_list = np.array([],dtype=int) #array listing the number of adsorption points neighboring each frontier point

for i in range(len(mask_ads_frontier_x)):
    x = mask_ads_frontier_x[i] - 1 
    y = mask_ads_frontier_y[i] - 1
    n_neighb_ads = 0
    for dir in range(8):
        x_new = x + ex[dir]
        y_new = y + ey[dir]
        if x_new >= 0 and y_new >= 0 and x_new < nx and y_new < ny:
            if lattice[x_new,y_new] == 2:
                n_neighb_ads = n_neighb_ads + 1
    num_neighb_ads_list = np.append(num_neighb_ads_list,n_neighb_ads)
#======================================== Get the number of adsorption neighbors - End


        

#===================================================================================================

lattice_solid_mask = np.array([mask_solid_x,mask_solid_y])                      #solid coordinates
lattice_ads_mask = np.array([mask_ads_x,mask_ads_y])                            #adsorption coordinates
lattice_ads_frontier_mask = np.array([mask_ads_frontier_x,mask_ads_frontier_y,num_neighb_ads_list]) #frontier coordinates

#===================================================================================================

#Save data
np.savetxt("geometry.dat", lattice, fmt="%d")                       
np.savetxt('geometry_solid_xy.dat', lattice_solid_mask.T, fmt="%d")
np.savetxt('geometry_ads_xy.dat', lattice_ads_mask.T, fmt="%d")
np.savetxt('geometry_ads_frontier_xy.dat', lattice_ads_frontier_mask.T, fmt="%d")

#===================================================================================================

#Specify the lattice size
new_line = f"{nx} {ny}\n"
with open("geometry.dat", "r") as file:
    content = file.read()
with open("geometry.dat", "w") as file:
    file.write(new_line + content)


#Specify the number of solid points
new_line = f"{len(mask_solid_x)}\n"
with open("geometry_solid_xy.dat", "r") as file:
    content = file.read()
with open("geometry_solid_xy.dat", "w") as file:
    file.write(new_line + content)

#Specify the number of adsorption points
new_line = f"{len(mask_ads_x)}\n"
with open("geometry_ads_xy.dat", "r") as file:
    content = file.read()
with open("geometry_ads_xy.dat", "w") as file:
    file.write(new_line + content)

#Specify the number of frontier points
new_line = f"{len(mask_ads_frontier_x)}\n"
with open("geometry_ads_frontier_xy.dat", "r") as file:
    content = file.read()
with open("geometry_ads_frontier_xy.dat", "w") as file:
    file.write(new_line + content)

#===================================================================================================
#Plot geometry
plt.figure(figsize=(10, 10*(ny/nx)))
plt.imshow(lattice.T, cmap='gray', origin='upper')
plt.axis('off')
plt.savefig('geometry.png', bbox_inches='tight', pad_inches=0)
plt.close()