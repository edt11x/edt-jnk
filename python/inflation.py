import tkinter as tk
from datetime import datetime

def calculate_inflation():
    try:
        # Get input values
        start_date = datetime.strptime(start_date_entry.get(), "%Y-%m-%d")
        end_date = datetime.strptime(end_date_entry.get(), "%Y-%m-%d")
        start_price = float(start_price_entry.get())
        end_price = float(end_price_entry.get())

        # Calculate number of years
        years = (end_date - start_date).days / 365

        # Calculate average yearly inflation
        average_inflation = ((end_price / start_price) ** (1 / years)) - 1

        result_label.config(text=f"Average Yearly Inflation: {average_inflation:.2%}")
    except ValueError:
        result_label.config(text="Invalid input. Please enter valid values.")

# Create main window
root = tk.Tk()
root.title("Average Yearly Inflation Calculator")

# Create labels and entry widgets
start_date_label = tk.Label(root, text="Start Date (YYYY-MM-DD):")
start_date_entry = tk.Entry(root)

end_date_label = tk.Label(root, text="End Date (YYYY-MM-DD):")
end_date_entry = tk.Entry(root)

start_price_label = tk.Label(root, text="Start Price:")
start_price_entry = tk.Entry(root)

end_price_label = tk.Label(root, text="End Price:")
end_price_entry = tk.Entry(root)

result_label = tk.Label(root, text="")

# Create button to calculate inflation
calculate_button = tk.Button(root, text="Calculate Inflation", command=calculate_inflation)

# Arrange widgets in grid
start_date_label.grid(row=0, column=0, padx=10, pady=5, sticky="e")
start_date_entry.grid(row=0, column=1, padx=10, pady=5)

end_date_label.grid(row=1, column=0, padx=10, pady=5, sticky="e")
end_date_entry.grid(row=1, column=1, padx=10, pady=5)

start_price_label.grid(row=2, column=0, padx=10, pady=5, sticky="e")
start_price_entry.grid(row=2, column=1, padx=10, pady=5)

end_price_label.grid(row=3, column=0, padx=10, pady=5, sticky="e")
end_price_entry.grid(row=3, column=1, padx=10, pady=5)

calculate_button.grid(row=4, column=0, columnspan=2, pady=10)

result_label.grid(row=5, column=0, columnspan=2)

# Run the Tkinter event loop
root.mainloop()

