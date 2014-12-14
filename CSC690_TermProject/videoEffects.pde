//For Pixelate effect
Button pixelateButton;
boolean isPixelate = false;
int numPixelsWide, numPixelsHigh;
int blockSize = 10; //Should be a number that divides evenly into the height and width
color movColors[][];
void pixelate() {
  mov.loadPixels();

  for (int i = 0; i < playbackWidth/blockSize; i++) {
    for (int j = 0; j < playbackHeight/blockSize; j++) {
      movColors[i][j] = mov.get(i*blockSize, j*blockSize);
    }
  }
  for (int i = 0; i < playbackWidth/blockSize; i++) {
    for (int j = 0; j < playbackHeight/blockSize; j++) {
      noStroke();
      fill(movColors[i][j]);
      rect(i*blockSize, j*blockSize, blockSize, blockSize);
    }
  }
}

boolean isGreyscale = false;
void greyscale(){
  filter(GRAY);
}

boolean isInverted = false;
void invert(){
  filter(INVERT);
}
boolean isPosterize = false;
void posterize(){
  filter(POSTERIZE, 4);
}

