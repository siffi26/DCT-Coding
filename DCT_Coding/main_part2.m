[y,d] = zonal('lena.raw', 32, 10);
fprintf('The MSE is: %f\n', y);
fprintf('The Entropy is: %f\n', d);