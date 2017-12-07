## pooling

在卷积神经网络中，我们经常会碰到池化操作，而池化层往往在卷积层后面，通过池化来降低卷积层输出的特征向量，同时改善结果（不易出现过拟合）。
为什么可以通过降低维度呢？
因为图像具有一种“静态性”的属性，这也就意味着在一个图像区域有用的特征极有可能在另一个区域同样适用。因此，为了描述大的图像，一个很自然的想法就是对不同位置的特征进行聚合统计，例如，人们可以计算图像一个区域上的某个特定特征的平均值 (或最大值)来代表这个区域的特征

#### 池化的不变性

如果人们选择图像中的连续范围作为池化区域，并且只是池化相同(重复)的隐藏单元产生的特征，那么，这些池化单元就具有平移不变性 (translation invariant)。这就意味着即使图像经历了一个小的平移之后，依然会产生相同的 (池化的) 特征。在很多任务中 (例如物体检测、声音识别)，我们都更希望得到具有平移不变性的特征，因为即使图像经过了平移，样例(图像)的标记仍然保持不变。例如，如果你处理一个MNIST数据集的数字，把它向左侧或右侧平移，那么不论最终的位置在哪里，你都会期望你的分类器仍然能够精确地将其分类为相同的数字。

[池化方法总结(Pooling)](http://blog.csdn.net/mao_kun/article/details/50507376)

## 卷积特征提取

#### 部分联通网络

对隐含单元和输入单元间的连接加以限制：每个隐含单元仅仅只能连接输入单元的一部分。例如，每个隐含单元仅仅连接输入图像的一小片相邻区域

#### Convolutions

Natural images have the property of being stationary, meaning that the statistics of one part of the image are the same as any other part. This suggests that the features that we learn at one part of the image can also be applied to other parts of the image, and we can use the same features at all locations.

#### 局部对比度归一化层Local Contrast Normalization Layer-N

  该模块主要进行的是局部做减和做除归一化，它会迫使在特征map中的相邻特征进行局部竞争，还会迫使在不同特征maps的同一空间位置的特征进行竞争。在一个给定的位置进行减法归一化操作，实际上就是该位置的值减去邻域各像素的加权后的值，权值是为了区分与该位置距离不同影响不同，权值可以由一个高斯加权窗来确定。除法归一化实际上先计算每一个特征maps在同一个空间位置的邻域的加权和的值，然后取所有特征maps这个值的均值，然后每个特征map该位置的值被重新计算为该点的值除以max（那个均值，该点在该map的邻域的加权和的值）。分母表示的是在所有特征maps的同一个空间邻域的加权标准差。哦哦，实际上如果对于一个图像的话，就是均值和方差归一化，也就是特征归一化。这个实际上是由计算神经科学模型启发得到的。（这里自己有点理解，请见本文的第四节）

[Feature extraction using convolution](http://deeplearning.stanford.edu/wiki/index.php/Feature_extraction_using_convolution)

[Deep Learning论文笔记之（六）Multi-Stage多级架构分析](http://blog.csdn.net/zouxy09/article/details/10007237)

## 过拟合 (over-fitting)