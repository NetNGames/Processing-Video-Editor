void draw() {
  background(0);
  stroke(#FFFFFF);
  rect(0, 0, playbackWidth, playbackHeight);

  if (vidLoaded) {
    //determine aspect ratio and scale accordingly:
    image(mov, 0, 0, playbackWidth, playbackHeight);
    currentFrame = getFrame();
    //pixelated?
    if (isPixelate) {
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
    //Bottom progress bar
    stroke(#FF0000);
    strokeWeight(10);
    //if (showTimeline) {
    rect(0, height-109, //Located on bottom of screen
    (currentFrame/ maxFrames)*(width-100), //Scaled to window width
    1);
    //}
  }

  if (audLoaded) {
    //sound.play();

    if (mov.time()==0.0) { //If movie reset
      sound.rewind();    //Rewind audio file
    }
  }
  if (srtLoaded && 
      (vidLoaded||audLoaded)&&//){// &&
      currentFrame!=(-1.0)) {
        //println(currentFrame);
    displaySubs();
  }
} 
