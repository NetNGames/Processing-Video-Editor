class VideoEffectsConfig {
  Group effectPopup;
  Button addEffectPopup, submitEffectButton, cancelEffectButton;
  Textfield startEffectTimeInput, endEffectTimeInput;
  Textlabel effectLabel;
  DropdownList vidEffectListPopup;
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
    
    vidEffectListPopup=cp5.addDropdownList("vidEffectListPopup")
      .setPosition(60, 78)
        .setBarHeight(15)
          .setCaptionLabel("No Effect Selected")
            .setGroup(effectPopup)
              ;
//    cp5.getController("vidEffectListPopup").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("vidEffectListPopup", "Set Effects to display.");
for (int i=0;i<effectsList.length;i++) {
    ListBoxItem lbi = vidEffectListPopup.addItem(effectsList[i], i);
    lbi.setColorBackground(genGronertColor(i));
  } 
  vidEffectListPopup.captionLabel().style().marginTop = 3;
  vidEffectListPopup.captionLabel().style().marginLeft = 3;   
    effectLabel=cp5.addTextlabel("effectLabel")
    .setPosition(6, 65)
          .setText("Effect:")
            .setGroup(effectPopup);
  }
}
void toggleInvert() {
  if (isInverted) {
    isInverted=false;
  } else if (!isInverted) {
    isInverted=true;
  }
}

void toggleGrey() {
  if (isGreyscale) {
    isGreyscale=false;
  } else if (!isGreyscale) {
    isGreyscale=true;
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

float timeToSec(String time){
  int h, m, s, ms;
    h = Integer.parseInt(time.substring(0, 2));
    m = Integer.parseInt(time.substring(3, 5));
    s = Integer.parseInt(time.substring(6, 8));
    ms = Integer.parseInt(time.substring(9, 12));
  float sec=(ms + s*1000 + m*60000 + h*3600000)/1000.0;
    return sec;
}
