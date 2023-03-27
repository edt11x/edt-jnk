import matplotlib.pyplot as plt
import pandas as pd

# Read CSV file into a pandas DataFrame
df = pd.read_csv('car_prices.csv')

# Extract columns for x and y axes
x = df['year']
y = df['price']

# Create a scatter plot
plt.scatter(x, y)

# Add labels and title
plt.xlabel('Year')
plt.ylabel('Price')
plt.title('Car Prices by Year')

# Show plot
plt.show()
