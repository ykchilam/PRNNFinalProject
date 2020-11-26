% n is the number of subjects
n = 3;
for i =1:n
    str = ['s0',int2str(i)];
    ds1 = imageDatastore(['C:\Users\mmakani\Pictures\',str],'IncludeSubfolders',true,'LabelSource','foldernames');
    %Preprocessing - CropImages
    cropandsave(ds1,str);
end
 im = imageDatastore('C:\Users\mmakani\Pictures\croppedfaces\','IncludeSubfolders',true,'LabelSource','foldernames');

% Preprocessing - Scaling 
im.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
% Divide the data into train (80% - 800 images) and test (20% - 200 images)
[Train ,Test] = splitEachLabel(im,0.8,'randomized');
% Create Network by modifying AlexNet
fc = fullyConnectedLayer(n);
net = alexnet;
ly = net.Layers;
ly(23) = fc;
cl = classificationLayer;
ly(25) = cl; 
% the learning_rate
learning_rate = 0.00001;
opts = trainingOptions("rmsprop","InitialLearnRate",learning_rate,'MaxEpochs',5,'MiniBatchSize',64,'Plots','training-progress');
[newnet,info] = trainNetwork(Train, ly, opts);
[predict,scores] = classify(newnet,Test);
names = Test.Labels;

%Find the accuracy rate
pred = (predict==names);
s = size(pred);
accuracyRate = sum(pred)/s(1);
fprintf('Accuracy Percentage= %.2f\n',accuracyRate*100);

%Find the misclassification rate
misclassified = (predict~=names);
s = size(misclassified);
misClassificationRate = sum(misclassified)/s(1);
fprintf('MisClassificationRate Percentage= %.2f\n',misClassificationRate*100);

%Confusion chart - %expected output vs true output.
confusionchart(Test.Labels,predict);

% Test a new Image
% use code below with giving path to your new image
% img = imread('C:\Users\mmakani\Pictures\s03\image145.jpg');
% [img,face] = cropface(img);
% %face value is 1 when it detects face in image or 0
% if face == 1
%  img = imresize(img,[227 227]);
%  [predict,score] = classify(newnet,img)
% end
% nameofs01 = 'name of subject 1';
% nameofs02 = 'name of subject 2';
% nameofs03 = 'name of subject 3';
% if predict=='s01'
%   fprintf('The face detected is %s',nameofs01);
% elseif  predict=='s02'
%   fprintf('The face detected is %s',nameofs02);
% elseif  predict=='s03'
%   fprintf('The face detected is %s',nameofs03);
% else
%     fprintf('No face has been detected');
% end	 
% %  can use [predict,score] = classify(newnet,img) here score says the percentage that how confidence it is

