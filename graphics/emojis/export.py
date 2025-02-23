import os

# Directory containing the emoji images
DIRECTORY_PATH = './icons/'
# Path to output file
OUTPUT_FILE = 'list.lua'

def generate_lua_file(directory_path, output_file):
    # List to hold filenames
    filenames = []

    # Iterate through the directory
    for filename in os.listdir(directory_path):
        # Check if the file is a PNG file and has the correct dimensions
        if filename.endswith('.png'):
            filenames.append(filename.replace('.png', ''))

    filenames.sort()

    # Open the .lua file for writing
    with open(output_file, 'w') as lua_file:
        lua_file.write('return {\n')
        for name in filenames:
            lua_file.write(f"    '{name}',\n")
        lua_file.write('}\n')

    print(f'Lua file generated: {output_file}')


generate_lua_file(DIRECTORY_PATH, OUTPUT_FILE)