//Implements video effects
Button fullscreenButton;
boolean isInverted = false;
boolean isGreyscale = false;
boolean isPosterize = false;
boolean isPixelate = false;
int effectPicked;
VideoEffectsConfig effectCfg;
String[] effectsList = {"Invert","Greyscale","Posterize", "Pixelate", "Reset"}; 

//For Pixelate effect
int numPixelsWide, numPixelsHigh;
int blockSize; //Should be a number that divides evenly into the height and width
color movColors[][];
//color movColors[];
void pixelate() {
  //  blockSize = 10;
  blockSize = (int)(((float)playbackWidth/(float)mov.width)*10.0);
  movColors = new color[playbackWidth/blockSize][playbackHeight/blockSize];
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

  //Old Pixelate using 1D array
  //  numPixelsWide = playbackWidth / blockSize;
  //  numPixelsHigh = playbackHeight / blockSize;
  //  movColors = new color[numPixelsWide * numPixelsHigh];
  //  mov.loadPixels();
  //    int count = 0;
  //    for (int j = 0; j < numPixelsHigh; j++) {
  //      for (int i = 0; i < numPixelsWide; i++) {
  //        movColors[count] = mov.get(i*blockSize, j*blockSize);
  //        count++;
  //      }
  //    }
  //    
  ////      background(0);
  //   for (int j = 0; j < numPixelsHigh; j++) {
  //    for (int i = 0; i < numPixelsWide; i++) {
  //      noStroke();
  //      fill(movColors[j*numPixelsWide + i]);
  //      rect(i*blockSize, j*blockSize, blockSize, blockSize);
  //    }
  //  }
}

void greyscale() {
  filter(GRAY);
}

void invert() {
  filter(INVERT);
}

void posterize() {
  filter(POSTERIZE, 4);
}
