import tkinter as tk

def calculate_payment():
    # Get input values
    loan_amount = float(loan_entry.get())
    interest_rate = float(rate_entry.get()) / 100 / 12
    loan_term = int(term_entry.get()) * 12

    # Calculate monthly payment
    monthly_payment = (loan_amount * (interest_rate * (1 + interest_rate) ** loan_term)) / (((1 + interest_rate) ** loan_term) - 1)

    # Update label
    payment_label.config(text=f"Monthly payment: ${monthly_payment:.2f}")

# Create the main window
window = tk.Tk()
window.title("Car Loan Calculator")

# Create the loan amount label and entry
loan_label = tk.Label(window, text="Loan Amount:")
loan_label.pack()
loan_entry = tk.Entry(window)
loan_entry.pack()

# Create the interest rate label and entry
rate_label = tk.Label(window, text="Interest Rate (%):")
rate_label.pack()
rate_entry = tk.Entry(window)
rate_entry.pack()

# Create the loan term label and entry
term_label = tk.Label(window, text="Loan Term (years):")
term_label.pack()
term_entry = tk.Entry(window)
term_entry.pack()

# Create the calculate button
calculate_button = tk.Button(window, text="Calculate", command=calculate_payment)
calculate_button.pack()

# Create the payment label
payment_label = tk.Label(window, text="")
payment_label.pack()

# Run the main loop
window.mainloop()

