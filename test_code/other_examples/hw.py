import urllib2
import KaicongWiFiCameraControl.KaicongMotor as IPmotor
import KaicongWiFiCameraControl.KaicongVideo as IPvideo

if __name__ == "__main__":
    import pygame
    import sys
    import cv2
    import numpy as np
    
    if len(sys.argv) != 2:
        print "Usage: %s <ip_address>" % sys.argv[0]
        sys.exit(-1)
    
    pygame.init()
    screen = pygame.display.set_mode((320, 240))
    
    motor = IPmotor.KaicongMotor(sys.argv[1])
    
    def checkKeys():
        keys = pygame.key.get_pressed()
        a = 0
        b = 0
        if keys [pygame.K_a]:
            a = -1
        if keys [pygame.K_s]:
            b = -1
        if keys [pygame.K_d]:
            a = 1
        if keys [pygame.K_w]:
            b = 1
             
        motor.move([a, b])
        
#    while 1:
#        for event in pygame.event.get():
#            if event.type == pygame.QUIT:
#                sys.exit()
#       checkKeys()

    def show_video(jpg):
        a = 0
        b = 0

        img = cv2.imdecode(np.fromstring(jpg, dtype=np.uint8),cv2.CV_LOAD_IMAGE_COLOR)
        # Convert BGR to HSV

        blur = cv2.medianBlur(img,5)    # 5 is a fairly small kernel size

        hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)
   
        # define range of blue color in HSV
        lower_blue = np.array([0,60,80])
        upper_blue = np.array([10,255,255])
    
        # Threshold the HSV image to get only blue colors
        mask = cv2.inRange(hsv, lower_blue, upper_blue)

        kernel = np.ones((5,5),np.uint8)
        erosion = cv2.erode(mask,kernel,iterations = 1)
        kernel = np.ones((5,5),np.uint8)
        dilation = cv2.dilate(erosion,kernel,iterations = 5)

        contours, hierarchy = cv2.findContours(mask,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)


        # Find the index of the largest contour
        areas = [cv2.contourArea(c) for c in contours]
        max_index = np.argmax(areas)
        cnt=contours[max_index]
 
        # Bitwise-AND mask and original image
#        res = cv2.bitwise_and(img,img, mask= mask)
       
        x,y,w,h = cv2.boundingRect(cnt)
        cv2.rectangle(blur,(x,y),(x+w,y+h),(0,255,0),2)

#        print "Point 1 = ({}, {})".format(x, y)
#        print "Point 2 = ({}, {})".format( x+w, y+h )

        if x < 50:
            print "left"
            a = -1
        elif (y + h) > 430:
            print "down"
            b = -1
        elif (x + w) > 590:
            print "right"
            a = 1
        elif y < 50:
            print "up"
            b = 1
        else:
            print "stay"
            a = 0
            b = 0
    
        motor.move([a, b])
 
        cv2.imshow('frame',blur)
#        cv2.imshow('mask',dilation)
#        cv2.imshow('res',res)

        #cv2.imshow('i',img)
        
        # Check for a,s,w,d press to move camera        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                sys.exit()
#        checkKeys()

        # Note: waitKey() actually pushes the image out to screen
        if cv2.waitKey(1) ==27:
            exit(0)  
    
    video = IPvideo.KaicongVideo(sys.argv[1], show_video)
    video.run()

