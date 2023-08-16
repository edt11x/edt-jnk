#!/usr/bin/env python
import random
import string

def generate_password(base_word, length=12):
    # Ensure the generated password is at least as long as the base word
    if length < len(base_word):
        length = len(base_word)
    
    # Generate random characters
    random_chars = ''.join(random.choices(string.ascii_letters + string.digits + string.punctuation, k=length - len(base_word)))
    
    # Combine the base word and random characters
    password = base_word + random_chars
    
    return password

# Get input word from the user
user_word = input("Enter a word: ")

# Generate and print the password
generated_password = generate_password(user_word)
print("Generated Password:", generated_password)
