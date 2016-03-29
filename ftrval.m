
%% 做两种测试比对：1.单个特征比对；2.多个特征比对
clear all;
close all;
clc;
addpath('pyscripts');
imgroot='E:\FaceData\LFW\';
%% 导入提取到的特征数据，特征数据由Python脚本程序获得
% 三种数据：全部特征数据、单个特征数据、部分特征数据
% (1)全部特征数据
load('LFWFtr.mat');
allftr=featr(2:end,:);
[allm,alln]=size(allftr);

%(2) 部分特征数据
load('testfeat.mat');
partftr=testfeat(1:end,:);

%(3)单个特征数据
load('fet.mat');
singalftr=fet;
img='E:/FaceData/LFW/Aaron_Peirsol/Aaron_Peirsol_0004.jpg';
%imshow(img);

%% 读取所有图片的保存路径，并读取文件
fid = fopen('./alldata.txt');% 格式为：路径+名称
filename = textscan(fid,'%s');
filename = filename{1};
j=1;
for g=1:2:length(filename)
    imgpath{j}=filename{g};
    imgname{j}=filename{g+1};
    j=j+1;
end

%% (1)读取单张图片

%% (2)读取测试文件的路径和图片  
% 这段代码暂时无用
fclose(fid);
fid = fopen('./test.txt');
test_img_name = textscan(fid,'%s');
t_imgnm = test_img_name{1};
j=1;
for t=1:2:length(t_imgnm)
    t_img_path{j}=[imgroot t_imgnm{t}];
    t_img_name{j}=t_imgnm{t+1}; 
    j=j+1;
end

%% 进行比较，将提取的特征与所有的特征进行比较，并保存分值最高的三项
% 采用余弦距离作为测试，也可以使用其他方式进行比较
% 将单比较和多比较混合，后续步骤再做处理
% 暂存矩阵
% 比较前的预设定，先设定分值向量和对应的标号向量
tmpftr=partftr;
[m,n]=size(tmpftr);
sorindx=zeros(m,allm);%标号向量
scores=zeros(m,allm);%分值向量
sc=zeros(1,m);
for i=1:m
    temp=tmpftr(i,:);
    temp=repmat(temp,[allm,1]);
    fenmu=sqrt(sum(temp.*temp,2).*sum(allftr.*allftr,2));
    fenzi=sum(temp.*allftr,2);
    sc=(fenzi./fenmu)';
    [scores(i,:),sorindx(i,:)]=sort(sc,'descend');
end

%% (1)单特征数据显示
    figure(1)
    imshow(img); 
    for i=1:3
       text(10,10+i*20,[imgname{sorindx(1,i)},' : ',num2str(scores(1,i))],'Color','r','fontsize',10);
       title('Aaron_Peirsol','Color','r','fontsize',10);
    end
    
%% (2)多特征比较
for k = 1:m  
      img = imread(t_img_path{k}); 
      figure(2);
      imshow(img); 
      title(char(t_img_name{k}),'Color','r','fontsize',10);
   for i=1:3
      text(10,10+i*20,[imgname{sorindx(k,i)},' : ',num2str(scores(k,i))],'Color','r','fontsize',10);     
   end  
  pause;
end 

%%
sprintf('OK !')



