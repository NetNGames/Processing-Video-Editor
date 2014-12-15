int ys = 25;
int yi = 15;
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
    if (!subCfg.subPopup.isVisible()) {
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
  }
  //Makes sure video effects don't effect control panel
  fill(0);
  rect(playbackWidth, 0, width, height);
  rect(0, playbackHeight, width, height);
  if (audLoaded) {
    //sound.play();
    if (vidLoaded) {
      if (mov.time()==0.0) { //If movie reset
        sound.rewind();    //Rewind audio file
      }
    } else if (!vidLoaded) {
      meta = sound.getMetaData();
      int y = ys;
      fill(255);
      textSize(12);
      textAlign(CORNER);
      text("File Name: " + meta.fileName(), 10, y);
      text("Length (in milliseconds): " + meta.length(), 10, y+=yi);
      text("Title: " + meta.title(), 10, y+=yi);
      text("Author: " + meta.author(), 10, y+=yi); 
      text("Album: " + meta.album(), 10, y+=yi);
      text("Date: " + meta.date(), 10, y+=yi);
      text("Comment: " + meta.comment(), 10, y+=yi);
      text("Track: " + meta.track(), 10, y+=yi);
      text("Genre: " + meta.genre(), 10, y+=yi);
      text("Copyright: " + meta.copyright(), 10, y+=yi);
      text("Disc: " + meta.disc(), 10, y+=yi);
      text("Composer: " + meta.composer(), 10, y+=yi);
      text("Orchestra: " + meta.orchestra(), 10, y+=yi);
      text("Publisher: " + meta.publisher(), 10, y+=yi);
      text("Encoded: " + meta.encoded(), 10, y+=yi);
    }
  }

  timeline.update();
  if (!fullscreenMode) {
    drawFileList();
    drawSubTimeline();
    timeline.draw();
  }
  //Subs display only if audio or video is loaded
  if ((vidLoaded || audLoaded) && !subs.captions.isEmpty()) {
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
    cp5.getController("timeline").setPosition(60, height-150);    
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-timelineWidth-55).setPaddingY(-9);
    chooseFileButton.setPosition(width-180, 10).setVisible(true);
    saveButton.setPosition(width-180, playbackHeight-30).setVisible(true);
    saveSRTButton.setPosition(width-90, playbackHeight-30).setVisible(true);
    clearFileButton.setPosition(width-90, 10).setVisible(true);
    vidList.setPosition(width-190, 70).setVisible(true);
    audList.setPosition(width-190, 220).setVisible(true);
    //Playback Buttons
    if (!playButton.isVisible()) {
      pauseButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40).setVisible(true);
    }
    if (!pauseButton.isVisible()) {
      playButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40).setVisible(true);
    }
    stopButton.setPosition(playbackWidth/2+(iconWidth*3)/4, height-40).setVisible(true);
    prevButton.setPosition(playbackWidth/2-iconWidth*2, height-40).setVisible(true);
    nextButton.setPosition(playbackWidth/2+iconWidth*2, height-40).setVisible(true);
    subCfg.popup.setPosition(width-220, height-64).setVisible(true);
  } else {
    playbackWidth=width;
    timelineWidth=width;
    playbackHeight=height;
    cp5.getController("timeline").setPosition(0, height-10);
    chooseFileButton.setVisible(false);
    clearFileButton.setVisible(false);
    saveButton.setVisible(false);
    saveSRTButton.setVisible(false);
    vidList.setVisible(false);
    audList.setVisible(false);
    pauseButton.setVisible(false);
    playButton.setVisible(false);
    stopButton.setVisible(false);
    prevButton.setVisible(false);
    nextButton.setVisible(false);
    subCfg.popup.setVisible(false);
  }
}

