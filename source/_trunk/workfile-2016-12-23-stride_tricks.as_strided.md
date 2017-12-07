### np.lib.stride_tricks.as_strided 

https://docs.scipy.org/doc/numpy/reference/generated/numpy.ndarray.strides.html

http://stackoverflow.com/questions/8070349/using-numpy-stride-tricks-to-get-non-overlapping-array-blocks


```
import numpy as np
n=4
m=5
a = np.arange(1,n*m+1).reshape(n,m)
print(a)
# [[ 1  2  3  4  5]
#  [ 6  7  8  9 10]
#  [11 12 13 14 15]
#  [16 17 18 19 20]]
sz = a.itemsize
h,w = a.shape
bh,bw = 2,2
shape = (h/bh, w/bw, bh, bw)
print(shape)
# (2, 2, 2, 2)

strides = sz*np.array([w*bh,bw,w,1])
print(strides)
# [40  8 20  4]

blocks=np.lib.stride_tricks.as_strided(a, shape=shape, strides=strides)
print(blocks)
# [[[[ 1  2]
#    [ 6  7]]
#   [[ 3  4]
#    [ 8  9]]]
#  [[[11 12]
#    [16 17]]
#   [[13 14]
#    [18 19]]]]
```

Starting at the 1 in a (i.e. blocks[0,0,0,0]), to get to the 2 (i.e. blocks[0,0,0,1]) is one item away. Since (on my machine) the a.itemsize is 4 bytes, the stride is 1*4 = 4. This gives us the last value in strides = (10,2,5,1)*a.itemsize = (40,8,20,4).

Starting at the 1 again, to get to the 6 (i.e. blocks[0,0,1,0]), is 5 (i.e. w) items away, so the stride is 5*4 = 20. This accounts for the second to last value in strides.

Starting at the 1 yet again, to get to the 3 (i.e. blocks[0,1,0,0]), is 2 (i.e. bw) items away, so the stride is 2*4 = 8. This accounts for the second value in strides.

Finally, starting at the 1, to get to 11 (i.e. blocks[1,0,0,0]), is 10 (i.e. w*bh) items away, so the stride is 10*4 = 40. So strides = (40,8,20,4).

strides(total_stride, total_height, line_stride, stride)

stride 单个item的长度，line_stride一行的item的长度，