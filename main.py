# Jason Doyle
# main.py
# main python program
# 
# Stated: Sep. 10 2015
# Updated:

# Sample code from
# http://www.pyimagesearch.com/2015/03/30/accessing-the-raspberry-pi-camera-with-opencv-and-python/

# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import numpy as np
import time
import cv2
 
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

# insert opencv code here
    
    # convert from rgb to hsv
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    # define range of red color in HSV
    lower_red = np.array([0,200,80])
    upper_red = np.array([10,255,255])

    # Threshold the HSV image to get only blue colors
    mask = cv2.inRange(hsv, lower_red, upper_red)

    kernel = np.ones((5,5),np.uint8)
    erosion = cv2.erode(mask,kernel,iterations = 1)
    kernel = np.ones((5,5),np.uint8)
    dilation = cv2.dilate(erosion,kernel,iterations = 5)

    contours, hierarchy = cv2.findContours(mask,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)


    # Find the index of the largest contour
    areas = [cv2.contourArea(c) for c in contours]

    if len(areas) > 0:
        max_index = np.argmax(areas)
        cnt=contours[max_index]
     
        # Bitwise-AND mask and original image
    #   res = cv2.bitwise_and(img,img, mask= mask)
           
        x,y,w,h = cv2.boundingRect(cnt)
        cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)
        # Bitwise-AND mask and original image
        center_x = w/2 + x
        center_y = h/2 + y

        cv2.line(frame, (center_x-3, center_y),(center_x+3,center_y),(0,255,0),1)
        cv2.line(frame, (center_x, center_y-3),(center_x, center_y+3),(0,255,0),1)

 
    # show the frame
    cv2.imshow("Frame", frame)
    # cv2.imshow('mask',mask)
    
    # clear the stream in preparation for the next frame
    rawCapture.truncate(0)
 
    # if the `q` key was pressed, break from the loop
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

