1. update caffe

```
mkdir build
cd build
cmake ..
make all
make install
make runtest
```

2. run caffe with multi gpus

$TOOLS/caffe train -solver singleFrame_solver_CNN_F.prototxt -weights model --gpu 0,1,2,3

用的时候 --gpu 0,1,2,3 就行了

parallel.cpp:392] GPUs pairs 0:1, 2:3, 0:2


---references

http://caffe.berkeleyvision.org/installation.html