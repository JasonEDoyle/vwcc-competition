import numpy as np
import cv2

# #Load a color image in grayscale
# img = cv2.imread('lena.bmp',0)

# cv2.imshow('image',img)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

# cap = cv2.VideoCapture(0)
# 
# while(True):
#      # Capture frame-by-frame
#      ret, frame = cap.read()
# 
#      # Our operations on the frame come here
#      gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
# 
#      # Display the resulting frame
#      cv2.imshow('frame',gray)
#      if cv2.waitKey(1) & 0xFF == ord('q'):
#          break
# 
# # When everything is done, release the capture stream
# cap.release()
# cv2.destroyAllWindows()

img = np.zeros((512,512,3), np.uint8)

# Draws a diagonal blue line with a thickness of 5 px
img = cv2.line(img,(0,0),(511,511),(255,0,0),5)

img = cv2.rectangle(img,(384,0),(510,128),(0,255,0),3)
img = cv2.circle(img,(447,63), 63, (0,0,255), -1)
img = cv2.ellipse(img,(256,256),(100,50),0,0,100,255,-1)

pts = np.array([[10,5],[20,30],[70,20],[50,10]], np.int32)
pts = pts.reshape((-1,1,2))
img = cv2.polylines(img,[pts],True,(0,255,255))

cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()

font = cv2.FONT_HERSHEY_SIMPLEX
cv2.putText(img,'OpenCV',(10,500), font, 4,(255,255,255),2,cv2.LINE_AA)
