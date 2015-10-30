# Jason Doyle
# record_video.py
# records video from Pi camera for testing
# 
# Stated: Oct. 29, 2015
# Updated:

# Pi camera capture code from
# http://www.pyimagesearch.com/2015/03/30/accessing-the-raspberry-pi-camera-with-opencv-and-python/

# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import numpy as np
import time
import cv2
 
# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc, 20.0, (640,480))

# initialize the camera and grab a reference to the raw camera capture
camera = PiCamera()
camera.resolution = (640, 480)
camera.framerate = 32
rawCapture = PiRGBArray(camera, size=(640, 480))
 
# allow the camera to warmup
time.sleep(0.1)
 
# capture frames from the camera
for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True):
    # grab the raw NumPy array representing the image, then initialize the timestamp
    # and occupied/unoccupied text
    image = frame.array

    # Write the frame
    out.write(image)

    # show the frame
    cv2.imshow("Frame", image)
    
    # clear the stream in preparation for the next frame
    rawCapture.truncate(0)
 
    # if the `q` key was pressed, break from the loop
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

