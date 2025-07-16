import numpy as np
import matplotlib.pyplot as plt


def interpret_dat_file(file_path):
    data = np.loadtxt(file_path)

    time_steps = data[:, 0].astype(int)
    C_total = data[:, 1].astype(float)
    C_ads = data[:, 2].astype(float)
    C_free = data[:, 3].astype(float)

    return time_steps,C_total,C_ads,C_free

file_path = 'conservation.dat'
time_steps,C_total, C_ads, C_free = interpret_dat_file(file_path)

plt.plot(time_steps,C_free,label='free',color='orangered',ls='-',zorder=3)
plt.plot(time_steps,C_ads,label='ads',color='dodgerblue',ls='-',zorder=3)
plt.plot(time_steps,C_total,label='total',color='lime',ls='-',zorder=3)

plt.xlabel('time step', fontsize=12)
plt.ylabel('concentration', fontsize=12)
plt.legend()
plt.tight_layout()
plt.savefig('conservation_plot.png',dpi=400)
plt.close()











# k_a = 0.1
# k_d = 0.01
# k = k_a/k_d

# C_inf = 1

# rho_a_bm = C_inf*k_a/k_d*(1-np.exp(-k_d*time_steps))

# #rho_a_bm = k/(1+k)*(1-np.exp(-k_d*(1+k)*time_steps))
# #rho_a_bm_sum = rho_a_bm*2*100


# rate = 5000
# # Plotting the graph
# plt.figure(figsize=(8, 6),dpi=100)
# # plt.plot(time_steps,C_a,label='LBM',marker='s',markersize=5,color='r',ls='',markerfacecolor='none',zorder=3)
# # plt.plot(time_steps,C,label='LBM',marker='o',markersize=5,color='blue',ls='',markerfacecolor='blue',zorder=3)

# plt.plot(time_steps,C_free,label='free',color='r',ls='-',zorder=3)
# plt.plot(time_steps,C_ads,label='ads',color='blue',ls='-',zorder=3)
# plt.plot(time_steps,C_total,label='total',color='green',ls='-',zorder=3)

# #plt.plot(time_steps,rho_a_local,ls='-', label='LBM',color='r',linewidth=2,zorder=2)
# #plt.plot(time_steps,rho_a_bm,ls='-', label='Analytical',color='black',linewidth=1,zorder=2)
# plt.title('Local Adsorbed Density vs Time Steps', fontsize=14)
# plt.xlabel('Time Steps', fontsize=14)
# plt.ylabel('Adsorbed Density', fontsize=14)
# #plt.xscale('log')
# #plt.yscale('log')
# # Adding a grid
# #plt.grid(True, which='both', linestyle='--', linewidth=0.5,zorder=0)

# # Show the plot






# plt.figure(figsize=(8, 6),dpi=100)
# plt.plot(time_steps, rho_a_sum, label='Adsorbed', color='r')
# plt.plot(time_steps, rho_sum, label='Free', color='b')
# plt.plot(time_steps, rho_total, label='Total', color='orange')
# #plt.plot(time_steps,rho_a_bm_sum,ls=':', label=r'$\rho^\infty$',color='black',linewidth=1.5,zorder=2)

# plt.title('Density vs Time Steps', fontsize=14)
# plt.xlabel('Time Steps', fontsize=14)
# plt.ylabel('Density', fontsize=14)

# #plt.xscale('log')
# #plt.yscale('log')

# # Adding a grid
# plt.grid(True, which='both', linestyle='--', linewidth=0.5,zorder=0)

# # Show the plot
# plt.legend()

# plt.savefig('test_'+f'{test}'+f'/Adsorption plot',dpi=300)
# plt.show()
# plt.close()