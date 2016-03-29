# -*- coding: utf-8 -*-
import sys,os
'''
    ListFilesToTxt1 保存子路径
'''
def ListFilesToTxt1(dir,file,wildcard,recursion):
     exts = wildcard.split(" ")
     for root, subdirs, files in os.walk(dir):   
         tname=root.split('\\')[-1] 
         print tname
         for name in files:             
             for ext in exts:
                 if(name.endswith(ext)):
                     file.write(tname+'\\'+name + ' ' +tname+"\n")                     
                     break
         if(not recursion):
             break

'''
    ListFilesToTxt2 保存全路径
'''
def ListFilesToTxt2(dir,file,wildcard,recursion):
     exts = wildcard.split(" ")
     files = os.listdir(dir)     
     for name in files: 
         fullname=os.path.join(dir,name)
         print  name     
         if(os.path.isdir(fullname) & recursion):
             ListFilesToTxt2(fullname,file,wildcard,recursion)               
         else:
             for ext in exts:                                
                 if(name.endswith(ext)):
                     fuls=fullname.split('\\')                   
                     file.write(fullname + ' ' + fuls[len(fuls)-2]+"\n")                       
                     break

#def DivDB(filepath,save_path):
def DivDB(filepath,trainfile,testfile):
    '''
    @brief: 提取webface人脸数据
    @param : filepath 文件路径
    @param : top_num=1000,表示提取的类别数目
    @param : equal_num 是否强制每个人都相同
    '''
    dirlists=os.listdir(filepath)
    dict_id_num={}
    for subdir in dirlists:
        dict_id_num[subdir]=len(os.listdir(os.path.join(filepath,subdir)))
    
    sorted_num_id=sorted([(v, k) for k, v in dict_id_num.items()], reverse=True)
    select_ids=sorted_num_id[0:len(sorted_num_id)]
    #trainfile=save_path+'train_'+str(len(sorted_num_id))+'.txt'
    #testfile=save_path+'test_'+str(len(sorted_num_id))+'.txt'
    fid_train=open(trainfile,'w')
    fid_test=open(testfile,'w')
    pid=0
    for  select_id in select_ids:
        subdir=select_id[1]
        filenamelist=os.listdir(os.path.join(filepath,subdir)) 
        num=1
        for filename in filenamelist :
            if select_id[0]==1:
                fid_train.write(os.path.join(subdir,filename)+' '+subdir+'\n')
                fid_test.write(os.path.join(subdir,filename)+' '+subdir+'\n')
            else:
                if num !=1:
                    fid_train.write(os.path.join(subdir,filename)+' '+subdir+'\n')
                else:
                    fid_test.write(os.path.join(subdir,filename)+' '+subdir+'\n')
            num=num+1
        pid=pid+1
    fid_train.close()
    fid_test.close()
    print "OK !"

def SaveSUBRoot(dir,outfile):  
   wildcard =  ".png .jpg .bmp .gif" 
   file = open(outfile,"w")
   if not file:
     print ("cannot open the file %s for writing" % outfile)     
   ListFilesToTxt1(dir,file,wildcard, 1)   
   file.close()
   print 'OK !'

def SaveFULLRoot(dir,outfile):  
   wildcard =  ".png .jpg .bmp .gif" 
   file = open(outfile,"w")
   if not file:
     print ("cannot open the file %s for writing" % outfile)     
   ListFilesToTxt2(dir,file,wildcard, 1)   
   file.close()
   print 'OK !'

if __name__=='__main__':
    dir="E:\\FaceProcessSavePath"
    outfile="F:\\binaries2.txt"
    #SaveFULLRoot(dir,outfile)
    #SaveSUBRoot(dir,outfile)
    
    data_path = 'E:\\FaceData\\LFW\\'
    
    trainfile='F:\\LabelList\\train.txt'
    testfile='F:\\LabelList\\test.txt'
    DivDB(data_path,trainfile,testfile)
    

    #Test(dir,outfile)
    #file = open(outfile)
    #for line in file:
    #    print line
    
    
