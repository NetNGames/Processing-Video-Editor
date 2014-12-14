void mousePressed() {
  if ((mouseY > height-160) && (mouseY < height-130) && 
    mouseX > 60 && mouseX < timelineWidth) {
    isJump=true;
  }
  //For audio clips
  if (mouseY > height-90 && mouseY < height-80 && mouseX > 60 && mouseX < timelineWidth) {
    float clipPlaced=(((float)(mouseX-60)/(float)550)*(float)cp5.getController("timeline").getMax());
    println("adding at " + clipPlaced);
    //    println(cp5.getController("timeline").getMax());
    timeline.addClip(clipPlaced);
  }
  //For subtitles
  if (mouseY > height-60 && mouseY < height-50 && mouseX > 60 && mouseX < timelineWidth) {
    float clipPlaced=(((float)(mouseX-60)/(float)550)*(float)cp5.getController("timeline").getMax());

    subCfg.startTimeInput.setText(formatTime(clipPlaced));
    subCfg.endTimeInput.setText(formatTime(clipPlaced+3));
    subCfg.subtitleInput.setFocus(true);
    subCfg.subPopup.setVisible(true);

    //    println("adding at " + clipPlaced);
    //    //    println(cp5.getController("timeline").getMax());
    //    timeline.addClip(clipPlaced);
  }

  //Audio file selection
  if (mouseY > 200 && mouseX > width-190 && mouseY < 200+(16*sounds.size())) {
    //println((mouseY-200)/16);
    soundPicked = (mouseY-200)/16;
  }
}

void mouseReleased() {
  isJump=false;
  subCfg.subtitleInput.setFocus(true);
}

//----------Video Effects----------\\
void mouseMoved() {
  if ((mouseX > (0)) && (mouseX < 80) &&
    (mouseY > (0)) && (mouseY < 30)) {
    pixelateButton.setVisible(true);
    pixelateButton.unlock();
    //  } else if ((mouseX > (60)) && (mouseX < 610) &&
    //    (mouseY > (370)) && (mouseY < 380)) {
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

    //File Input
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
    /*if (audLoaded) { 
     sound.play();
     }*/
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
    currentSelected=0;
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
    currentSelected=1;
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
//    if (isJump) {//Will not activate if mouse is not over button
      //      int jump=floor(cp5.getController("timeline").getValue());
      float jump=cp5.getController("timeline").getValue();
      if (vidLoaded) {
        cp5.getController("timeline").setValue(jump);
        //        setFrame(-jump); //Don't know why frame is negative
        if (jump<=mov.duration()) {
          mov.jump(jump);
        } else {
        }
      }
      if (audLoaded) {  
        int max=floor(cp5.getController("timeline").getMax());
        float audJump=(((float)jump/(float)max)*(float)sound.length());
        sound.cue(floor(audJump));
      }
//    }
  } else if (theEvent.controller().name()=="clearClipsButton") {
    timeline.clearClips();


    //Subtitles
  } else if (theEvent.controller().name()=="popup") {
    if (!subCfg.subPopup.isVisible()) {
      subCfg.startTimeInput.setText(formatTime(mov.time()));
      subCfg.endTimeInput.setText(formatTime(mov.time()+3));
      subCfg.subtitleInput.setText("");
      subCfg.subPopup.setVisible(true);
    } else {
      subCfg.subPopup.setVisible(false);
    }
  } else if (theEvent.controller().name()=="cancelButton") {
    subCfg.subPopup.setVisible(false);
  } else if (theEvent.controller().name()=="submitButton") {
    addSubtitle(subCfg.startTimeInput.getText(), 
    subCfg.endTimeInput.getText(), 
    subCfg.subtitleInput.getText());
    subCfg.subtitleInput.setText("");
    subCfg.subPopup.setVisible(false);
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
  if ((key == 'g') || (key == 'G')) {
    if (isGreyscale) {
      isGreyscale=false;
    } else if (!isGreyscale) {
      isGreyscale=true;
    }
  }
  if ((key == 'i') || (key == 'I')) {
    if (isInverted) {
      isInverted=false;
    } else if (!isInverted) {
      isInverted=true;
    }
  }
  if ((key == 'f') || (key == 'F')) {
    if (fullscreenMode) {
      fullscreenMode=false;
    } else if (!isInverted) {
      fullscreenMode=true;
    }
  }
  if ((key == 'b') || (key == 'B')) {
    if (isPosterize) {
      isPosterize=false;
    } else if (!isPosterize) {
      isPosterize=true;
    }
  }
}

//Enables mouse wheel controls for controlP5 elements
//From ControlP5mouseWheel
void addMouseWheelListener() {
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  }
  );
}

