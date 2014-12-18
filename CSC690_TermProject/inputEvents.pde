void mousePressed() {
  //  if ((mouseY > height-160) && (mouseY < height-130) && 
  //    mouseX > 60 && mouseX < timelineWidth) {
  //    isJump=true;
  //  }
  //For audio clips
  if (mouseY > height-90 && mouseY < height-80 && mouseX > 60 && mouseX < 60+timelineWidth) {
    float clipPlaced=(((float)(mouseX-60)/(float)timelineWidth)*(float)cp5.getController("timeline").getMax());
    println("adding at " + clipPlaced);
    //    println(cp5.getController("timeline").getMax());
    timeline.addAudioClip(clipPlaced);
  }
  //For video clips
  if (mouseY > height-120 && mouseY < height-110 && mouseX > 60 && mouseX < 60+timelineWidth) {
    //println("video clip pasted");
    float clipPlaced=(((float)(mouseX-60)/(float)timelineWidth)*(float)cp5.getController("timeline").getMax());
    timeline.addVideoClip(clipPlaced);
  }
  //For subtitles
  if (mouseY > height-60 && mouseY < height-50 && mouseX > 60 && mouseX < timelineWidth) {
    float clipPlaced=(((float)(mouseX-60)/(float)timelineWidth)*(float)cp5.getController("timeline").getMax());

    subCfg.startTimeInput.setText(formatTime(clipPlaced));
    subCfg.endTimeInput.setText(formatTime(clipPlaced+3));
    subCfg.subtitleInput.setFocus(true);
    subCfg.subPopup.setVisible(true);

    //    println("adding at " + clipPlaced);
    //    //    println(cp5.getController("timeline").getMax());
    //    timeline.addClip(clipPlaced);
  }

  //Audio file selection
  //  if (mouseY > 200 && mouseX > width-190 && mouseY < 200+(16*sounds.size())) {
  //    //println((mouseY-200)/16);
  //    soundPicked = (mouseY-200)/16;
  //  }
}

void mouseReleased() {
  //  isJump=false;
  subCfg.subtitleInput.setFocus(true);
}

//----------Video Effects----------\\
void mouseMoved() {
  if ((mouseX > (0)) && (mouseX < 80) &&
    (mouseY > (0)) && (mouseY < 30)) {
    fullscreenButton.setVisible(true);
    fullscreenButton.unlock();
    //  } else if ((mouseX > (60)) && (mouseX < 610) &&
    //    (mouseY > (370)) && (mouseY < 380)) {
  } else {
    fullscreenButton.setVisible(false);
    fullscreenButton.lock();
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    //Select audio to place on timeline
    if (theEvent.getGroup().getName() == "audList") {
      soundPicked = (int)theEvent.getGroup().getValue();

      //Select video to play
    } else if (theEvent.getGroup().getName() == "vidList") {
      currentSelected = (int)theEvent.getGroup().getValue();
      mov.pause();
      mov=movies.get(currentSelected);
      mov.jump(0); 
      mov.pause();
      //      mov.play();

      //Video Effects
    } else if (theEvent.getGroup().getName() == "vidEffectList") {
      int effect = (int)theEvent.getGroup().getValue();
      if (effect==0) {//Invert 
        if (isInverted) {
          isInverted=false;
        } else if (!isInverted) {
          isInverted=true;
        }
      } else if (effect==1) {//"Greyscale") {
        if (isGreyscale) {
          isGreyscale=false;
        } else if (!isGreyscale) {
          isGreyscale=true;
        }
      } else if (effect==2) {//"Posterize"
        if (isPosterize) {
          isPosterize=false;
        } else if (!isPosterize) {
          isPosterize=true;
        }
      } else if (effect==3) {//Pixelate
        if (isPixelate) {
          isPixelate=false;
        } else if (!isPixelate) {
          isPixelate=true;
        }
      } else if (effect==4) {//Reset
        isInverted = false;
        isGreyscale = false;
        isPosterize = false;
        isPixelate = false;
      }
    }
  }
  if (theEvent.controller().name()=="fullscreenButton") {
    if (!fullscreenButton.isLock()) {//Will not activate if mouse is not over button
      if (fullscreenMode) {
        fullscreenMode=false;
      } else if (!fullscreenMode) {
        fullscreenMode=true;
      }
    }


    //File Input
  } else if (theEvent.controller().name()=="chooseFile") {
    loadFile();
  } else if (theEvent.controller().name()=="saveButton") {
    savePVEFile();
  } else if (theEvent.controller().name()=="saveSRTButton") {
    saveSubFile();
  } else if (theEvent.controller().name()=="clearProjectButton") {
    maxDuration=0;
    movies.clear();
    movieNames.clear();
    sounds.clear();
    soundNames.clear();
    timeline.clearClips();
    subs.captions.clear();
    vidList.clear().setCaptionLabel("No video files loaded");
    audList.clear();
    vidLoaded=false;
    audLoaded=false;
    srtLoaded=false;
    isInverted = false;
    isGreyscale = false;
    isPosterize = false;
    isPixelate = false;

    //Playback Buttons
  } else if (theEvent.controller().name()=="pauseButton") {
    playButton.setVisible(true);
    pauseButton.setVisible(false);
    if (vidLoaded) { 
      mov.pause();
    }
    if (audLoaded) { 
      //      sound.pause();
      for (int i = 0; i < sounds.size (); i++) {
        sounds.get(i).pause(); //Pauses all sounds
      }
    }
  } else if (theEvent.controller().name()=="playButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    if (vidLoaded) { 
      mov.play();
    }
    if (audLoaded && !vidLoaded) { 
      sound.play();
      //        sounds.get(soundPicked).play();
    }
  } else if (theEvent.controller().name()=="stopButton") {
    playButton.setVisible(true);
    pauseButton.setVisible(false);
    if (vidLoaded) {
      mov.jump(0); 
      mov.pause();
    }
    if (audLoaded) {  
      //      sound.rewind();
      //      sound.pause();
      for (int i = 0; i < sounds.size (); i++) {
        sounds.get(i).pause();
        sounds.get(i).rewind();
      }
    }
  } else if (theEvent.controller().name()=="prevButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    if (currentSelected>0) {
      currentSelected--;
    }
    if (vidLoaded) {
      mov.pause();
      mov=movies.get(currentSelected);
      mov.jump(0); 
      mov.play();
    }
    //    if (audLoaded) {  
    //      sound.rewind();
    //      sound.pause();
    //      sound=sounds.get(currentSelected);
    //      sound.rewind();
    //      sound.play();
    //    }
  } else if (theEvent.controller().name()=="nextButton") {
    playButton.setVisible(false);
    pauseButton.setVisible(true);
    currentSelected++;
    if (vidLoaded) {
      mov.pause();
      mov=movies.get(currentSelected);
      //    if (movItr.hasNext()) {
      //                  mov = movItr.next();
      //                  currentSelected=movNamesItr.previousIndex();
      //              }
      mov.jump(0); 
      mov.play();
    }
    //    if (audLoaded) {  
    //      sound.rewind();
    //      sound.pause();
    //      sound=sounds.get(currentSelected);
    //      sound.rewind();
    //      sound.play();
    //    }

    //Timeline
  } else if (theEvent.controller().name()=="timeline") {
    //    if (isJump) {//Will not activate if mouse is not over button
    //      int jump=floor(cp5.getController("timeline").getValue());
    float jump=cp5.getController("timeline").getValue();
    //    println("jumping: "+jump);
    if (vidLoaded) {
      cp5.getController("timeline").setValue(jump);
      if (jump<leftOffset) { //If skipping backwards
        currentSelected--;
        if (vidLoaded) {
          mov.pause();
          mov=movies.get(currentSelected);
          mov.jump(jump); 
          mov.play();
        }
        if (audLoaded) {  
          sound.rewind();
          sound.pause();
          //          sound=sounds.get(currentSelected);
          sound=sounds.get(soundPicked);
          sound.rewind();
        }
      } else if (jump>mov.duration()+leftOffset) {//If skipping forwards

        currentSelected++;
        if (vidLoaded) {
          mov.pause();
          mov=movies.get(currentSelected);
          mov.jump(jump-movies.get(currentSelected-1).duration()); 
          mov.play();
        }
        if (audLoaded) {  
          sound.rewind();
          sound.pause();
          //          sound=sounds.get(currentSelected);
          sound=sounds.get(soundPicked);
          sound.rewind();
        }
      } else if (jump<=mov.duration()+leftOffset) {//If skipping within same movie
        //        println("jumping to same movie: "+jump);
        mov.jump(jump-leftOffset);
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
      if (vidLoaded) {
        subCfg.startTimeInput.setText(formatTime(mov.time()));
        subCfg.endTimeInput.setText(formatTime(mov.time()+3));
      } else if (!vidLoaded && audLoaded) {
        subCfg.startTimeInput.setText(formatTime(sound.position()/1000.0));
        subCfg.endTimeInput.setText(formatTime(sound.position()/1000.0+1.5));
      }
      subCfg.subtitleInput.setText("");
      subCfg.subPopup.setVisible(true);
    } else {
      subCfg.subtitleInput.setText("");
      subCfg.subPopup.setVisible(false);
    }
  } else if (theEvent.controller().name()=="cancelButton") {
    subCfg.subtitleInput.setText("");
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
  if (!subCfg.subPopup.isVisible()) { //Do not activate when typing subtitles
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

    if ((key == 'o') || (key == 'O')) {
      if (isPosterize) {
        isPosterize=false;
      } else if (!isPosterize) {
        isPosterize=true;
      }
    }

    if ((key == 'f') || (key == 'F')) {
      if (fullscreenMode) {
        fullscreenMode=false;
      } else if (!isInverted) {
        fullscreenMode=true;
      }
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

