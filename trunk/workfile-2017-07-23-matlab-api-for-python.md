
### matlab engine

http://cn.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html
http://cn.mathworks.com/help/matlab/matlab-engine-for-python.html


```
import matlab.engine
eng = matlab.engine.start_matlab()

eng.addpath(r'./src/evaluation_mat', nargout=0)
eng.addpath('./src/evaluation_mat/ifc-drrn')
eng.addpath('./src/evaluation_mat/matlabPyrTools')

bb=np.array(eng.get_img('./tmp/analyzed_10_baboon.png')).astype(np.float64)

eng.eval_dataset_mat('./dataset/mat_test/set5', 'lapsrn/mat', 'LapSRN_v6', 4)

eng.quit()

```


### matlab_wrapper

https://github.com/mrkrd/matlab_wrapper

sudo pip install matlab_wrapper
sudo apt-get install csh
