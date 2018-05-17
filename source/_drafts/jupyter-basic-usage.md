---
title: jupyter-basic-usage
date: 2018-04-02 09:41:51
categories: [dev]
tags: [python,docker]
---



%matplotlib inline

%load_ext autoreload
%autoreload 2


### jupyterhub


docker run -it --rm -p 8888:8888 -v /home/david/jupyter-notes:/home/jovyan/david -v /data/david/cocoapi:/mnt/cocoapi -v /data/fashion/data/keypoint:/mnt/data jupyter/scipy-notebook bash



pip install opencv-python -i https://mirrors.aliyun.com/pypi/simple/

jupyter notebook --ip=0.0.0.0 --port=8000
