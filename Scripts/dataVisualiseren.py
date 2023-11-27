import time
from matplotlib.patches import Rectangle
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as m
import numpy as np
import os


# Read CSV data into a DataFrame
path = os.getcwd()

data = pd.read_csv(path + "/data_storage/output.csv")

# Convert the 'Tijdstip' column to datetime format
data['Tijdstip'] = pd.to_datetime(data['tijdstip'], format='%Y-%m-%d %H:%M')
 
# Plot temperature evolution over time
plt.figure(figsize=(12, 6))
plt.plot(data['Tijdstip'], data['Temperatuur_C'], label='Temperature (°C)')
plt.plot(data['Tijdstip'], data['Gevoelstemperatuur_C'], label='Touch Temperature (°C)')
plt.plot(data['Tijdstip'], data['Vochtigheid'], label='Vochtigheid')
plt.plot(data['Tijdstip'], data['Windsnelheid_kph'], label='Windsnelheid (Km/H)')

start_idx = 0
for i in range(1, len(data['Dag'])):
    if data['Dag'].iloc[i] != data['Dag'].iloc[i - 1]:
        rect_color = 'black' if data['Dag'].iloc[i - 1] == 0 else 'white'
        rect = Rectangle((data['Tijdstip'].iloc[start_idx], plt.ylim()[0]),
                         data['Tijdstip'].iloc[i] - data['Tijdstip'].iloc[start_idx],
                         plt.ylim()[1] - plt.ylim()[0], facecolor=rect_color, alpha=0.5)
        plt.gca().add_patch(rect)
        start_idx = i
# Add the last shaded region if the last segment ends with 1
if data['Dag'].iloc[-1] == 1:
    rect_color = 'white'
    rect = Rectangle((data['Tijdstip'].iloc[start_idx], plt.ylim()[0]),
                     data['Tijdstip'].iloc[-1] - data['Tijdstip'].iloc[start_idx],
                     plt.ylim()[1] - plt.ylim()[0], facecolor=rect_color, alpha=0.5)
    plt.gca().add_patch(rect)

plt.title('Temperature Evolution Over Time')
plt.xlabel('Time')
plt.ylabel('Temperature (°C)')
plt.legend()
plt.grid(True)

plt.savefig(f'../images/{time.time()}dataGrafiek.png')

