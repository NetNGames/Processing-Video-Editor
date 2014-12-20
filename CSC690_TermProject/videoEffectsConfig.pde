class VideoEffectsConfig {
  Group effectPopup;
  Button addEffectPopup, submitEffectButton, cancelEffectButton;
  Textfield startEffectTimeInput, endEffectTimeInput;
  ListBox vidEffectListPopup;
  String startEffectTime="", endEffectTime="", Effect="";
  VideoEffectsConfig() {
    addEffectPopup = cp5.addButton("addEffectPopup")
      .setPosition(620, 396)
        .setSize(70, 20)
          .setCaptionLabel("Add Effects")
            .setVisible(false);
    cp5.getTooltip().register("addEffectPopup", "Click to add Effect at current time");

    effectPopup = cp5.addGroup("effectPopup")
      .setPosition(width/2-100, 100)
        .setWidth(175)
          .activateEvent(true)
            .setBackgroundColor(color(100))
              .setBackgroundHeight(125)
                .setLabel("Enter Effect Info:")
                  .disableCollapse()
                    .setVisible(false)
                      ;

    startEffectTimeInput=cp5.addTextfield("startEffectTime")
      .setPosition(60, 10)
        .setSize(100, 20)
          .setGroup(effectPopup)
            .setCaptionLabel("Start Time:")
              ;
    cp5.getController("startEffectTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("startEffectTime", "Set Effect Start time in hh:mm:ss,ms format");

    endEffectTimeInput=cp5.addTextfield("endEffectTime")
      .setPosition(60, 35)
        .setSize(100, 20)
          .setCaptionLabel("End Time:")
            .setGroup(effectPopup)
              ;
    cp5.getController("endEffectTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("endEffectTime", "Set Effect End Time in hh:mm:ss,ms format");

//    EffectInput=cp5.addTextfield("Effect")
//      .setPosition(60, 60)
//        .setSize(100, 20)
//          .setCaptionLabel("Effect:")
//            .setGroup(effectPopup)
//              ;
vidEffectListPopup=vidEffectList;
//    cp5.getController("Effect").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
//    cp5.getTooltip().register("Effect", "Set Effects to display. Add \"\\n\" for lines");

    submitEffectButton = cp5.addButton("submitEffectButton")
      .setPosition(10, 90)
        .setSize(50, 20)
          .setCaptionLabel("Submit")
            .setGroup(effectPopup);
    cp5.getTooltip().register("submitEffectButton", "Add Effect to current project");
    cancelEffectButton = cp5.addButton("cancelEffectButton")
      .setPosition(80, 90)
        .setSize(50, 20)
          .setCaptionLabel("Cancel")
            .setGroup(effectPopup);
    cp5.getTooltip().register("cancelEffectButton", "Exit editing Effect");
  }
}

void toggleGrey() {
  if (isGreyscale) {
    isGreyscale=false;
  } else if (!isGreyscale) {
    isGreyscale=true;
  }
}

void toggleInvert() {
  if (isInverted) {
    isInverted=false;
  } else if (!isInverted) {
    isInverted=true;
  }
}
void togglePosterize() {
  if (isPosterize) {
    isPosterize=false;
  } else if (!isPosterize) {
    isPosterize=true;
  }
}

void togglePixelate() {
  if (isPixelate) {
    isPixelate=false;
  } else if (!isPixelate) {
    isPixelate=true;
  }
}

void effectsOff() {
  isInverted = false;
  isGreyscale = false;
  isPosterize = false;
  isPixelate = false;
}
