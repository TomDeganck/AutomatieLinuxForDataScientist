import pandas as pd
import matplotlib.pyplot as plt

# Read CSV data into a DataFrame
data = pd.read_csv('../data_storage/output.csv')

# Convert the 'Tijdstip' column to datetime format
data['Tijdstip'] = pd.to_datetime(data['Tijdstip'], format='%Y-%m-%d %H:%M')

# Plot temperature evolution over time
plt.figure(figsize=(12, 6))
plt.plot(data['Tijdstip'], data['Temperatuur_C'], label='Temperature (°C)')
plt.title('Temperature Evolution Over Time')
plt.xlabel('Time')
plt.ylabel('Temperature (°C)')
plt.legend()
plt.grid(True)

# Save the plot as a PNG file
plt.savefig('temperature_evolution.png')

# Show the plot
plt.show()
