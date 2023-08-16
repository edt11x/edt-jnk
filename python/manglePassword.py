#!/usr/bin/env python
import random
import string

def mangle_phrase(phrase):
    # Convert the phrase to lowercase
    phrase = phrase.lower()
    
    # Replace spaces with underscores
    phrase = phrase.replace(' ', '_')
    
    # Shuffle the characters in the phrase
    phrase_list = list(phrase)
    random.shuffle(phrase_list)
    shuffled_phrase = ''.join(phrase_list)
    
    # Add random digits and special characters
    special_characters = '!@#$%^&*()_+=-[]{}|;:,.<>?'
    num_special = random.randint(1, min(len(phrase), 5))
    special_chars = random.sample(special_characters, num_special)
    
    # Combine shuffled phrase and special characters
    mangled_password = shuffled_phrase + ''.join(special_chars)
    
    # Make sure the password is at least 12 characters long
    while len(mangled_password) < 12:
        mangled_password += random.choice(string.ascii_letters + string.digits + special_characters)
    
    return mangled_password

# Get input phrase from the user
input_phrase = input("Enter a phrase: ")

# Generate and print the mangled password
mangled_password = mangle_phrase(input_phrase)
print("Mangled Password:", mangled_password)


