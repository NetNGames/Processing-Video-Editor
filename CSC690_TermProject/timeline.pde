class Timeline {
  float time, maxTime;
  Button clearClipsButton;
  Slider timelineSlider;
  Vector<TimelineClip> audioClips;
  Vector<TimelineClip> videoClips;

  Timeline() {
    timelineSlider = cp5.addSlider("timeline")
      .setPosition(60, playbackHeight+10)
        .setWidth(550)
          .setMin(0.0)
            .setValue(0.0)
              .setTriggerEvent(Slider.RELEASE) //Buggy if kept it on default PRESSED
                .setSliderMode(Slider.FLEXIBLE);
    clearClipsButton = cp5.addButton("clearClipsButton")
      .setPosition(620, 426)
        .setSize(70, 20)
          .setCaptionLabel("Clear")
            .setVisible(false);
    cp5.getTooltip().register("clearClipsButton", "Clear Audio clips currently on timeline");
    //    cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);

    audioClips = new Vector<TimelineClip>(0, 1);
  }

  void update() {
    if (vidLoaded) {
      //      timelineSlider.setVisible(true);
      cp5.getTooltip().register("timeline", "Click to jump to time");
      timelineSlider.setMax(abs((float)maxFrames));
      if (!isJump) {
        cp5.getController("timeline").setValue(abs(((float)currentFrame/ (float)maxFrames)*(float)maxFrames));
      }
      //      cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
      cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
//      time = floor(cp5.getController("timeline").getValue());
      time = cp5.getController("timeline").getValue();
      maxTime = floor(cp5.getController("timeline").getMax());

      //            println("current time: " + time);

      if (audLoaded) {
        for (int i = 0; i < audioClips.size (); i++) {
          TimelineClip clip = audioClips.get(i);
          //          println("   clip time: " + clip.getStart());
          if (time == clip.getStart()) {
            if (!sounds.get(0).isPlaying()) {
              sounds.get(0).rewind();
              sounds.get(0).play();
            }
          }
        }
      }
    }
  }

  void draw() {
    if(vidLoaded){
       fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Video:", 10, 410);
      //Draw box where video clips can be placed
      rect(60, 400, 550, 10);
    }
    if (audLoaded) {
      clearClipsButton.setVisible(true);
      fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Audio:", 10, 440);
      //Draw box where audio clips can be placed
      rect(60, 430, 550, 10);

      for (int i = 0; i < audioClips.size (); i++) {
        TimelineClip clip = audioClips.get(i);
        fill(0, 102, 153);
        //Draw spots where audio clips were placed
        println("clip start: "+clip.getStart());
        println("location: " +((clip.getStart()/(timeline.getMax()-1))*550));
        
        rect(60+((clip.getStart()/(timeline.getMax()-1))*550), 430, 5, 10);
      }
    }
    //Red progress line
    stroke(#FF0000);
    line(60+(time/maxTime)*550, playbackHeight+10, 60+(time/maxTime)*550, fullHeight-50);
  }

  void addClip(float x) {
    audioClips.addElement(new TimelineClip(floor(x)));
  }
  void clearClips() {
    audioClips.clear();
  }
  float getMax(){
    return cp5.getController("timeline").getMax();
  }
}

