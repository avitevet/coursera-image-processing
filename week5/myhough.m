function [H, T, R] = myhough(BW, varargin)
  % compute Standard Hough Transform for the given input
  %% input parameters
  % BW: a black & white image containing pixels with values 0 & 1
  
  %% Name-value pair arguments
  % 'RhoResolution' - spacing of Hough transform buckets along the rho
  % axis.  Default 1.
  % 'Theta' - Theta values in degrees for the corresponding column of the
  % output matrix H.  Default -90:1:89

  %% input name-value pair parameter parsing
  p = inputParser;
  addRequired(p, 'BW');
  addParameter(p, 'RhoResolution', 1, @(x) isnumeric(x) && (x > 0) && (x < norm(size(BW))));
  addParameter(p, 'Theta', -90:1:89, @isnumeric);
  
  parse(p, BW, varargin{:});
  
  T = p.Results.Theta;
  RhoResolution = p.Results.RhoResolution;
  
  %% compute the thetas that will be used to generate rho for every non-zero pixel in the image
  thetasRad = T * pi / 180;
  thetaTransform = [cos(thetasRad); sin(thetasRad)];
  
  %% find the y,x of the pixels whose values are 1, and
  % adjust indices so they are in [0, height - 1] and [0, width - 1]
  % instead of [1, height] and [1, width]
  [Ys, Xs] = find(BW);
  Ys = Ys - 1;
  Xs = Xs - 1;
  points = [Xs Ys];
  
  %% for every point, compute rho for every theta
  rhos = double(points) * thetaTransform;
  
  %% determine rho buckets
  % from https://www.mathworks.com/help/images/ref/hough.html:
  [height, width] = size(BW);
  D = sqrt((height - 1)^2 + (width - 1)^2);
  minRho = -RhoResolution*ceil(D/RhoResolution);
  maxRho = -minRho;
  R = minRho:RhoResolution:maxRho;
  
  %% setup H
  H = zeros(numel(R), numel(T));

  %% map theta values to indicies in H
  thetaIndexOffset = -min(min(T)) + 1;
  thetaIndices = T + thetaIndexOffset;
  
  %% map rho values to indices in H, including discretizing the values
  rhoIndexOffset = -minRho + 1;
  rhoIndices = rhos + rhoIndexOffset;
  rhoIndices = int32(rhoIndices);
  
  %% fill H with theta, rho values
  for thetaCol = [thetaIndices; rhoIndices]
    theta = thetaCol(1);
    for rhoIndex = thetaCol(2:end)'
      H(rhoIndex, theta) = H(rhoIndex, theta) + 1;
    end
  end
end