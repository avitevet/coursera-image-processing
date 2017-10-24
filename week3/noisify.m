function noisyImg = noisify( cleanImg, N, noiseType )
  for i = 1:N
    noisyImg = imnoise(cleanImg, noiseType);
  end
end
  