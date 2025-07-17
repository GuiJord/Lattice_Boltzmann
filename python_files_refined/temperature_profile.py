import numpy as np
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    data = np.loadtxt(file_path)

    T = data[:].astype(float)
    return T


file = 'temperature.dat'
T = interpret_dat_file(file)

ny = len(T)
y_coord = np.linspace(0,ny-1,ny)


#Analytical ==============================================
T_H = 1.5
T_C = 0.5
L = len(T)-1

y = np.linspace(0,L,10)

T_analytical = T_C + (T_H-T_C)/L*y
#======================================== Analytical - End

rate = 1

plt.figure(figsize=(8, 4))

plt.hlines(1.5,0,L,colors='lightcoral',ls='-',label='$T_H$')
plt.hlines(0.5,0,L,colors='paleturquoise',ls='-',label='$T_C$')

plt.plot(y_coord[::rate],T[::rate],label='LBM',color='r',ls='none',marker='o',markerfacecolor='none',markersize=5,zorder=2)
plt.plot(y,T_analytical,ls='-', label='Analytical',color='black',linewidth=1,zorder=1)

plt.yticks(np.linspace(0.5,1.5,5)) 
plt.ylabel('Temperature')
plt.xlabel('y coordinate')

plt.legend()
plt.tight_layout()
plt.savefig('temperature_profile.png',dpi=400)