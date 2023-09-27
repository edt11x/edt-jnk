import tkinter as tk

# Create the main application window
root = tk.Tk()
root.title("Network Map")

# Create a canvas widget to draw the network
canvas = tk.Canvas(root, width=800, height=600)
canvas.pack()

# Function to create a node on the canvas
def create_node(x, y):
    canvas.create_oval(x - 20, y - 20, x + 20, y + 20, fill="blue")
    canvas.create_text(x, y, text="Node")

# Function to create an edge between two nodes
def create_edge(start_node, end_node):
    x1, y1, x2, y2 = canvas.coords(start_node)  # Get coordinates of the start node
    x3, y3, x4, y4 = canvas.coords(end_node)    # Get coordinates of the end node
    canvas.create_line(x1, y1, x3, y3, fill="black")  # Create a line between the nodes

# Create nodes
node1 = create_node(100, 100)
node2 = create_node(200, 200)
node3 = create_node(300, 300)

# Create edges between nodes
create_edge(node1, node2)
# create_edge(node2, node3)
# create_edge(node3, node1)

# Main loop to run the Tkinter application
root.mainloop()

