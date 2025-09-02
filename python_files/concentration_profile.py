import numpy as np
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    data = np.loadtxt(file_path)

    time_steps = data[:,0].astype(int)
    C = data[:,1:].astype(float)

    return time_steps, C


file = 'concentration.dat'
time_steps,C = interpret_dat_file(file)

n_profiles = len(time_steps)
ny = len(C[0,:])
y_coord = np.linspace(0,ny-1,ny)

colors = plt.cm.viridis(np.linspace(0, 1, n_profiles))

rate = 8

plt.figure(figsize=(10, 10))
for i in range(0,n_profiles,rate):
    plt.plot(y_coord,C[i,:],label=f'{i}',color=colors[i],ls='-',marker='o',markersize=5,zorder=3)

plt.ylabel('Concentration',fontsize=14)
plt.xlabel('y coordinate',fontsize=14)
plt.tight_layout()

plt.savefig('concentration_profile.png',dpi=400)