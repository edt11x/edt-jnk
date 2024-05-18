import tkinter as tk

def calculate_inflation():
    try:
        year1 = int(year1_entry.get())
        price1 = float(price1_entry.get())
        year2 = int(year2_entry.get())
        price2 = float(price2_entry.get())

        inflation = ((price2 - price1) / price1) * 100

        result_label.config(text=f"Inflation between {year1} and {year2}: {inflation:.2f}%")
    except ValueError:
        result_label.config(text="Invalid input. Please enter valid numbers.")

# Create a GUI window
window = tk.Tk()
window.title("Inflation Calculator")

# Labels and Entry fields for year and price
year1_label = tk.Label(window, text="Year 1:")
year1_label.pack()
year1_entry = tk.Entry(window)
year1_entry.pack()

price1_label = tk.Label(window, text="Price 1:")
price1_label.pack()
price1_entry = tk.Entry(window)
price1_entry.pack()

year2_label = tk.Label(window, text="Year 2:")
year2_label.pack()
year2_entry = tk.Entry(window)
year2_entry.pack()

price2_label = tk.Label(window, text="Price 2:")
price2_label.pack()
price2_entry = tk.Entry(window)
price2_entry.pack()

# Button to calculate inflation
calculate_button = tk.Button(window, text="Calculate Inflation", command=calculate_inflation)
calculate_button.pack()

# Label to display the result
result_label = tk.Label(window, text="")
result_label.pack()

# Start the GUI event loop
window.mainloop()

