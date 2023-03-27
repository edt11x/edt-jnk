# File: displacement.py

from Tkinter import *
import Tkinter as ttk
import math


def calculate(*args):
    global bore
    global stroke
    global cylinders
    global displacement_cc
    global displacement_ci

    try:
        thisBore = StringVar()
        thisBore = float(bore.get())
        displacement_cc.set("%6.2f" % (thisBore * thisBore * math.pi * float(stroke.get()) * float(cylinders.get()) / (4.0 * 1000.0)))
    except ValueError:
        print "ValueError Failure"
        pass

class Displacement:
        
    def __init__(self, master):

        global bore
        global stroke
        global cylinders
        global displacement_cc

        bore = StringVar()
        stroke = StringVar()
        cylinders = StringVar()
        displacement_cc = StringVar()

        master.title("Displacement")
        mainframe = ttk.Frame(master)
        mainframe.grid(column=0, row=0, sticky=(N, W, E, S))
        mainframe.columnconfigure(0, weight=1)
        mainframe.rowconfigure(0, weight=1)

        bore_entry = ttk.Entry(mainframe, width=7, textvariable=bore)
        stroke_entry = ttk.Entry(mainframe, width=7, textvariable=stroke)
        cylinder_entry = ttk.Entry(mainframe, width=7, textvariable=cylinders)

        bore_entry.grid(column=2, row=1, sticky=(W, E))
        stroke_entry.grid(column=2, row=2, sticky=(W, E))
        cylinder_entry.grid(column=2, row=3, sticky=(W, E))

        ttk.Label(mainframe, textvariable=displacement_cc).grid(column=2, row=4, sticky=(W, E))
        ttk.Button(mainframe, text="Calculate", command=calculate).grid(column=1, row=4, sticky=E)

        ttk.Label(mainframe, text="Bore").grid(column=1, row=1, sticky=W)
        ttk.Label(mainframe, text="Stroke").grid(column=1, row=2, sticky=W)
        ttk.Label(mainframe, text="Cylinders").grid(column=1, row=3, sticky=W)

        ttk.Label(mainframe, text="mm").grid(column=3, row=1, sticky=E)
        ttk.Label(mainframe, text="mm").grid(column=3, row=2, sticky=E)
        ttk.Label(mainframe, text="#").grid(column=3, row=3, sticky=E)
        ttk.Label(mainframe, text="cc").grid(column=3, row=4, sticky=E)

        for child in mainframe.winfo_children(): child.grid_configure(padx=5, pady=2)

        bore_entry.focus()

root = Tk()

app = Displacement(root)

root.mainloop()


