import tkinter as tk
from tkinter import messagebox

def calculate_interest():
    principal = float(principal_entry.get())
    rate = float(rate_entry.get())
    time = float(time_entry.get())
    
    interest = (principal * rate * time) / 100
    total_amount = principal + interest
    
    result_label.config(text=f"Total amount after one year: ${total_amount:.2f}")

# Create the main window
root = tk.Tk()
root.title("Simple Interest Calculator")

# Create and place widgets
principal_label = tk.Label(root, text="Principal amount:")
principal_label.pack()

principal_entry = tk.Entry(root)
principal_entry.pack()

rate_label = tk.Label(root, text="Interest rate (%):")
rate_label.pack()

rate_entry = tk.Entry(root)
rate_entry.pack()

time_label = tk.Label(root, text="Time (years):")
time_label.pack()

time_entry = tk.Entry(root)
time_entry.pack()

calculate_button = tk.Button(root, text="Calculate", command=calculate_interest)
calculate_button.pack()

result_label = tk.Label(root, text="")
result_label.pack()

# Start the Tkinter main loop
root.mainloop()
