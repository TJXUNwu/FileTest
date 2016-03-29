#coding=utf-8
import sys,os
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
import dirlist
caffe_root = 'D:/CaffeProject/CaffeTest/'  
sys.path.insert(0, caffe_root + 'python')
import caffe    
caffe.set_mode_cpu()

model_file='D:/CaffeProject/CaffeTest/models/bvlc_reference_caffenet/deploy.prototxt'
weight_file='D:/CaffeProject/CaffeTest/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'
mean_file='D:/CaffeProject/CaffeTest/python/caffe/imagenet/ilsvrc_2012_mean.npy'
imgfile='E:/FaceData/LFW/Aaron_Peirsol/Aaron_Peirsol_0004.jpg'
imaglistfile='D:/CaffeProject/CaffeTest/data/ilsvrc12/synset_words.txt'


net = caffe.Net(model_file,weight_file, caffe.TEST)
# input preprocessing: 'data' is the name of the input blob == net.inputs[0]
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data', (2,0,1))
transformer.set_mean('data', np.load(mean_file).mean(1).mean(1)) # mean pixel
transformer.set_raw_scale('data', 255)  # the reference model operates on images in [0,255] range instead of [0,1]
transformer.set_channel_swap('data', (2,1,0))  # the reference model has channels in BGR order instead of RGB

# set net to batch size of 50
net.blobs['data'].reshape(50,3,227,227)
net.blobs['data'].data[...] = transformer.preprocess('data', caffe.io.load_image(imgfile))
out = net.forward()
print("Predicted class is #{}.".format(out['prob'][0].argmax()))

# load labels
#imagenet_labels_filename = caffe_root + 'data/ilsvrc12/synset_words.txt'
try:
    labels = np.loadtxt(imaglistfile, str, delimiter='\t')
except:
    labels = np.loadtxt(imaglistfile, str, delimiter='\t')

# sort top k predictions from softmax output
top_k = net.blobs['prob'].data[0].flatten().argsort()[-1:-6:-1]
print labels[top_k]

print '\nlayername and parames:'
for k, v in net.blobs.items():
    print [(k, v.data.shape)]
     
fet=net.blobs['fc7'].data[0]
sio.savemat('F:\\TJProgram\\MatlabPro\\FtrVal\\fet.mat', {'fet':fet})

#plt.plot(feat.flat)    
#plt.show()

#fet=net.params['fc7'][0].data
#sio.savemat('savefet.mat',{'fet':fet})
print 'Save OK !'
