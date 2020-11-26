% Create the face detector object.
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART','MinSize',[150,150]);
n = 1000;
% change str to s01,s02,s03, etc. for different subjects
str = 's03';
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% Create the webcam object.
cam = webcam();
% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
runLoop = true;
numPts = 0;
frameCount = 0;
i=1;
while runLoop && frameCount < n
    % Get the next frame.
    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;
    if numPts < 10
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray);
        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));
            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);
            % Save a copy of the points.
            oldPoints = xyPoints;
            bboxPoints = bbox2points(bbox(1, :));
            bboxPolygon = reshape(bboxPoints', 1, []);
            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);
            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end
    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);
        numPts = size(visiblePoints, 1);
        if numPts >= 10
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            imwrite(videoFrame,[ 'C:\Users\mmakani\Pictures\',str,'\',int2str(i), '.jpg']);
            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);
            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');
            
            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
            i = i+1;
        end
    end
    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end
% Clean up.
clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);