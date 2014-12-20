class SubtitleConfig {
  Group subPopup;
  Button addSubtitlePopup, submitSubButton, cancelSubButton;
  Textfield startSubTimeInput, endSubTimeInput, subtitleInput;
  String startSubTime="", endSubTime="", subtitle="";
  SubtitleConfig() {
    addSubtitlePopup = cp5.addButton("addSubtitlePopup")
      .setPosition(620, 456)
        .setSize(70, 20)
          .setCaptionLabel("Add Subtitles");
    cp5.getTooltip().register("addSubtitlePopup", "Click to add subtitle at current time");

    subPopup = cp5.addGroup("subPopup")
      .setPosition(width/2-100, 100)
        .setWidth(175)
          .activateEvent(true)
            .setBackgroundColor(color(100))
              .setBackgroundHeight(125)
                .setLabel("Enter Subtitle Info:")
                  .disableCollapse()
                    .setVisible(false)
                      ;

    startSubTimeInput=cp5.addTextfield("startSubTime")
      .setPosition(60, 10)
        .setSize(100, 20)
          .setGroup(subPopup)
            .setCaptionLabel("Start Time:")
              ;
    cp5.getController("startSubTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("startSubTime", "Set Subtitle Start time in hh:mm:ss,ms format");

    endSubTimeInput=cp5.addTextfield("endSubTime")
      .setPosition(60, 35)
        .setSize(100, 20)
          .setCaptionLabel("End Time:")
            .setGroup(subPopup)
              ;
    cp5.getController("endSubTime").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("endSubTime", "Set Subtitle End Time in hh:mm:ss,ms format");

    subtitleInput=cp5.addTextfield("subtitle")
      .setPosition(60, 60)
        .setSize(100, 20)
          .setCaptionLabel("Subtitle:")
            .setGroup(subPopup)
              ;
    cp5.getController("subtitle").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-50).setPaddingY(-15);
    cp5.getTooltip().register("subtitle", "Set Subtitles to display.");

    submitSubButton = cp5.addButton("submitSubButton")
      .setPosition(10, 90)
        .setSize(50, 20)
          .setCaptionLabel("Submit")
            .setGroup(subPopup);
    cp5.getTooltip().register("submitSubButton", "Add Subtitle to current project");
    cancelSubButton = cp5.addButton("cancelSubButton")
      .setPosition(80, 90)
        .setSize(50, 20)
          .setCaptionLabel("Cancel")
            .setGroup(subPopup);
    cp5.getTooltip().register("cancelSubButton", "Exit editing subtitle");
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

void saveSubFile() {
  //Using http://docs.oracle.com/javase/tutorial/uiswing/components/filechooser.html
  JFileChooser fc = new JFileChooser();
  PrintWriter output;

  int returnVal = fc.showSaveDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    String subOut="";
    String outputName=file.getAbsolutePath();
    if(!file.getName().endsWith(".srt")){//So there are no double ".srt" at end of file
      outputName+=".srt";
    }
    output = createWriter(outputName);
    println("Saving subtitles to "+outputName);
    Caption subtemp;
    subItr=subs.captions.listIterator();
    while (subItr.hasNext ()) {
      subtemp = subItr.next();
      subOut+=subItr.nextIndex()+"\r\n" //Better support for more text editors that just \n
        +subtemp.start.getTime()+" --> "
        +subtemp.end.getTime()+"\r\n"
        +subtemp.content+"\r\n\r\n";
    }
    output.print(subOut);

    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println("Save Complete!");
    subNames.clear(); //Overrides all subfile names with new one
    subNames.addElement(outputName);
  } else {
    println("Save Cancelled");
  }
}

