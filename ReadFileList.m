%% ����Img_label_list
% �ú�����ȡ�ļ��Լ����ļ��е�ͼƬ��Ϣ��ͳ��ÿ�����ļ��е�ͼƬ�����֣��������ǩ
%%
clear all;
close all;
clc;
filenum=0;%��·�������ļ��еĸ���
num=0;%ͳ�Ƹ�·��������ͼƬ�ĸ���
width=144;
height=144;
RootPath='E:\FaceData\TestData\';%�ж�����ļ��еĸ�·��
SavePath='E:\FaceData\';
FileList=dir(RootPath);%��ȡ��·���µ��������ļ���
fid=fopen([SavePath 'label.txt'],'w');%����ͼƬ�ļ�
%��·�����Ƿ����ļ���
fprintf('-----������ݼ�ͼƬ�Լ����ö�Ӧ��ǩ-----\n-----��������ͼ�񱣴�������·����-----\n');
for i=1:length(FileList)    
    %�ж�·���Ƿ�Ϊ��
    if(FileList(i).isdir==1&&~strcmp(FileList(i).name,'.')&&~strcmp(FileList(i).name,'..'))
        FileListName{i}=[FileList(i).name];%�洢���ļ�����
        filenum=filenum+1;        
        imglistpath=fullfile(RootPath,FileList(i).name,'*.jpg');%���ͼƬ��ȫ·��
        images=dir(imglistpath);%��ʾ���ļ���������ͼƬ 
       for k=1:length(images)
            num=num+1;  %ͼƬ����              
            ImageLabel.ImgListName{num}=strcat([FileListName{i} '\' images(k).name]);%�������ļ�����ͼƬ������
            ImageLabel.label{num}=filenum;%��Ӧ��ǩ  
       %% �����ǩ��ʽΪ��[ͼƬ·��  ��ǩ],���磺AJ_Cook\AJ_Cook_0001.jpg    1 
            label= [ImageLabel.ImgListName{num},'    ',num2str(ImageLabel.label{num})];            
            fprintf(fid,'%s',label);
            fprintf(fid,'\n');
       %%  ͼ��ҶȻ�����
%             imagepath = fullfile( RootPath, ImageLabel.ImgListName{num});
%             ImageLabel.img{num} = rgb2gray(imread( imagepath ));   %
       %%  �ı�ͼƬ��С��������Ҫ��
%             ImageLabel.resizeimg{num}=ImageResize(ImageLabel.img{num},width,height,'cut');%
%             imshow(ImageLabel.resizeimg{num});
       %% ��������ͼƬ�ļ����浽����·����
            %���ж��ļ��Ƿ���ڣ�
%             if ~exist(fullfile(SavePath,FileListName{i}), 'file')
%                 %�����ھʹ���һ���ļ�
%                 mkfile=['mkdir ' fullfile(SavePath,FileListName{i})];%��������
%                 system(mkfile); %�����ļ���
%                 %���浽����·����
%                 imwrite(ImageLabel.resizeimg{num},fullfile(SavePath, ImageLabel.ImgListName{num})); 
%             else
%                 imwrite(ImageLabel.resizeimg{num},fullfile(SavePath, ImageLabel.ImgListName{num}));
%             end 
%%
        end   
        ImageLabel.imgnum{i-2}=length(images);%�������ļ�����ͼƬ�ĸ���
    end    
end
fclose(fid);

%% �����ݼ����л��֣���Ϊѵ�����ݼ��Ͳ������ݼ�������һ��Ϊ9:1��
    %  ��ԭ�е������������˳��󣬲��ã�9:1���ı������л��֡�
    fprintf('-----�������ݼ�-----\n');
    imagesnum=floor(length(ImageLabel.ImgListName)*0.9);
    %   ����ѵ�����ݼ�
    train_test=randperm(length(ImageLabel.ImgListName));%��ԭ�е�ͼƬ�б�˳���������
    fid=fopen([SavePath 'label_train.txt'],'w');%����ѵ��ͼƬ�ļ��б�
    for m=1:imagesnum
        label_train=[ImageLabel.ImgListName{train_test(m)},'    ',num2str(ImageLabel.label{train_test(m)})];
        fprintf(fid,'%s',label_train);
        fprintf(fid,'\n');
    end
    fclose(fid);
    %   ����������ݼ�
    fid=fopen([SavePath 'label_test.txt'],'w');%�������ͼƬ�ļ�
    for n=imagesnum+1:length(ImageLabel.ImgListName)
        label_test=[ImageLabel.ImgListName{train_test(n)},'    ',num2str(ImageLabel.label{train_test(n)})];
        fprintf(fid,'%s',label_test);
        fprintf(fid,'\n');
    end
    fclose(fid);
    fprintf('OK !\n')
%%