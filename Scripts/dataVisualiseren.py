import time
from matplotlib.patches import Rectangle
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as m
import numpy as np
import os
import pathlib

path = os.getcwd()
data = pd.read_csv(path + "/data_storage/output.csv")

data['Tijdstip'] = pd.to_datetime(data['tijdstip'], format='%Y-%m-%d %H:%M')
 
plt.figure(figsize=(12, 6))
plt.plot(data['Tijdstip'], data['Temperatuur_C'], label='Temperature (°C)')
plt.plot(data['Tijdstip'], data['Gevoelstemperatuur_C'], label='Touch Temperature (°C)')
plt.plot(data['Tijdstip'], data['Vochtigheid'], label='Vochtigheid')
plt.plot(data['Tijdstip'], data['Windsnelheid_kph'], label='Windsnelheid (Km/H)')

start_idx = 0

plt.title('Temperature Evolution Over Time')
plt.xlabel('Time')
plt.ylabel('Temperature (°C)')
plt.legend()
plt.grid(True)

try:
    os.rename(f'{path}/images/dataGrafiek.png',f'{path}/images/{time.time()}dataGrafiek.png')
except:
    print("niet kunnen hernoemen")
plt.savefig(f'{path}/images/dataGrafiek.png')

