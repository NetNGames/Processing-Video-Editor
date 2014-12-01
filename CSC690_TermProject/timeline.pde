class Timeline {
  Slider timelineSlider;
  Vector<TimelineClip> clips;

  Timeline() {
    timelineSlider = cp5.addSlider("timeline")
      .setPosition(60, 370)
        .setWidth(550)
          .setRange(0, 29)
            .setValue(0)
              .setNumberOfTickMarks(31)
                .setSliderMode(Slider.FLEXIBLE)
                  ;

    cp5.getController("timeline").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-30).setPaddingY(-9);
    cp5.getController("timeline").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-9);

    clips = new Vector<TimelineClip>(0, 1);
  }

  void update() {
    if (vidLoaded) {
      cp5.getController("timeline").setValue(floor((currentFrame/ maxFrames)*30));
      float time = floor(cp5.getController("timeline").getValue());
      println("current time: " + time);

      if (audLoaded) {
        for (int i = 0; i < clips.size (); i++) {
          TimelineClip clip = clips.get(i);
          println("   clip time: " + clip.getStart());
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
    fill(255);
    text("Clips", 10, 410);
    rect(60, 400, 550, 10);

    for (int i = 0; i < clips.size (); i++) {
      TimelineClip clip = clips.get(i);
      fill(0, 102, 153);
      rect(60+((clip.getStart()/29)*550), 400, 5, 10);
    }
  }

  void addClip(float x) {
    clips.addElement(new TimelineClip(floor(x)));
  }
}

