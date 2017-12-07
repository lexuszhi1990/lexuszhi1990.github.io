http://www.cnblogs.com/denny402/p/5071126.html


http://www.cnblogs.com/denny402/p/5071126.html

1、Convolution层：

就是卷积层，是卷积神经网络（CNN）的核心层。

层类型：Convolution

　　lr_mult: 学习率的系数，最终的学习率是这个数乘以solver.prototxt配置文件中的base_lr。如果有两个lr_mult, 则第一个表示权值的学习率，第二个表示偏置项的学习率。一般偏置项的学习率是权值学习率的两倍。

在后面的convolution_param中，我们可以设定卷积层的特有参数。

必须设置的参数：

  　　num_output: 卷积核（filter)的个数

  　　kernel_size: 卷积核的大小。如果卷积核的长和宽不等，需要用kernel_h和kernel_w分别设定

其它参数：

  　　 stride: 卷积核的步长，默认为1。也可以用stride_h和stride_w来设置。

  　　 pad: 扩充边缘，默认为0，不扩充。 扩充的时候是左右、上下对称的，比如卷积核的大小为5*5，那么pad设置为2，则四个边缘都扩充2个像素，即宽度和高度都扩充了4个像素,这样卷积运算之后的特征图就不会变小。也可以通过pad_h和pad_w来分别设定。(有疑问： 这里只要了pad=3，但是整个卷积输出的结果增加了3 没有，增加6)

    　　weight_filler: 权值初始化。 默认为“constant",值全为0，很多时候我们用"xavier"算法来进行初始化，也可以设置为”gaussian"
    　　bias_filler: 偏置项的初始化。一般设置为"constant",值全为0。
   　　 bias_term: 是否开启偏置项，默认为true, 开启
   　　 group: 分组，默认为1组。如果大于1，我们限制卷积的连接操作在一个子集内。如果我们根据图像的通道来分组，那么第i个输出分组只能与第i个输入分组进行连接。
 
输入：n*c0*w0*h0
输出：n*c1*w1*h1
其中，c1就是参数中的num_output，生成的特征图个数
 w1=(w0+2*pad-kernel_size)/stride+1;
 h1=(h0+2*pad-kernel_size)/stride+1;

### BatchNormLayer

http://caffe.berkeleyvision.org/doxygen/classcaffe_1_1BatchNormLayer.html

Normalizes the input to have 0-mean and/or unit (1) variance across the batch.

This layer computes Batch Normalization described in [1]. For each channel in the data (i.e. axis 1), it subtracts the mean and divides by the variance, where both statistics are computed across both spatial dimensions and across the different examples in the batch.

By default, during training time, the network is computing global mean/ variance statistics via a running average, which is then used at test time to allow deterministic outputs for each input. You can manually toggle whether the network is accumulating or using the statistics via the use_global_stats option. IMPORTANT: for this feature to work, you MUST set the learning rate to zero for all three parameter blobs, i.e., param {lr_mult: 0} three times in the layer definition.

Note that the original paper also included a per-channel learned bias and scaling factor. It is possible (though a bit cumbersome) to implement this in caffe using a single-channel DummyDataLayer filled with zeros, followed by a Convolution layer with output the same size as the current. This produces a channel-specific value that can be added or multiplied by the BatchNorm layer's output.