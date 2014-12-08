void draw() {
  background(0);
  stroke(#FFFFFF);
  fill(255);
  rect(0, 0, playbackWidth, playbackHeight);
  image(loadImage("empty-project.png"), 0, 0, playbackWidth, playbackHeight);
  if (vidLoaded) {
    //determine aspect ratio and scale accordingly:
    image(mov, 0, 0, playbackWidth, playbackHeight);
    currentFrame = getFrame();
    //pixelated?
    if (isPixelate) {
      pixelate();
    }
    float current = mov.time();
    float max = mov.duration();
    String time = formatTime(current)+" / "+formatTime(max);
    textSize(12);
    text(time, 620, playbackHeight+20);
    //OLD PROGRESS BAR REPLACED BY TIMELINE
    /*/Bottom progress bar
     stroke(#FF0000);
     strokeWeight(10);
     //if (showTimeline) {
     rect(0, height-109, //Located on bottom of screen
     (currentFrame/ maxFrames)*(width-100), //Scaled to window width
     1);
     //}*/
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
  if (srtLoaded && 
     (vidLoaded||audLoaded) &&
     (currentFrame!=(-1.0))) {
    //println(currentFrame);
    displaySubs();
    drawSubsOnTimeline();
  }

  drawFileList();
  timeline.draw();
  timeline.update();
} 

