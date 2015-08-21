import io
import time
import picamera
import numpy as np
import cv2


stream = io.BytesIO()



# Create the in-memory stream

with picamera.PiCamera() as camera:
    camera.start_preview()
    time.sleep(2)
    camera.capture(stream, format='jpeg')
    # Construct a numpy array from the stream
    data = np.fromstring(stream.getvalue(), dtype=np.uint8)
    # "Decode" the image from the array, preserving colour
    image = cv2.imdecode(data, 1)
    # OpenCV returns an array with data in BGR order. If you want RGB instead
    # use the following...
#    image = image[:, :, ::-1]




    # Display the resulting frame
#    cv2.imshow('frame',gray)
    cv2.imshow('frame', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
#        break
        cv2.destroyAllWindows()

# When everything done, release the capture
#cv2.destroyAllWindows()






