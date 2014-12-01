class Timeline {
  Slider timelineSlider;

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
  }

  void update() {
    if (vidLoaded) {
      cp5.getController("timeline").setValue(floor((currentFrame/ maxFrames)*30));
    }
  }

  void draw() {
    //println(cp5.getController("timeline").getValue());
  }
}

