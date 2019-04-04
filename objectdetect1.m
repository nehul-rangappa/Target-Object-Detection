close all
clear all
clc
startingFolder = 'C:\Users\nehul\OneDrive\Documents\MATLAB\Object-detection-using-matlab-master';
if ~exist(startingFolder, 'dir')
	startingFolder = pwd;
end
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uigetfile(defaultFileName, 'Select Reference file');
fullFileName = fullfile(folder, baseFileName);
RefImage = imread(fullFileName);
figure;
imshow(RefImage);
title('Reference Image');
  
startingFolder1 = 'C:\Users\nehul\OneDrive\Documents\MATLAB\Object-detection-using-matlab-master';

if ~exist(startingFolder1, 'dir')
	startingFolder1 = pwd;
end
defaultFileName1 = fullfile(startingFolder1, '*.*');
[baseFileName1, folder1] = uigetfile(defaultFileName1, 'Select the SceneImage file');
fullFileName1 = fullfile(folder1, baseFileName1);
sceneImage = imread(fullFileName1);
figure;
imshow(sceneImage);
title('Scene Image');


RefImage = imread(fullFileName);
RefImage=rgb2gray(RefImage);

sceneImage=imread(fullFileName1);
sceneImage=rgb2gray(sceneImage);

RefPoints = detectSURFFeatures(RefImage);
scenePoints = detectSURFFeatures(sceneImage);

figure; 
imshow(RefImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(RefPoints, 100));

figure; 
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

%%Extracting Features
[RefFeatures, RefPoints] = extractFeatures(RefImage, RefPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%%Matching Features
RefPairs = matchFeatures(RefFeatures, sceneFeatures);

matchedRefPoints = RefPoints(RefPairs(:, 1), :);
matchedScenePoints = scenePoints(RefPairs(:, 2), :);
    
if(matchedRefPoints.Count >=3) 
    if(matchedScenePoints.Count>=3)
        figure;
        %%Display(Matched features (Only Outliers)
        showMatchedFeatures(RefImage, sceneImage, matchedRefPoints, ...
            matchedScenePoints, 'montage');
        title('Putatively Matched Points (Including Outliers)');
        try
            %Extracting Inlier Points
            [tform, inlierRefPoints, inlierScenePoints] =  estimateGeometricTransform(matchedRefPoints, matchedScenePoints, 'affine');

            %%Display matched features (Only Inliers)
            figure;
            showMatchedFeatures(RefImage, sceneImage, inlierRefPoints, ...
                inlierScenePoints, 'montage');
            title('Matched Points (Inliers Only)');

            %%Constructing the polygon
            RefPolygon = [1, 1;...                           % top-left
                    size(RefImage, 2), 1;...                 % top-right
                    size(RefImage, 2), size(RefImage, 1);... % bottom-right
                    1, size(RefImage, 1);...                 % bottom-left
                    1, 1];                   % top-left again to close the polygon

            newRefPolygon = transformPointsForward(tform, RefPolygon);    

            %%Detect the reference image in cluttered image
            figure;
            imshow(sceneImage);
            hold on;
            line(newRefPolygon(:, 1), newRefPolygon(:, 2), 'Color', 'g');
            title('Detected Box');
        catch
             msgID = 'vision:points:notEnoughInlierMatches';
             msg = 'No matched Points';
             baseException = MException(msgID,msg);
        end
    else
        disp("No matching image")
    end
else
    disp("No matching image")
end