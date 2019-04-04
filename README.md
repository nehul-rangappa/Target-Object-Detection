# Target-Object-Detection
This is project developed in matlab which helps in the target object detection in a big scenario image

Project Description:
	Our Project is Detection of the target object in the query/scene image based on the reference image of the object we give as a input based on Feature Extraction. Feature points are used for object detection in the given input image by detecting a set of features in a reference image and matching features between the reference image and the input image. 

Methodology:
1.The objects to be detected from that query image are first taken as input training images such as book,stapler,toys,etc
2. Convert the input images to grayscale using grayscale conversion.
3. Detecting the Features using the SURF features detection which implements the SURF(Speeded- Up Robust  Features) algorithm for the blob features detection.
4. Then the features are extracted based on the SURFPoints which are obtained by the SURF features detection.
5. After Extracting features of that target object & query image. Then match the features of both the images based on the extracted features of both the images.
6. Now in some cases, there are matched points among the two images which are not actually belong to the object are called as outlier points.
7. These outlier points should be excluded and only Inlier points are considered for the detection of target object.
8. At final stage by comparing all features of that target object from query image, the target object is detected in query image.
