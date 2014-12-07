//----------Subtitles----------\\
//From http://www.activovision.com/pogg/doku.php?id=examples
void loadSubs(File file) {
  //Loads the subtitles file
  raw = loadStrings(file.getPath());

  //here is going to be convert to an inner format
  subs = new String[raw.length][3];

  subCount = 1;

//  println(raw.length + " lines to parse:");

  for (int i=0; i < raw.length; i++) {
    if ( int(raw[i]) == subCount ) {
      String[] timeRAW = split(raw[i+1], " ");

      String[] startTimeRAW = split(timeRAW[0], ":");
      String[] endTimeRAW = split(timeRAW[2], ":");

      int[] splitStartTimeRAW = int(split(startTimeRAW[2], ","));
      int[] splitEndTimeRAW = int(split(endTimeRAW[2], ","));

      int start = int(startTimeRAW[0])*60*60+int(startTimeRAW[1])*60+splitStartTimeRAW[0];
      int end = int(endTimeRAW[0])*60*60+int(endTimeRAW[1])*60+splitEndTimeRAW[0];

      String subtitle = "";
      for (int j=0; !(raw[i+2+j].equals ("")); j++) {
        subtitle = subtitle + raw[i+2+j];
      }

      subs[subCount-1][0]= Integer.toString(start);
      subs[subCount-1][1]= Integer.toString(end);
      subs[subCount-1][2]= subtitle;

//      println(subCount+" "+ start + " -->" + end + " dice " + subtitle);
      subCount++;
    }
  }
}

void displaySubs() {
  float sec = mov.time();
//  String time = formatTime(sec);
  if (int(sec) == 0 ) {
    subN = 0; //Starting from beginning
  }
  if (subN>0) {
    while ( int (sec) < int(subs[subN][0])) { //if jumping backwards
      subN--;
    }
  }
  if ( int(sec) >= int(subs[subN][0])) {
    textSize(15);
    textAlign(CENTER);

    //Black Outline
    fill(#000000);
    text(subs[subN][2], playbackWidth/2+1, playbackHeight - 11);
    text(subs[subN][2], playbackWidth/2-1, playbackHeight - 9);

    //White text
    fill(#FFFFFF);
    text(subs[subN][2], playbackWidth/2, playbackHeight - 10);

    if (int(sec) >= int(subs[subN][1]) && //If time period is reached
    (subN<subCount-2)) {            //And not at end of subtitles
      subN++;
    }
  }
}

String formatTime(float sec) {
  int seconds = (int)sec;
  float fraction = sec-seconds;
  int mill = (int)(fraction *1000);
  int minutes = seconds/60;
  seconds = seconds%60;
  int hours = minutes/60;
  minutes = minutes%60;

  String time = "";
  if (hours<10) {
    time = time+"0";
  }
  time = time+hours+":";
  if (minutes<10) {
    time = time+"0";
  }
  time = time+minutes+":";
  if (seconds<10) {
    time = time+"0";
  }
  time = time+seconds+",";
  if (mill<100) {
    time = time+"0";
    if (mill<10) {
      time = time+"0";
    }
  }
  time = time+mill;
  return time;
}

void drawSubTimeline(){
  fill(255);
  text("Subtitles:", 5, 440);
  rect(60, 430, 550, 10);
}
