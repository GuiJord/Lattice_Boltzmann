import numpy as np
import matplotlib.pyplot as plt


def interpret_dat_file(file_path):
    data = np.loadtxt(file_path)

    time_steps = data[:, 0].astype(int)
    C_local = data[:, 1].astype(float)
    C_ads_local = data[:, 2].astype(float)

    return time_steps,C_local,C_ads_local

file_path = 'adsorption.dat'
time_steps,C_local,C_ads_local = interpret_dat_file(file_path)

k_a = 0.01
k_d = 0.001
k = k_a/k_d

C_inf = 1

C_henry = C_inf*k_a/k_d*(1-np.exp(-k_d*time_steps))
C_langmuir = C_inf*k/(1+k)*(1-np.exp(-k_d*(1+k)*time_steps))

# plt.figure(figsize=(8, 6),dpi=100)
# plt.plot(time_steps[::rate],rho_a_local[::rate],label='LBM',marker='o',markersize=5,color='r',ls='',markerfacecolor='none',zorder=3)


plt.plot(time_steps,C_local,label='free',color='orangered',ls='-',zorder=1)
plt.plot(time_steps,C_ads_local,label='ads',color='dodgerblue',ls='-',zorder=1)
# plt.plot(time_steps,C_henry,ls=':', label='Analytical',color='black',linewidth=1,zorder=2)

rate = 2
# plt.plot(time_steps[::rate],C_henry[::rate],label='Analytical',marker='o',markersize=5,color='black',ls='',markerfacecolor='none',zorder=2)
plt.plot(time_steps[::rate],C_langmuir[::rate],label='Analytical',marker='o',markersize=5,color='black',ls='',markerfacecolor='none',zorder=2)
#plt.plot(time_steps,C_langmuir,ls=':', label='Analytical',color='black',linewidth=1,zorder=2)


plt.xlabel('time step', fontsize=12)
plt.ylabel('concentration', fontsize=12)

plt.xscale('log')

plt.legend()
plt.tight_layout()
plt.savefig('adsorption_plot.png',dpi=400)
plt.close()