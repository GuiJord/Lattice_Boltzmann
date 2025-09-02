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

plt.xlabel('time step',fontsize=14)
plt.ylabel('concentration',fontsize=14)
plt.legend()
plt.tight_layout()
plt.savefig('conservation_plot.png',dpi=400)
plt.close()