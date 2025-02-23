import os
from PIL import Image

# Directory containing the emoji images
DIRECTORY_PATH = './icons/'
# Define the desired width for resizing
TARGET_WIDTH = 64

def resize_images_in_directory(directory_path, target_width):
    """
    Resize all images in the specified directory to a target width while maintaining the aspect ratio.

    Args:
        directory_path (str): Path to the directory containing the images.
        target_width (int): The width to resize the images to.
    """

    # Iterate over all files in the specified directory
    for filename in os.listdir(directory_path):
        # Construct the full file path
        file_path = os.path.join(directory_path, filename)

        try:
            # Open the image file
            with Image.open(file_path) as img:
                # Calculate the target height to maintain the aspect ratio
                percent = (target_width / float(img.size[0]))
                target_height = int((float(img.size[1]) * float(percent)))

                # Resize the image using high-quality resampling
                img_resized = img.resize((target_width, target_height), Image.LANCZOS)

                # Save the resized image, overwriting the original
                img_resized.save(file_path)

        except Exception as e:
            print(f'Error processing file {filename}: {str(e)}')


resize_images_in_directory(DIRECTORY_PATH, TARGET_WIDTH)