void pixelate() {
  mov.loadPixels();

  for (int i = 0; i < width/blockSize; i++) {
    for (int j = 0; j < height/blockSize; j++) {
      movColors[i][j] = mov.get(i*blockSize, j*blockSize);
    }
  }
  for (int i = 0; i < width/blockSize; i++) {
    for (int j = 0; j < height/blockSize; j++) {
      noStroke();
      fill(movColors[i][j]);
      rect(i*blockSize, j*blockSize, blockSize, blockSize);
    }
  }
}

