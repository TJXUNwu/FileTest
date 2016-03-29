# -*- coding: utf-8 -*-
import sys,os
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
import dirlist as dlit
import time
caffe_root = 'D:/CaffeProject/CaffeTest/'  
sys.path.insert(0, caffe_root + 'python')
import caffe    
caffe.set_mode_cpu()

model_file='D:/CaffeProject/CaffeTest/models/bvlc_reference_caffenet/deploy.prototxt'
weight_file='D:/CaffeProject/CaffeTest/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'
mean_file='D:/CaffeProject/CaffeTest/python/caffe/imagenet/ilsvrc_2012_mean.npy'

net = caffe.Net(model_file,weight_file, caffe.TEST)
# input preprocessing: 'data' is the name of the input blob == net.inputs[0]
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data', (2,0,1))
transformer.set_mean('data', np.load(mean_file).mean(1).mean(1)) # mean pixel
transformer.set_raw_scale('data', 255)  # the reference model operates on images in [0,255] range instead of [0,1]
transformer.set_channel_swap('data', (2,1,0))  # the reference model has channels in BGR order instead of RGB
# set net to batch size of 50
net.blobs['data'].reshape(50,3,227,227)

imgfile='E:\\FaceData\\LFW\\'
imaglistfile='F:\\TJProgram\\MatlabPro\\FtrVal\\alldata.txt'
dlit.SaveFULLRoot(imgfile,imaglistfile)

trainfile='F:\\TJProgram\\MatlabPro\\FtrVal\\train.txt'
testfile='F:\\TJProgram\\MatlabPro\\FtrVal\\test.txt'    
dlit.DivDB(imgfile,trainfile,testfile)
'''
print'\nextract all feature:\n'
allfeat=np.zeros([1,4096])
file = open(imaglistfile)#更改路径，提取特征
for line in file: 
    imgname=line.strip().lstrip().rstrip('\n') 
    print imgname    
    net.blobs['data'].data[...] = transformer.preprocess('data', caffe.io.load_image(imgname))
    start =time.clock()
    out = net.forward()
    #print("Predicted class is #{}.".format(out['prob'][0].argmax()))
    singlefeat=net.blobs['fc7'].data[0]
    end = time.clock()
    print('特征提取时间: %s Seconds'%(end-start))
    allfeat=np.row_stack((allfeat,singlefeat))
file.close()    
allfeat=allfeat[1:end,:]    
sio.savemat('F:\\TJProgram\\MatlabPro\\FtrVal\\allfeat.mat', {'allfeat':allfeat})    
print 'Save OK !'

print'\nextract train feature:\n'
trainfeat=np.zeros([1,4096])
file = open(trainfile)#更改路径，提取特征
for line in file: 
    #imgname=line.strip().lstrip().rstrip('\n') 
    imgname=imgfile+line
    imgname=imgname.split(" ")
    print imgname[0]       
    net.blobs['data'].data[...] = transformer.preprocess('data', caffe.io.load_image(imgname[0]))
    start =time.clock()
    out = net.forward()
    #print("Predicted class is #{}.".format(out['prob'][0].argmax()))
    singlefeat=net.blobs['fc7'].data[0]
    end = time.clock()
    print('特征提取时间: %s Seconds'%(end-start))
    trainfeat=np.row_stack((trainfeat,singlefeat))
file.close()    
trainfeat=trainfeat[1:end,:]    
sio.savemat('F:\\TJProgram\\MatlabPro\\FtrVal\\trainfeat.mat', {'trainfeat':trainfeat}) 
print 'Save OK !'
'''
print'\nextract test feature:\n'
testfeat=np.zeros([1,4096])
file = open(testfile)#更改路径，提取特征
for line in file: 
    #imgname=line.strip().lstrip().rstrip('\n')      
    imgname=imgfile+line
    imgname=imgname.split(" ")
    print imgname[0]    
        
    net.blobs['data'].data[...] = transformer.preprocess('data', caffe.io.load_image(imgname[0]))
    start =time.clock()
    out = net.forward()
    #print("Predicted class is #{}.".format(out['prob'][0].argmax()))
    singlefeat=net.blobs['fc7'].data[0]
    end = time.clock()
    print('特征提取时间: %s Seconds'%(end-start))
    testfeat=np.row_stack((testfeat,singlefeat))
file.close()    
testfeat=testfeat[1:end,:]    
sio.savemat('F:\\TJProgram\\MatlabPro\\FtrVal\\testfeat.mat', {'testfeat':testfeat}) 
'''
print 'Save OK !'



