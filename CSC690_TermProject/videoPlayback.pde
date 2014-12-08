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

void resizeImage(PImage img) {
//  float imgHeight = img.height; 
//  float imgWidth = img.width; 
//  float imgRatio = imgWidth/imgHeight; 
//  if (fullscreenMode) { //If in fullscreen
//    if (thumbRatio > imgRatio) { //If thumbnail width is larger than img height
//      thumbHeight = fullHeight-(border*2); 
//      thumbWidth = (fullHeight-(border*2)) * imgRatio;
//    } else if (thumbRatio < imgRatio) {  //If thumbnail width is larger than img height
//      thumbHeight = (fullWidth-(border*2)) * (1/imgRatio); 
//      thumbWidth = (fullWidth-(border*2));
//    } else {//If thumbnail ratio was equal to img
//      thumbHeight = fullHeight-(border*2); 
//      thumbWidth = fullWidth-(border*2);
//    }
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
