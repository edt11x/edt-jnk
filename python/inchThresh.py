# File: displacement.py

from Tkinter import *
import Tkinter as ttk
import math


def calculate(*args):
    global decoded
    global inchThresh

    try:
        thisThresh = StringVar()
        thisThresh = int(inchThresh.get(), 16) & 0xFFFC
        payload = (thisThresh >> 3) & 0x3f
        header = (thisThresh >> 9)  & 0x1f
        decoded.set("H %d, P %d" % (header, payload))
    except ValueError:
        print "ValueError Failure"
        pass

class inchThresh:
        
    def __init__(self, master):

        global inchThresh
        global decoded

        inchThresh = StringVar()
        decoded = StringVar()

        master.title("INCH Thresholds")
        mainframe = ttk.Frame(master)
        mainframe.grid(column=0, row=0, sticky=(N, W, E, S))
        mainframe.columnconfigure(0, weight=1)
        mainframe.rowconfigure(0, weight=1)

        reg_entry = ttk.Entry(mainframe, width=7, textvariable=inchThresh)
        reg_entry.grid(column=2, row=1, sticky=(W, E))

        ttk.Label(mainframe, textvariable=decoded).grid(column=2, row=2, sticky=(W, E))
        ttk.Button(mainframe, text="Calculate", command=calculate).grid(column=1, row=2, sticky=E)
        ttk.Label(mainframe, text="Register Value").grid(column=1, row=1, sticky=W)

        for child in mainframe.winfo_children(): child.grid_configure(padx=5, pady=2)

        reg_entry.focus()

root = Tk()
app = inchThresh(root)
root.bind('<Return>', calculate)
root.mainloop()


