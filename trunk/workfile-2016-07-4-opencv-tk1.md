### python-opencv on tk1

#### install

`sudo apt-get install python-opencv`

#### check the installed dir for py-opencv

`dpkg -L python-opencv`

> 
	/usr/lib/python2.7/dist-packages
	/usr/lib/python2.7/dist-packages/cv2.so
	/usr/lib/python2.7/dist-packages/cv.py

#### add opencv to pythonpath

>     export PYTHONPATH=/usr/lib/python2.7/dist-packages:$PYTHONPATH

#### test on opencv

```py
import numpy as np
import cv2

cap = cv2.VideoCapture('/dev/video0')
cap.isOpened()
cap.open(0)


while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()

    # Our operations on the frame come here
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Display the resulting frame
    cv2.imshow('frame',gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
```