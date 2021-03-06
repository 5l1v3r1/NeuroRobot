
im3 = flipud(255 - ((255 - imread('workspace2.jpg'))));
im = mean(im3, 3);
im = im > 200;

% im = imerode(im, ones(80));
im = imerode(im, ones(200));

cc = bwconncomp(im);
numPixels = cellfun(@numel,cc.PixelIdxList);
[biggest,idx] = max(numPixels);

figure(1)
clf
imagesc(im)
set(gca, 'ydir', 'normal')
hold on

[y, x] = ind2sub([1283 1283], cc.PixelIdxList{idx});

plot(x, y, 'marker', '.', 'linestyle', 'none', 'markersize', 5, 'color', 'r')

x = x / max(x);
y = y / max(y);
% x = (x * 5) - 3;
% y = (y * 5.3) - 3;
x = (x * 4.9) - 3;
y = (y * 5) - 3;

brain_im_xy = [x y];
save('brain_im_xy', 'brain_im_xy');
