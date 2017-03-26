import sys
import os
import re

def main():
    
    if len(sys.argv) != 2:
        print("Wrong argument")
        print("Usage: python EditDate.py <filename>")
        return
    else:
        filename = sys.argv[1]
    if not os.path.isfile(filename):
        print("File not found")
        return

    with open(filename, 'r') as input_file:
        with open('tmp_'+filename, 'w') as output_file:
            reader = input_file.readlines()
            for row in reader:
                replacement = re.sub(r'(\d+)\/(\d+)\/(\d+)', r'\3/\1/\2', row)
                output_file.write(replacement)

if __name__ == '__main__':
    main()
