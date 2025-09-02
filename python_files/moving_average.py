import numpy as np
import matplotlib.pyplot as plt

# Define the file path (replace with your file path)
file_path = './tortuosity.dat'

# Read the .dat file
data = np.genfromtxt(file_path, dtype=None, encoding=None, names=["Index", "Value1", "Value2"])

# Handle "Infinity" by replacing it with np.nan
data['Value2'] = np.where(data['Value2'] == 'Infinity', np.nan, data['Value2']).astype(float)
# Create a numpy array with each column as a separate row
data = np.array([data['Index'], data['Value1'], data['Value2']])

time_steps = data[0]
tortuosity = data[1]
error = data[2]

def moving_average(data_set,k):
    data_set = data_set[::-1]
    n = len(data_set)
    data_smoothed = np.array([])
    for j in range(0,n-k+1):
        avg = 0
        for i in range(j,j+k):
            avg = avg + data_set[i]
        avg = avg/k
        data_smoothed = np.append(data_smoothed,avg)
    return data_smoothed[::-1]

factor = 20000

tortuosity_smoothed = moving_average(tortuosity,factor) 
error_smoothed = moving_average(error,factor)

print(len(tortuosity_smoothed))
print(len(time_steps[factor-1:]))
array = np.array([time_steps[factor-1:],tortuosity_smoothed,error_smoothed])

np.savetxt("data_smoothed.dat", array.T,fmt=["%d","%.5f","%.3e"])
#
#plt.plot(array[0,1000:],array[2,1000:],ls='-')
#plt.savefig('smoothing_error1.png')
#plt.close()