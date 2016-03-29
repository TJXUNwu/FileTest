
%% �����ֲ��Աȶԣ�1.���������ȶԣ�2.��������ȶ�
clear all;
close all;
clc;
addpath('pyscripts');
imgroot='E:\FaceData\LFW\';
%% ������ȡ�����������ݣ�����������Python�ű�������
% �������ݣ�ȫ���������ݡ������������ݡ�������������
% (1)ȫ����������
load('LFWFtr.mat');
allftr=featr(2:end,:);
[allm,alln]=size(allftr);

%(2) ������������
load('testfeat.mat');
partftr=testfeat(1:end,:);

%(3)������������
load('fet.mat');
singalftr=fet;
img='E:/FaceData/LFW/Aaron_Peirsol/Aaron_Peirsol_0004.jpg';
%imshow(img);

%% ��ȡ����ͼƬ�ı���·��������ȡ�ļ�
fid = fopen('./alldata.txt');% ��ʽΪ��·��+����
filename = textscan(fid,'%s');
filename = filename{1};
j=1;
for g=1:2:length(filename)
    imgpath{j}=filename{g};
    imgname{j}=filename{g+1};
    j=j+1;
end

%% (1)��ȡ����ͼƬ

%% (2)��ȡ�����ļ���·����ͼƬ  
% ��δ�����ʱ����
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

%% ���бȽϣ�����ȡ�����������е��������бȽϣ��������ֵ��ߵ�����
% �������Ҿ�����Ϊ���ԣ�Ҳ����ʹ��������ʽ���бȽ�
% �����ȽϺͶ�Ƚϻ�ϣ�����������������
% �ݴ����
% �Ƚ�ǰ��Ԥ�趨�����趨��ֵ�����Ͷ�Ӧ�ı������
tmpftr=partftr;
[m,n]=size(tmpftr);
sorindx=zeros(m,allm);%�������
scores=zeros(m,allm);%��ֵ����
sc=zeros(1,m);
for i=1:m
    temp=tmpftr(i,:);
    temp=repmat(temp,[allm,1]);
    fenmu=sqrt(sum(temp.*temp,2).*sum(allftr.*allftr,2));
    fenzi=sum(temp.*allftr,2);
    sc=(fenzi./fenmu)';
    [scores(i,:),sorindx(i,:)]=sort(sc,'descend');
end

%% (1)������������ʾ
    figure(1)
    imshow(img); 
    for i=1:3
       text(10,10+i*20,[imgname{sorindx(1,i)},' : ',num2str(scores(1,i))],'Color','r','fontsize',10);
       title('Aaron_Peirsol','Color','r','fontsize',10);
    end
    
%% (2)�������Ƚ�
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



