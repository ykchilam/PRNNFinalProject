Im1 = imread('374.jpg');
Im2 = imread('image139.jpg');%001.jpg

Im1 = rgb2gray(Im1);
Im2 = rgb2gray(Im2);

hn1 = imhist(Im1)./numel(Im1);
hn2 = imhist(Im2)./numel(Im2);

% Calculate the L2 Euclidean distance
f = norm(hn1-hn2)
if f<=0.07
    fprintf('Face verified, L2 Norm Distance is=%.4f',f);
    figure;
    subplot(2,2,1);
    imshow(Im1);
    title('Image 1');
    subplot(2,2,2);
    imshow(Im2);
    title('Image 2');
    sgtitle('Face Verified')
else
    fprintf('Face not verified, L2 Norm Distance is=%.4f',f);
    figure;
    subplot(2,2,1);
    imshow(Im1);
    title('Image 1');
    subplot(2,2,2);
    imshow(Im2);
    title('Image 2');
    sgtitle('Face Not Verified');
end

