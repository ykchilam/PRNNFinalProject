# PRNNFinalProject
This is a Final project for Patter Recognition and Neural Networks. This repository contains 5 matlab scripts that can detect, verify and recognize faces. 
Face Detection - Change n to any integer in the detectionAndTracking code to change the number of images that you want to capture for each subject/person.
Change str to s01, s02, s03 to capture individual persons in a different folder. For face detection, look at the webcam and run detectionAndTracking code. To check the webcam support in your laptop or PC, look at this video:https://www.mathworks.com/videos/webcam-support-89504.html.

Face verification - This is very basic example that calculates the L2 norm between two images and verifies the two images based on the threshold distance. Just provide two similar people images and two distinct people images for testing. Run Faceverification.m for this.


Face Recognition - In order to recongize faces,a pre trained CNN, AlexNet is used. Run the code FaceRecognition.m


