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
    float current = mov.time();
    //    float max = mov.duration();
    String time = formatTime(current)+" / "+formatTime(maxDuration);
    textSize(12);
    text(time, width-220, height-140);
    //OLD PROGRESS BAR REPLACED BY TIMELINE
    /*/Bottom progress bar
     stroke(#FF0000);
     strokeWeight(10);
     //if (showTimeline) {
     rect(0, height-109, //Located on bottom of screen
     (currentFrame/ maxFrames)*(width-100), //Scaled to window width
     1);
     //}*/
    //  println("current time: "+mov.time());
  }

  if (audLoaded) {
    //sound.play();
    if (vidLoaded) {
      if (mov.time()==0.0) { //If movie reset
        sound.rewind();    //Rewind audio file
      }
    }
  }
  drawSubTimeline();
  //  if (srtLoaded && 
  //     (vidLoaded||audLoaded) &&
  //     (currentFrame!=(-1.0))) {
  //println(currentFrame);
  if (vidLoaded&& !subs.captions.isEmpty()) {
    displaySubs();
    drawSubsOnTimeline();
  }
  //  println("max duration: "+maxDuration);
  drawFileList();
  timeline.update();
  timeline.draw();
} 
void updateLocations() {
  //  playbackWidth=3*width/4;
  playbackWidth=width-200;
  timelineWidth=playbackWidth-90;
  //  playbackHeight=7*height/10;
  playbackHeight=height-160;
  chooseFileButton.setPosition(width-130, 10);
  pauseButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40);
  playButton.setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40);
  stopButton.setPosition(playbackWidth/2+(iconWidth*3)/4, height-40);
  prevButton.setPosition(playbackWidth/2-iconWidth*2, height-40);
  nextButton.setPosition(playbackWidth/2+iconWidth*2, height-40);
  subCfg.popup.setPosition(width-220, height-64);
}

