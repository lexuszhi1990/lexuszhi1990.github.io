for req in $(cat requirements.txt); do pip install $req; done

python draw_net.py ../examples/mnist/lenet_train_test.prototxt lenet.png

http://blog.csdn.net/xiaoyezi_1834/article/details/50725632
http://caffe.berkeleyvision.org/installation.html