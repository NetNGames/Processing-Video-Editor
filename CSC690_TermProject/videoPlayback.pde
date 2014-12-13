//----------Video Playback----------\\
//From Frames video example
int getFrame() {
  return ceil(mov.time() * movFrameRate) - 1;
}
int getLength() {
  return int(mov.duration() * movFrameRate);
}  
void setFrame(int n) {
  //mov.play();

  // The duration of a single frame:
  float frameDuration = 1.0 / movFrameRate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = mov.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  mov.jump(where);
}

void resizeMovie() {

  float movRatio = (float)mov.width/(float)mov.height; 
  float playbackRatio =(float)playbackWidth/(float)playbackHeight;
  println("movie ratio: "+movRatio);
  println("playbackRatio: "+playbackRatio);
  //  if (fullscreenMode) { //If in fullscreen
  if (playbackRatio > movRatio) { //If playback width is larger than movie height
    thumbWidth = (int)(playbackHeight * movRatio);
    thumbHeight = (int)playbackHeight;
  } else if (playbackRatio < movRatio) {  //If thumbnail width is larger than img height
    thumbWidth= (int)playbackWidth;
    thumbHeight = (int)(playbackWidth * (1/movRatio));
  } else if (playbackRatio == movRatio) {//If thumbnail ratio was equal to img
    thumbWidth = (int)playbackWidth;
    thumbHeight = (int)playbackHeight;
  }
  //  } else { //not in fullscreen
  //    if (thumbRatio > imgRatio) { //If thumbnail width is larger than img height
  //      thumbHeight = windowHeight-(border/2); 
  //      thumbWidth = (windowHeight-(border/2)) * imgRatio;
  //    } else if (thumbRatio < imgRatio) {  //If thumbnail width is smaller than img height
  //      thumbHeight = (windowWidth-(border/2)) * (1/imgRatio); 
  //      thumbWidth = windowWidth-(border/2);
  //    } else {//If thumbnail ratio was equal to img's
  //      thumbHeight = windowWidth-(border/2); 
  //      thumbWidth = windowWidth-(border/2);
  //    }
  //  }
}
void resizeImg() {
  float imgRatio = (float)empty.width/(float)empty.height; 
  float playbackRatio =(float)playbackWidth/(float)playbackHeight;
//  println("movie ratio: "+movRatio);
//  println("playbackRatio: "+playbackRatio);
  //  if (fullscreenMode) { //If in fullscreen
  if (playbackRatio > imgRatio) { //If playback width is larger than movie height
    thumbWidth = (int)(playbackHeight * imgRatio);
    thumbHeight = (int)playbackHeight;
  } else if (playbackRatio < imgRatio) {  //If thumbnail width is larger than img height
    thumbWidth= (int)playbackWidth;
    thumbHeight = (int)(playbackWidth * (1/imgRatio));
  } else if (playbackRatio == imgRatio) {//If thumbnail ratio was equal to img
    thumbWidth = (int)playbackWidth;
    thumbHeight = (int)playbackHeight;
  }
}

