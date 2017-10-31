function [H, C, R] = hough-transform-circle(BW, varargin)
  % compute Standard Hough Transform for circles for the given input
  %% input parameters
  % BW: a black & white image containing pixels with values 0 & 1
  
  %% Name-value pair arguments
  % 'XResolution' - spacing of Hough transform buckets along the x axis.
  % Must be an integral value.  Default 1.
  % 'YResolution' - spacing of Hough transform buckets along the y axis.
  % Must be an integral value.  Default 1.
  % 'Radius' - radius values for the corresponding column of the
  % output matrix H.  Default 1:1:100

  [height width] = size(BW);
  
  %% input name-value pair parameter parsing
  p = inputParser;
  addRequired(p, 'BW');
  addParameter(p, 'XResolution', 1, @(x) isnumeric(x) && (x > 0) && (x < width));
  addParameter(p, 'YResolution', 1, @(x) isnumeric(x) && (x > 0) && (x < height));
  addParameter(p, 'Radius', 1:1:100, @isnumeric);
  addParameter(p, 'Epsilon', 1, @isnumeric);
  
  parse(p, BW, varargin{:});
  
  % these could be non-integers
  XResolution = p.Results.XResolution;
  YResolution = p.Results.YResolution;

  % compute the possible circle centers
  % these could be non-integers
  Xs = 1:XResolution:width;
  Ys = 1:YResolution:height;

  %% create and fill out the Hough voting matrix
  H = zeros(numel(Ys), numel(Xs), numel(p.Results.Radius));
  
  rSqs = p.Results.Radius .* p.Results.Radius;
  
  % for every center, and for every point "near" that center, and for every radius, vote 1
  % if (x - X0)^2 + (y - Y0)^2 == r^2
  for y = Ys
      for x = Xs
        for rSq = rSqs
            % bounds checking
            upperLeftX = floor(x - r);
            upperLeftY = floor(y - r);
            lowerRightX = ceil(x + r);
            lowerRightY = ceil(y + r);
            
            if (upperLeftY < 1) or (lowerRightY > height) or (upperLeftX < 1) or (lowerRightX > width)
                continue
            end
            
            % examine the points in the region surrounding the center
            yindices = upperLeftY:lowerRightY;
            xindices = upperLeftX:lowerRightX;
            
            ydiffs = yindices - y;
            xdiffs = xindices - x;
            
            ydiffsSq = ydiffs .* ydiffs;
            xdiffsSq = xdiffs .* xdiffs;
            
            if (
            
          
end