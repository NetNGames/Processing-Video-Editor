class Timeline {
  float videoJump, audioJump, time, maxTime;
  Button clearClipsButton;
  Slider timelineSlider;
  Vector<TimelineClip> clips;

  Timeline() {
    timelineSlider = cp5.addSlider("timeline")
      .setPosition(60, playbackHeight+10)
        .setWidth(550)
          //.setRange(0, 29)
            .setValue(0)
              //.setNumberOfTickMarks(31)
              .setTriggerEvent(Slider.RELEASE)
                .setSliderMode(Slider.FLEXIBLE);
    clearClipsButton = cp5.addButton("clearClipsButton")
    .setPosition(620, height-60)
      .setSize(70, 20)
        .setCaptionLabel("Clear");
//    cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);

    clips = new Vector<TimelineClip>(0, 1);
  }

  void update() {
    if (vidLoaded) {
      timelineSlider.setRange(0,abs(maxFrames));
      if(!isJump){
      cp5.getController("timeline").setValue(abs(floor((currentFrame/ maxFrames)*maxFrames)));
      }
//      cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
      cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
      time = floor(cp5.getController("timeline").getValue());
      maxTime = floor(cp5.getController("timeline").getMax());
      
//            println("current time: " + time);
      
      if (audLoaded) {
        for (int i = 0; i < clips.size (); i++) {
          TimelineClip clip = clips.get(i);
          //          println("   clip time: " + clip.getStart());
          if (time == clip.getStart()) {
            if (!sounds.get(0).isPlaying()) {
              sounds.get(0).rewind();
              sounds.get(0).play();
            }
          }
          
        }
        //        float whereToJump = ((float)mouseX/(float)width)*maxFrames;
        //     float audioJump = ((float)mouseX/(float)width)*sound.length();
        //     setFrame(ceil(whereToJump));
        //     sound.cue(ceil(audioJump));
      }
    }
  }

  void draw() {
    fill(255);
    textAlign(LEFT);
    text("Audio:", 10, 410);
    //Draw box where audio clips can be placed
    rect(60, 400, 550, 10);

    for (int i = 0; i < clips.size (); i++) {
      TimelineClip clip = clips.get(i);
      fill(0, 102, 153);
      //Draw spots where audio clips were placed
      rect(60+((clip.getStart()/(cp5.getController("timeline").getMax()-1))*550), 400, 5, 10);
    }
    //Progress line
    stroke(#FF0000);
    line(60+(time/maxTime)*550, playbackHeight+10, 60+(time/maxTime)*550, fullHeight-40);
  }

  void addClip(float x) {
    clips.addElement(new TimelineClip(floor(x)));
  }
  void clearClips(){
    clips.clear();
  }
}
//void controlEvent(ControlEvent theEvent) {
//  if (theEvent.controller().name()=="timeline") {
//    setFrame(ceil(time));
//    sound.cue(ceil(time));
//  }
//}
