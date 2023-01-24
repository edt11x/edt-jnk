import random

n = random.randint(1,10)

print "I am thinking of a number between 1 and 10"

running = True

while running:
    guess_string = input("Take a guess ")
    guess = int(guess_string)

    if guess == n:
        print "Well done!"
        running = False
    elif guess < n:
        print "Try a bigger number"
    else:
        print "Try a smaller number"
