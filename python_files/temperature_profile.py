import numpy as np
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    data = np.loadtxt(file_path)

    time_steps = data[:,0].astype(int)
    T = data[:,1:].astype(float)
    return time_steps,T


file = 'temperature.dat'

rate = 8

time_steps,T = interpret_dat_file(file)

n_profiles = len(time_steps)
ny = len(T[0,:])
y_coord = np.linspace(0,ny-1,ny)

colors = plt.cm.Blues(np.linspace(0.2, 1.25, n_profiles))

plt.figure(figsize=(10, 10))
for i in range(0,n_profiles,rate):
    plt.plot(y_coord,T[i,:],color=colors[i],ls='-',marker='none',markersize=5,zorder=3)


file = 'temperature1.dat'

rate = 8

time_steps,T = interpret_dat_file(file)

n_profiles = len(time_steps)
ny = len(T[0,:])
y_coord = np.linspace(0,ny-1,ny)

colors = plt.cm.Reds(np.linspace(0.2, 1.25, n_profiles))


for i in range(0,n_profiles,rate):
    plt.plot(y_coord,T[i,:],color=colors[i],ls='--',marker='none',markersize=5,zorder=3)

plt.ylabel('Temperature',fontsize=14)
plt.xlabel('y coordinate',fontsize=14)

# plt.title('Rattle Effect Impact',fontsize=14)

plt.tight_layout()
plt.savefig('temperature_profile.png',dpi=400)

# file = 'temperature2.dat'

# time_steps,T = interpret_dat_file(file)

# n_profiles = len(time_steps)
# ny = len(T[0,:])
# y_coord = np.linspace(0,ny-1,ny)

# colors = plt.cm.YlGn(np.linspace(0.2, 1.25, n_profiles))


# for i in range(n_profiles):
#     plt.plot(y_coord,T[i,:],label=f'rattle (lin) {i}',color=colors[i],ls=':',zorder=4,lw=3)


# if legend_cmd:
#     plt.legend()
# plt.title(title+'temperature profile')


# file = 'temperature3.dat'

# time_steps,T = interpret_dat_file(file)

# n_profiles = len(time_steps)
# ny = len(T[0,:])
# y_coord = np.linspace(0,ny-1,ny)

# colors = plt.cm.Reds(np.linspace(0.2, 1.25, n_profiles))


# for i in range(n_profiles):
#     plt.plot(y_coord,T[i,:],label=f'rattle (exp) {i}',color=colors[i],ls='--',zorder=4)











# file = 'concentration.dat'

# time_steps,C = interpret_dat_file(file)

# n_profiles = len(time_steps)
# ny = len(C[0,:])
# y_coord = np.linspace(0,ny-1,ny)

# colors = plt.cm.viridis(np.linspace(0, 1, n_profiles))

# plt.figure(figsize=(10, 10))
# for i in range(n_profiles):
#     plt.plot(y_coord,C[i,:],label=f'{i}',color=colors[i],ls='-',zorder=3)

# plt.ylabel('Concentration')
# plt.xlabel('y coordinate')
# if legend_cmd:
#     plt.legend()
# plt.title(title+'concentration profile')
# plt.savefig('concentration_profile.png',dpi=100, bbox_inches='tight', pad_inches=0.25)

# file = 'conductivity1.dat'

# time_steps,K = interpret_dat_file(file)

# n_profiles = len(time_steps)
# ny = len(K[0,:])
# y_coord = np.linspace(0,ny-1,ny)

# colors = plt.cm.spring(np.linspace(0, 1, n_profiles))

# plt.figure(figsize=(10, 10))
# for i in range(n_profiles):
#     plt.plot(y_coord,K[i,:],label=f'no rattle {i}',color=colors[i],ls='-',zorder=2)

# file = 'conductivity2.dat'

# time_steps,K = interpret_dat_file(file)

# n_profiles = len(time_steps)
# ny = len(K[0,:])
# y_coord = np.linspace(0,ny-1,ny)

# colors = plt.cm.spring(np.linspace(0, 1, n_profiles))


# for i in range(n_profiles):
#     plt.plot(y_coord,K[i,:],label=f'rattle {i}',color=colors[i],ls='--',zorder=3)

# plt.ylabel('Thermal diffusivity')
# plt.xlabel('y coordinate')
# if legend_cmd:
#     plt.legend()#loc='upper center', bbox_to_anchor=(0.5, -0.1), ncol=5)
# plt.title(title+'thermal diffusivity profile')

# plt.savefig('conductivity_profile.png',dpi=100, bbox_inches='tight', pad_inches=0.25)



# x = y_coord
# y = time_steps

# X, Y = np.meshgrid(x, y)

# z = C

# Z = z.reshape((len(y), len(x)))

# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')

# # Plot surface
# surf = ax.plot_surface(X, Y, Z, cmap='inferno', edgecolor='none')

# # Add color bar
# fig.colorbar(surf, ax=ax, shrink=0.5, aspect=10)

# # Labels
# ax.set_title("3D Surface Plot")
# ax.set_xlabel("y coord")
# ax.set_ylabel("time")
# ax.set_zlabel("Temperature")

# # Change orientation
# ax.view_init(elev=20, azim=-45)  # You can adjust these numbers

# plt.savefig('3Dplot.png',dpi=100, bbox_inches='tight', pad_inches=0.25)