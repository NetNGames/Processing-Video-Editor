void mousePressed() {
  if ((mouseY > (fullHeight-(heightDiff+20))) && (mouseY < playbackHeight) && mouseX < playbackWidth) {
    isJump=true;
    if (vidLoaded) { 
      float whereToJump = ((float)mouseX/(float)(width-widthDiff))*maxFrames;
      setFrame(ceil(whereToJump));
    }
    if (audLoaded) { 
      float audioJump = ((float)mouseX/(float)(width-widthDiff))*sound.length();
      sound.cue(ceil(audioJump));
    }
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
  } else {
    pixelateButton.setVisible(false);
    pixelateButton.lock();
  }
//  if ((mouseY > (height-30)) && (mouseY < height)) {
//    showTimeline = true;
//  } else {
//    showTimeline = false;
//  }
}
void controlEvent(ControlEvent theEvent) {
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
  } else if (theEvent.controller().name()=="pauseButton") {
    if (vidLoaded) { 
      mov.pause();
    }
    if (audLoaded) { 
      sound.pause();
    }
  } else if (theEvent.controller().name()=="playButton") {
    if (vidLoaded) { 
      mov.play();
    }
    if (audLoaded) { 
      sound.play();
    }
  } else if (theEvent.controller().name()=="stopButton") {
    if (vidLoaded) {
      mov.jump(0); 
      mov.pause();
    }
    if (audLoaded) {  
      sound.rewind();
      sound.pause();
    }
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
