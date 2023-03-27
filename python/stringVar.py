# stringVar.py

from Tkinter import *

root = Tk()
value = StringVar()
entry = Entry(root, textvariable=value)
entry.pack()

def get_value():
    print value.get()

def set_value():
    value.set("Hello World")

b = Button(root, text="Print Entry Value", command=get_value)
b.pack()

b = Button(root, text="Set Entry Value", command=set_value)
b.pack()

root.mainloop()

