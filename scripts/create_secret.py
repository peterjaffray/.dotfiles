import sys
import base64
import random
import string

def get_random_string(length):
    # choose from all lowercase letter
    characters = string.ascii_letters + string.digits + string.punctuation
    result_str = ''.join(random.choice(characters) for i in range(length))
    encoded = base64.b64encode(result_str)
    print "Random of length", length, "is:", '\n', result_str, '\n', "encoded:", '\n', encoded

arg_input = int(sys.argv[1])

if arg_input > 0:
    get_random_string(arg_input)
else:
    get_random_string(32)