void draw() {
  background(0);
  updateLocations();
  stroke(#FFFFFF);
  if (!vidLoaded&&!audLoaded) {
    //    imageMode(CORNER);
    //  image(empty, 0, 0, playbackWidth, playbackHeight);

    fill(255);
    rect(0, 0, playbackWidth, playbackHeight);
    resizeImg();
    imageMode(CENTER);
    image(empty, playbackWidth/2, playbackHeight/2, thumbWidth, thumbHeight);
  }
  if (vidLoaded) {
    //determine aspect ratio and scale accordingly:
    resizeMovie();
    imageMode(CENTER);
    image(mov, playbackWidth/2, playbackHeight/2, thumbWidth, thumbHeight);
    //    image(mov, 0, 0, playbackWidth, playbackHeight);
    //    currentFrame = getFrame();
    //pixelated?
    if (isPixelate) {
      pixelate();
    }
    if (isGreyscale) {
      greyscale();
    }
    if (isInverted) {
      invert();
    }
    if (isPosterize) {
      posterize();
    }
  }
//background(0);
fill(0);
    rect(playbackWidth, 0, width, height);
    rect(0, playbackHeight, width, height);
  if (audLoaded) {
    //sound.play();
    if (vidLoaded) {
      if (mov.time()==0.0) { //If movie reset
        sound.rewind();    //Rewind audio file
      }
    }
  }
  
  timeline.update();
  if (!fullscreenMode) {
    drawFileList();
  drawSubTimeline();
    timeline.draw();
  }
  if (vidLoaded&& !subs.captions.isEmpty()) {
    displaySubs();
    if (!fullscreenMode) {
    drawSubsOnTimeline();
    }
  }
} 
void updateLocations() {
  if (!fullscreenMode) {
    //  playbackWidth=3*width/4;
    playbackWidth=width-200;
    timelineWidth=playbackWidth-90;
    //  playbackHeight=7*height/10;
    playbackHeight=height-160;
    chooseFileButton.setPosition(width-130, 10).setVisible(true);
    pauseButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40);
    playButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40).setVisible(true);
    stopButton.setPosition(playbackWidth/2+(iconWidth*3)/4, height-40).setVisible(true);
    prevButton.setPosition(playbackWidth/2-iconWidth*2, height-40).setVisible(true);
    nextButton.setPosition(playbackWidth/2+iconWidth*2, height-40).setVisible(true);
    subCfg.popup.setPosition(width-220, height-64).setVisible(true);
  } else {
    playbackWidth=width;
    timelineWidth=width;
    playbackHeight=height;
    chooseFileButton.setVisible(false);
    pauseButton.setVisible(false);
    playButton.setVisible(false);
    stopButton.setVisible(false);
    prevButton.setVisible(false);
    nextButton.setVisible(false);
    subCfg.popup.setVisible(false);
    
  }
}

