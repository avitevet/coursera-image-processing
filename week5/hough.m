function [H, T, R] = hough(BW)
  # compute Standard Hough Transform for the given input
  
  # the thetas that will be used to generate rho for every non-zero pixel in the image
  T = linspace(-90, 89, 180);
  thetasRad = T * pi / 180;
  
  thetaTransform = [cos(thetasRad); sin(thetasRad)];
  
  [width, height] = size(BW);
  
  # find the linear indices of the pixels whose values are 1
  allones = find(BW);
  
  # convert the linear indices to X, Y coordinates
  # Xs contains elements in [0, width - 1]
  # Ys contains elements in [1, height]
  Xs = int32(allones / width);
  Ys = allones - Xs * width;
  
  # adjust the Xs so they are in [1, width]
  Xs = Xs + 1;
    
  points = [Xs Ys];
  
  # for every point, compute rho for every theta
  rhos = double(points) * thetaTransform;
  
  # discretize rhos
  rhos = int32(rhos);

  # determine rho buckets
  maxRho = max(max(rhos));
  minRho = min(min(rhos));
  R = linspace(minRho, maxRho, maxRho - minRho + 1);
  H = zeros(maxRho + 1 - minRho, size(T, 2));
  rhoIndexOffset = -minRho + 1;
  
  # determine offset for the theta index
  thetaIndexOffset = -min(min(T)) + 1;
  
  rhoIndexOffsets = rhos + rhoIndexOffset;
  thetaIndexOffsets = T + thetaIndexOffset;
  
  # put the rhos into buckets
  for thetaCol = [thetaIndexOffsets; rhoIndexOffsets]
    theta = thetaCol(1);
    for rhoIndex = thetaCol(2:end)'
      H(rhoIndex, theta) = H(rhoIndex, theta) + 1;
    end
  end
end