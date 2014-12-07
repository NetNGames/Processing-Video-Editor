void mousePressed() {
  if ((mouseY > playbackHeight) && (mouseY < playbackHeight+30) && 
        mouseX > 60 && mouseX < playbackWidth) {
    isJump=true;
//    if (vidLoaded) { 
//      float whereToJump = ((float)(mouseX-60)/(float)(playbackWidth))*maxFrames;
//      setFrame(ceil(whereToJump));
//    }
//    if (audLoaded) { 
//      float audioJump = ((float)(mouseX-60)/(float)(playbackWidth))*sound.length();
//      sound.cue(ceil(audioJump));
//    }
  }

  if (mouseY > 400 && mouseY < 410 && mouseX > 60 && mouseX < 610) {
    float clipPlaced=(((float)(mouseX-60)/(float)550)*(float)cp5.getController("timeline").getMax());
    println("adding at " + clipPlaced);
//    println(cp5.getController("timeline").getMax());
    timeline.addClip(clipPlaced);
  }
}

void mouseReleased() {
  isJump=false;
}

//----------Video Effects----------\\
void mouseMoved() {
  if ((mouseX > (0)) && (mouseX < 80) &&
    (mouseY > (0)) && (mouseY < 30)) {
    pixelateButton.setVisible(true);
    pixelateButton.unlock();
  } else if ((mouseX > (60)) && (mouseX < 610) &&
    (mouseY > (370)) && (mouseY < 380)) { 
//    timeline.unlock();
  } else {
    pixelateButton.setVisible(false);
    pixelateButton.lock();
//    timeline.lock();
  }
  //  if ((mouseY > (height-30)) && (mouseY < height)) {
  //    showTimeline = true;
  //  } else {
  //    showTimeline = false;
  //  }
//  println("mouse: ("+mouseX+", "+mouseY+")");
}
void controlEvent(ControlEvent theEvent) {
  //Video Effects
  if (theEvent.controller().name()=="pixelateButton") {
    if (!pixelateButton.isLock()) {//Will not activate if mouse is not over button
      if (isPixelate) {
        isPixelate=false;
      } else if (!isPixelate) {
        isPixelate=true;
      }
    }
  } else if (theEvent.controller().name()=="chooseFile") {
    loadFile();

    //Playback Buttons
  } else if (theEvent.controller().name()=="pauseButton") {
    playButton.setVisible(true);
    pauseButton.setVisible(false);
    if (vidLoaded) { 
      mov.pause();
    }
    if (audLoaded) { 
      sound.pause();
    }
  } else if (theEvent.controller().name()=="playButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    if (vidLoaded) { 
      mov.play();
    }
    if (audLoaded) { 
      sound.play();
    }
  } else if (theEvent.controller().name()=="stopButton") {
    playButton.setVisible(true);
    pauseButton.setVisible(false);
    if (vidLoaded) {
      mov.jump(0); 
      mov.pause();
    }
    if (audLoaded) {  
      sound.rewind();
      sound.pause();
    }
  } else if (theEvent.controller().name()=="prevButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    if (vidLoaded) {
      mov.pause();
      mov=movies.get(0);
      mov.jump(0); 
      mov.jump(0); 
      mov.play();
    }
    if (audLoaded) {  
      sound.rewind();
      sound.pause();
      sound=sounds.get(0);
      sound.rewind();
      sound.play();
    }
  } else if (theEvent.controller().name()=="nextButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    if (vidLoaded) {
      mov.pause();
      mov=movies.get(1);
      mov.jump(0); 
      mov.jump(0); 
      mov.play();
    }
    if (audLoaded) {  
      sound.rewind();
      sound.pause();
      sound=sounds.get(1);
      sound.rewind();
      sound.play();
    }

    //Timeline
  } else if (theEvent.controller().name()=="timeline") {
//    if (!timeline.isLock()) {//Will not activate if mouse is not over button
      if (vidLoaded&& isJump) {
//                setFrame(ceil(timeline.videoJump));
        int jump=floor(cp5.getController("timeline").getValue());
        println(jump);
        cp5.getController("timeline").setValue(jump);
        setFrame(-jump); //Don't know why frame is negative
//        timeline.update();
      }
//      if (audLoaded) {  
//        //    sound.cue(ceil(timeline.time));
//      }
//    }
  }else if (theEvent.controller().name()=="clearClipsButton") {
    timeline.clearClips();
  }
}
void keyPressed() {
  if ((key == 'p') || (key == 'P')) {
    if (isPixelate) {
      isPixelate=false;
    } else if (!isPixelate) {
      isPixelate=true;
    }
  }
}

