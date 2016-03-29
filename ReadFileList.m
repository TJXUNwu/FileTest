%% 函数Img_label_list
% 该函数读取文件以及子文件中的图片信息，统计每个子文件中的图片的名字，并赋予标签
%%
clear all;
close all;
clc;
filenum=0;%根路径下子文件夹的个数
num=0;%统计根路径下所有图片的个数
width=144;
height=144;
RootPath='E:\FaceData\TestData\';%有多个子文件夹的根路径
SavePath='E:\FaceData\';
FileList=dir(RootPath);%读取根路径下的所有子文件夹
fid=fopen([SavePath 'label.txt'],'w');%保存图片文件
%该路径下是否是文件夹
fprintf('-----获得数据集图片以及设置对应标签-----\n-----将处理后的图像保存在其他路径中-----\n');
for i=1:length(FileList)    
    %判断路径是否为空
    if(FileList(i).isdir==1&&~strcmp(FileList(i).name,'.')&&~strcmp(FileList(i).name,'..'))
        FileListName{i}=[FileList(i).name];%存储子文件夹名
        filenum=filenum+1;        
        imglistpath=fullfile(RootPath,FileList(i).name,'*.jpg');%获得图片的全路径
        images=dir(imglistpath);%显示子文件夹下所有图片 
       for k=1:length(images)
            num=num+1;  %图片总数              
            ImageLabel.ImgListName{num}=strcat([FileListName{i} '\' images(k).name]);%单个子文件夹下图片的名称
            ImageLabel.label{num}=filenum;%对应标签  
       %% 保存标签格式为：[图片路径  标签],例如：AJ_Cook\AJ_Cook_0001.jpg    1 
            label= [ImageLabel.ImgListName{num},'    ',num2str(ImageLabel.label{num})];            
            fprintf(fid,'%s',label);
            fprintf(fid,'\n');
       %%  图像灰度化处理
%             imagepath = fullfile( RootPath, ImageLabel.ImgListName{num});
%             ImageLabel.img{num} = rgb2gray(imread( imagepath ));   %
       %%  改变图片大小满足输入要求
%             ImageLabel.resizeimg{num}=ImageResize(ImageLabel.img{num},width,height,'cut');%
%             imshow(ImageLabel.resizeimg{num});
       %% 将处理后的图片文件保存到其他路径下
            %先判断文件是否存在，
%             if ~exist(fullfile(SavePath,FileListName{i}), 'file')
%                 %不存在就创建一个文件
%                 mkfile=['mkdir ' fullfile(SavePath,FileListName{i})];%创建命令
%                 system(mkfile); %创建文件夹
%                 %保存到其他路径下
%                 imwrite(ImageLabel.resizeimg{num},fullfile(SavePath, ImageLabel.ImgListName{num})); 
%             else
%                 imwrite(ImageLabel.resizeimg{num},fullfile(SavePath, ImageLabel.ImgListName{num}));
%             end 
%%
        end   
        ImageLabel.imgnum{i-2}=length(images);%单个子文件夹下图片的个数
    end    
end
fclose(fid);

%% 对数据集进行划分，分为训练数据集和测试数据集（比例一般为9:1）
    %  将原有的数据随机打乱顺序后，采用（9:1）的比例进行划分。
    fprintf('-----划分数据集-----\n');
    imagesnum=floor(length(ImageLabel.ImgListName)*0.9);
    %   保存训练数据集
    train_test=randperm(length(ImageLabel.ImgListName));%将原有的图片列表顺序随机打乱
    fid=fopen([SavePath 'label_train.txt'],'w');%保存训练图片文件列表
    for m=1:imagesnum
        label_train=[ImageLabel.ImgListName{train_test(m)},'    ',num2str(ImageLabel.label{train_test(m)})];
        fprintf(fid,'%s',label_train);
        fprintf(fid,'\n');
    end
    fclose(fid);
    %   保存测试数据集
    fid=fopen([SavePath 'label_test.txt'],'w');%保存测试图片文件
    for n=imagesnum+1:length(ImageLabel.ImgListName)
        label_test=[ImageLabel.ImgListName{train_test(n)},'    ',num2str(ImageLabel.label{train_test(n)})];
        fprintf(fid,'%s',label_test);
        fprintf(fid,'\n');
    end
    fclose(fid);
    fprintf('OK !\n')
%%