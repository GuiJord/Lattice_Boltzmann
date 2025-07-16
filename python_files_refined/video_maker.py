import cv2
import os
import re

#================================== Test folder - Beginning =================================================================

test = int(input('Test number: '))
test_folder = f'./testset/test_{test}/'

print('Which video do you want?')
print('[1] - Colored Map with Black Vectors')
print('[2] - Concentration with Black Vectors')
print('[3] - Temperature')

choice = int(input())

if choice == 1:
    folder_path = test_folder + 'paraview/plot_vector_black'
    output_video = test_folder + 'vector_black_video.mp4'
elif choice == 2:
    folder_path = test_folder + 'paraview/plot_concentration'
    output_video = test_folder + 'concentration_video.mp4'
elif choice == 3:
    folder_path = test_folder + 'paraview/plot_temperature'
    output_video = test_folder + 'temperature_video.mp4'

#================================== Test folder - End =================================================================

#Extract files
def extract_number(filename):
    if choice == 1:
        match = re.search(r'paraview_(\d+)_vector_black\.png', filename)
    elif choice == 2:
        match = re.search(r'paraview_(\d+)_concentration\.png', filename)
    elif choice == 3:
        match = re.search(r'paraview_(\d+)_temperature\.png', filename)
    return int(match.group(1)) if match else float('inf')

#Get all png files in folder, sorted by name
images = [img for img in os.listdir(folder_path) if img.endswith('.png')]
images.sort(key=extract_number)

print('Number of images:',len(images))

#================================== Video Configuration - Beginning =================================================================

print('FPS:\n [1]-Default\n [2]-Selected\n [3]-Time based')

fps_input = int(input())

if fps_input == 1:
    fps = 50  # Frames per second
elif fps_input == 2:
    fps = int(input('FPS: '))
elif fps_input == 3:
    time = float(input('Time (s): '))
    fps = int(len(images)/time)

#================================== Video Configuration - End =================================================================


# Read the first image to get the size
first_image = cv2.imread(os.path.join(folder_path, images[0]))
height, width, layers = first_image.shape

# Define the video writer
fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # 'mp4v' for .mp4 file
video = cv2.VideoWriter(output_video, fourcc, fps, (width, height))

# Add each image to the video
for img_name in images:
    img_path = os.path.join(folder_path, img_name)
    frame = cv2.imread(img_path)
    video.write(frame)

# Release the video writer
video.release()

print(f'Video saved as {output_video}')