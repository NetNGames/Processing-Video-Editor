class SubtitleConfig {
  Group subPopup;
  Button popup, submitButton, cancelButton;
  Textfield startTimeInput, endTimeInput, subtitleInput;
  String startTime="", endTime="", subtitle="";
  SubtitleConfig() {
    popup = cp5.addButton("popup")
      .setPosition(620, 456)
        .setSize(70, 20)
          .setCaptionLabel("Add Subtitles");

    subPopup = cp5.addGroup("subPopup")
      .setPosition(width/2-100, 100)
        .setWidth(175)
          .activateEvent(true)
            .setBackgroundColor(color(50, 50))
              .setBackgroundHeight(125)
                .setLabel("Enter Subtitle Info:")
                  .disableCollapse()
                    .setVisible(false)
                      ;

    startTimeInput=cp5.addTextfield("startTime")
      .setPosition(60, 10)
        .setSize(100, 20)
          .setGroup(subPopup)
            .setCaptionLabel("Start Time:")
              ;
    cp5.getController("startTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("startTime", "Set Subtitle Start time in hh:mm:ss,ms format");

    endTimeInput=cp5.addTextfield("endTime")
      .setPosition(60, 35)
        .setSize(100, 20)
          .setCaptionLabel("End Time:")
            .setGroup(subPopup)
              ;
    cp5.getController("endTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("endTime", "Set Subtitle End Time in hh:mm:ss,ms format");

    subtitleInput=cp5.addTextfield("subtitle")
      .setPosition(60, 60)
        .setSize(100, 20)
          .setCaptionLabel("Subtitle:")
            .setGroup(subPopup)
              ;
    cp5.getController("subtitle").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("subtitle", "Set Subtitles to display. Add \"\\n\" for lines");

    submitButton = cp5.addButton("submitButton")
      .setPosition(10, 90)
        .setSize(50, 20)
          .setCaptionLabel("Submit")
            .setGroup(subPopup);
    cp5.getTooltip().register("submitButton", "Add Subtitle to current project");
    cancelButton = cp5.addButton("cancelButton")
      .setPosition(80, 90)
        .setSize(50, 20)
          .setCaptionLabel("Cancel")
            .setGroup(subPopup);
    cp5.getTooltip().register("cancelButton", "Exit editing subtitle");
  }
}

void addSubtitle(String sTime, String eTime, String text) {
  Caption newSub = new Caption();
  SubTime time = new SubTime(sTime);
  newSub.start=time;
  time = new SubTime(eTime);
  newSub.end=time;
  newSub.content=text;
  subs.captions.add(newSub);
  
  //Sort Subtitle Vector
  Collections.sort(subs.captions, Caption.COMPARE_BY_START);
}

