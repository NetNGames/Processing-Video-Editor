int timelineWidth;
float leftOffset;
boolean printTime=false;
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
            .setSliderMode(Slider.FLEXIBLE)
            .setCaptionLabel("Main Timeline");
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
    cp5.getTooltip().register("timeline", "Click to jump to time");

    clearClipsButton = cp5.addButton("clearClipsButton")
      //      .setPosition(620, 426)
      .setSize(70, 20)
        .setCaptionLabel("Clear")
          .setVisible(false);
    cp5.getTooltip().register("clearClipsButton", "Clear Audio clips currently on timeline");
    //    cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
    

    audioClips = new Vector<TimelineClip>(0, 1);
    videoClips = new Vector<TimelineClip>(0, 1);
  }

  void update() {
    timelineSlider.setWidth(timelineWidth);
    //Timeline display

    clearClipsButton.setPosition(width-220, height-95);
//    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);
    if (vidLoaded) {
      //      timelineSlider.setVisible(true);


      //      timelineSlider.setMax(abs((float)maxFrames));
      cp5.getController("timeline").setMax(maxDuration);
      //      if (!isJump) {
      //        cp5.getController("timeline").setValue(abs(((float)currentFrame/ (float)maxFrames)*(float)maxFrames));
      //        println("set value: "+(mov.time()/maxDuration)*550);

      leftOffset=0;
      for (int i=0; i<currentSelected; i++) {
        leftOffset+=movies.get(i).duration();
      }

      //        if (currentSelected==0 && movies.size()==1) {
      //  println("currentSelected: "+currentSelected);
      //  println("leftOffset: "+leftOffset);
      cp5.getController("timeline").setValue(((leftOffset+mov.time())/maxDuration)*maxDuration);
      //          println( formatTime(cp5.getController("timeline").getValue()));

      //      cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
      
//            time = floor(cp5.getController("timeline").getValue());
//time = cp5.getController("timeline").getValue();
      //            println("time: "+time);
      //            println("maxTime: "+maxTime);
      //                  println("current time: " + time);

      if (audLoaded) {

        for (int i = 0; i < audioClips.size (); i++) {
          TimelineClip clip = audioClips.get(i);
          if (time>=clip.getStart() && time<=clip.getStart()+0.02){ //Gives some leeway
            println("sound should play now");
            if (sounds.get(clip.getIndex()).isPlaying()) {
              println("Continue playing");
              sounds.get(clip.getIndex()).play();
            } else {
              println("Start playing");
              sounds.get(clip.getIndex()).rewind();
              sounds.get(clip.getIndex()).play();
            }
          }
        }
      }
    } else if (!vidLoaded && audLoaded) {
      cp5.getController("timeline").setMax(sound.length()/1000.0);
      cp5.getController("timeline").setValue(sound.position()/1000.0);
    }
    time = cp5.getController("timeline").getValue();
    if(printTime){
    println("time="+time);
    println("floor time="+floor(time));
    println("round time by 2="+round(time,2));
    }
    maxTime = cp5.getController("timeline").getMax();
  }

  void draw() {
    if (vidLoaded) {
      fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Video:", 10, height-110);
      //Draw box where video clips can be placed
      rect(60, height-120, timelineWidth, 10);

      for (int i = 0; i < videoClips.size (); i++) {
        TimelineClip clip = videoClips.get(i);
        fill(clip.getColor());
        
        rect(60+((clip.getStart()/(timeline.getMax()-1))*timelineWidth), height-120, 5, 10);
      }
      //          fill(255);
      float current = mov.time()+leftOffset;
      //    float max = mov.duration();

      String time = formatTime(current)+" / "+formatTime(maxDuration);
      textSize(12);
      fill(255);
      text(time, width-220, height-140);
    }
    if (audLoaded) {
      if(!fullscreenMode){
        clearClipsButton.setVisible(true);
      }else if(fullscreenMode){
        clearClipsButton.setVisible(false);
      }
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
        AudioPlayer temp=sounds.get(clip.getIndex());
        rect(60+((clip.getStart()/(timeline.getMax()-1))*timelineWidth), height-90, (((temp.length()/1000.0)/(timeline.getMax()-1))*timelineWidth), 10);
      }
      if (!vidLoaded) {
        float current = sound.position()/1000.0;
        String time = formatTime(current)+" / "+formatTime(timeline.getMax());
        textSize(12);
        fill(255);
        text(time, width-220, height-140);
      }
    }
    //Red progress line
    stroke(#FF0000);
    line(60+(time/maxTime)*timelineWidth, height-150, 60+(time/maxTime)*timelineWidth, height-50);

  }

  void addAudioClip(float x) {
    color c = color(((50*soundPicked)+100)%250, (10*soundPicked)%250, (200*soundPicked)%250);
//    audioClips.addElement(new TimelineClip(floor(x), soundPicked, c));
    audioClips.addElement(new TimelineClip(x, soundPicked, c));
  }
  void addVideoClip(float x) {
    color c = color(((50*soundPicked)+100)%250, (10*soundPicked)%250, (200*soundPicked)%250);
    videoClips.addElement(new TimelineClip(floor(x), soundPicked, c));
  }
  void clearClips() {
    audioClips.clear();
    videoClips.clear();
  }
  float getMax() {
    return cp5.getController("timeline").getMax();
  }
}

