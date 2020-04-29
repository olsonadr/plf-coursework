#!/usr/bin/env python3

import os

print("Table of Contents Loaded!\n\n~= Load a homework file with command \"loadX\" where\n    X is the number of the assignment (i.e \"load1\") =~\n\n")
print("    (1) HW1 - Bags, Shapes, Graphs")
print("    (2) HW2 - Abstract Syntax")
print("    (3) HW3 - Semantics")
print("    (-) exit\n")


def isValid(choice):
    good_choices = ["1", "load1", "2", "load2", "3", "load3", "exit"]
    for good in good_choices:
        if choice == good:
            return True
    return False
        

user_choice = "bad"
while not (user_choice and isValid(user_choice)):
    user_choice = str(input(" > "))

if user_choice and user_choice != "exit" and user_choice != "-":
    print("\nLoading...\n")

    if user_choice[-1] == '1':
        os.system("cd hw1; runhaskell main.hs; ghci main.hs")

    elif user_choice[-1] == '2':
        os.system("cd hw2; runhaskell main.hs; ghci main.hs")

    elif user_choice[-1] == '3':
        os.system("cd hw3; runhaskell main.hs; ghci main.hs")

    else:
        print("Module not found...")
