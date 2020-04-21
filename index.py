
import os

print("Table of Contents Loaded!\n\n~= Load a homework file with command \"loadX\" where\n    X is the number of the assignment (i.e \"load1\") =~\n\n")
print("    (1) HW1 - Bags, Shapes, & Graphs")
print("    (2) HW2 - Abstract Syntax")
print("    (-) exit\n")


def isValid(choice):
    good_choices = ["1", "load1", "2", "load2", "exit"]
    for good in good_choices:
        if choice == good:
            return True
    return False
        

user_choice = "bad"
while not (user_choice and isValid(user_choice)):
    user_choice = raw_input(" > ")

if user_choice and user_choice != "exit":
    print("\nLoading...\n")

    if user_choice[-1] == '1':
        os.system("runhaskell ./hw1/main.hs && ghci ./hw1/main.hs")

    elif user_choice[-1] == '2':
        os.system("runhaskell ./hw2/main.hs && ghci ./hw2/main.hs")

    else:
        print("Module not found...")
