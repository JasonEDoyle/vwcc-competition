# Jason Doyle
# Phillip Benzinger
#
# main_video.py
# main python program that uses recorded videos.
# 
# Stated: Nov. 05, 2015
# Updated:

# import the necessary packages
import time
import cv2
import numpy as np
 
cap = cv2.VideoCapture('videos/vid1.avi')

center_x = 320
center_y = 240
while(1):

    # Take each frame
    _, frame = cap.read()

    # Convert BGR to HSV
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
 
    # TODO
    # Add trackbars to filter color.

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
 
    # if the `q` key was pressed, break from the loop
    if cv2.waitKey(50) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()
