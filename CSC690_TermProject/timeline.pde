int timelineWidth;
class Timeline {
  float time, maxTime;
  Button clearClipsButton;
  Slider timelineSlider;
  Vector<TimelineClip> audioClips;
  Vector<TimelineClip> videoClips;

  Timeline() {
    timelineSlider = cp5.addSlider("timeline")
      //      .setPosition(60, playbackHeight+10)
      //        .setWidth(timelineWidth)
      .setMin(0.0)
        .setValue(0.0)
          .setTriggerEvent(Slider.RELEASE) //Buggy if kept it on default PRESSED
            .setSliderMode(Slider.FLEXIBLE);
    clearClipsButton = cp5.addButton("clearClipsButton")
      //      .setPosition(620, 426)
      .setSize(70, 20)
        .setCaptionLabel("Clear")
          .setVisible(false);
    cp5.getTooltip().register("clearClipsButton", "Clear Audio clips currently on timeline");
    //    cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);


    audioClips = new Vector<TimelineClip>(0, 1);
  }

  void update() {
    timelineSlider.setWidth(timelineWidth)
      .setPosition(60, height-150);
    clearClipsButton.setPosition(width-220, height-104);
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
    if (vidLoaded) {
      //      timelineSlider.setVisible(true);
      cp5.getTooltip().register("timeline", "Click to jump to time");

      //      timelineSlider.setMax(abs((float)maxFrames));
      cp5.getController("timeline").setMax(maxDuration);
      if (!isJump) {
        //        cp5.getController("timeline").setValue(abs(((float)currentFrame/ (float)maxFrames)*(float)maxFrames));
        //        println("set value: "+(mov.time()/maxDuration)*550);
        if (currentSelected==0 && movies.size()==1) {
          cp5.getController("timeline").setValue((mov.time()/mov.duration())*maxDuration);
        }else if (currentSelected==0 && movies.size()==2) {
          cp5.getController("timeline").setValue((mov.time()/mov.duration())*maxDuration/10);
        }else if (currentSelected==1&& movies.size()==2) {
          cp5.getController("timeline").setValue(mov.time()/mov.duration()*maxDuration+movies.get(0).duration());
        }
      }
      //      cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
      cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
      //      time = floor(cp5.getController("timeline").getValue());
      time = cp5.getController("timeline").getValue();
      //      maxTime = floor(cp5.getController("timeline").getMax());
      maxTime = cp5.getController("timeline").getMax();
      //      println("time: "+time);
      //      println("maxTime: "+maxTime);
      //            println("current time: " + time);

      if (audLoaded) {
        for (int i = 0; i < audioClips.size (); i++) {
          TimelineClip clip = audioClips.get(i);
          if (time == clip.getStart()) {
            //println("sound should play now");
            if (sounds.get(clip.getIndex()).isPlaying()) {
              sounds.get(clip.getIndex()).play();
            } else {
              sounds.get(clip.getIndex()).rewind();
              sounds.get(clip.getIndex()).play();
            }
          }
        }
      }
    }
  }

  void draw() {
    if (vidLoaded) {
      fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Video:", 10, height-110);
      //Draw box where video clips can be placed
      rect(60, height-120, timelineWidth, 10);
    }
    if (audLoaded) {
      clearClipsButton.setVisible(true);
      fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Audio:", 10, height-80);
      //Draw box where audio clips can be placed
      rect(60, height-90, timelineWidth, 10);

      for (int i = 0; i < audioClips.size (); i++) {
        TimelineClip clip = audioClips.get(i);
        fill(clip.getColor());
        //Draw spots where audio clips were placed
        //println("clip start: "+clip.getStart());
        //println("location: " +((clip.getStart()/(timeline.getMax()-1))*550));

        rect(60+((clip.getStart()/(timeline.getMax()-1))*timelineWidth), height-90, 5, 10);
      }
    }
    //Red progress line
    stroke(#FF0000);
    line(60+(time/maxTime)*timelineWidth, height-150, 60+(time/maxTime)*timelineWidth, height-50);
  }

  void addClip(float x) {
    color c = color(((50*soundPicked)+100)%250, (10*soundPicked)%250, (200*soundPicked)%250);
    audioClips.addElement(new TimelineClip(floor(x), soundPicked, c));
  }
  void clearClips() {
    audioClips.clear();
  }
  float getMax() {
    return cp5.getController("timeline").getMax();
  }
}

