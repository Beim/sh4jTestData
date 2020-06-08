import numpy as np
import matplotlib.pyplot as plt

x = [1, 3, 5, 7, 10, 15]

# gpu
# y1 = [12, 11, 12, 17, 19, 25]
# y2 = [10, 11, 13, 15, 17, 23]
# y3 = [14, 13, 17, 20, 24, 35]

# cpu
y1 = [46, 68, 78, 81, 170, 215]
y2 = [27, 49, 74, 105, 155, 248]
y3 = [83, 95, 117, 161, 251, 443]

plt.figure()
plt.plot(x, y1)
plt.plot(x, y2, "--")
plt.plot(x, y3, ":")
plt.xlabel("Triples(k)")
plt.ylabel("Time(s)")
plt.show()
