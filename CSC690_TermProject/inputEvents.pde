void mousePressed() {
  if ((mouseY > playbackHeight) && (mouseY < playbackHeight+30) && 
    mouseX > 60 && mouseX < playbackWidth) {
    isJump=true;
  }
  //For audio clips
  if (mouseY > 430 && mouseY < 440 && mouseX > 60 && mouseX < 610) {
    float clipPlaced=(((float)(mouseX-60)/(float)550)*(float)cp5.getController("timeline").getMax());
    println("adding at " + clipPlaced);
    //    println(cp5.getController("timeline").getMax());
    timeline.addClip(clipPlaced);
  }
  //For subtitles
  if (mouseY > 460 && mouseY < 470 && mouseX > 60 && mouseX < 610) {
    float clipPlaced=(((float)(mouseX-60)/(float)550)*(float)cp5.getController("timeline").getMax());
//    println("adding at " + clipPlaced);
//    //    println(cp5.getController("timeline").getMax());
//    timeline.addClip(clipPlaced);
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
  } else {
    pixelateButton.setVisible(false);
    pixelateButton.lock();
  }
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
    if (isJump) {//Will not activate if mouse is not over slider
      int jump=floor(cp5.getController("timeline").getValue());
      if (vidLoaded) {
        cp5.getController("timeline").setValue(jump);
        setFrame(-jump); //Don't know why frame is negative
      }
      if (audLoaded) {  
        int max=floor(cp5.getController("timeline").getMax());
        float audJump=(((float)jump/(float)max)*(float)sound.length());
        sound.cue(floor(audJump));
      }
    }
  } else if (theEvent.controller().name()=="clearClipsButton") {
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

