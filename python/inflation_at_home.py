import tkinter as tk

def calculate_inflation():
    try:
        year1 = int(year1_entry.get())
        price1 = float(price1_entry.get())
        year2 = int(year2_entry.get())
        price2 = float(price2_entry.get())

        years_diff = year2 - year1
        total_inflation = ((price2 - price1) / price1) * 100
        average_yearly_inflation = total_inflation / years_diff if years_diff > 0 else 0

        result_label_total.config(text=f"Total inflation: {total_inflation:.2f}%")
        result_label_average.config(text=f"Average yearly inflation: {average_yearly_inflation:.2f}%")
    except ValueError:
        result_label_total.config(text="Invalid input. Please enter valid numbers.")

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

# Labels to display the results
result_label_total = tk.Label(window, text="")
result_label_total.pack()

result_label_average = tk.Label(window, text="")
result_label_average.pack()

# Start the GUI event loop
window.mainloop()

