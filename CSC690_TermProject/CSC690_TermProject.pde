/************************************************* 
 
 File: CSC690_TermProject
 By: Elbert Dang and Jacob Gronert
 Date: 10/25/2014
 
 Usage: Run using Processing 2.x with Minim, and ControlP5 libraries
 
 System: JVM 
 
 Description: Processing Video Editor
 -Includes some video effects (Pixelate from Pixelate example)
 -Embedded subtitles
 -Choose File from File Browser
 -Able to jump to frame with mouse click (from Frames example)               
 
 *************************************************/

//For Video
import processing.video.*;
Movie mov;
int movFrameRate;
float currentFrame;
float maxFrames;
boolean isJump=false;
boolean showTimeline=false;

//For Audio
import ddf.minim.*;
Minim minim;
AudioPlayer sound;

//For Buttons
import controlP5.*;
ControlP5 cp5;
Button playButton;
Button pauseButton;
Button stopButton;

//For Pixelate effect
Button pixelateButton;
boolean isPixelate = false;
int numPixelsWide, numPixelsHigh;
int blockSize = 10; //Should be a number that divides evenly into the height and width
color movColors[][];

//For subtitles
String[] raw;
String[][] subs;
int subN = 0;
int subCount;

//For File Chooser
import javax.swing.*;
Button chooseFileButton;
boolean vidLoaded=false;
boolean audLoaded=false;
boolean srtLoaded=false;

void setup() {
  size(740, 460);
  background(0);

  //Load buttons
  cp5 = new ControlP5(this);
  //Button to choose files
  chooseFileButton = cp5.addButton("chooseFile")
    .setPosition(width-90, 10)
      .setSize(70, 20)
        .setCaptionLabel("Load File")
          .setVisible(true);

  //Button to pixelate video
  pixelateButton = cp5.addButton("pixelateButton")
    .setPosition(10, 10)
      .setSize(70, 20)
        .setCaptionLabel("Pixelate")
          .setVisible(false);

  playButton = cp5.addButton("playButton")
    .setPosition(10, height-30)
      .setSize(70, 20)
        .setCaptionLabel("Play");

  pauseButton = cp5.addButton("pauseButton")
    .setPosition(90, height-30)
      .setSize(70, 20)
        .setCaptionLabel("Pause");

  stopButton = cp5.addButton("stopButton")
    .setPosition(170, height-30)
      .setSize(70, 20)
        .setCaptionLabel("Stop");
}

void movieEvent(Movie movie) {
  mov.read();
}

void draw() {
  stroke(#FFFFFF);
  rect(0, 0, 640, 360);

  if (vidLoaded) {
    //determine aspect ratio and scale accordingly:


    image(mov, 0, 0, 640, 360);
    currentFrame = getFrame();
    //pixelated?
    if (isPixelate) {
      mov.loadPixels();

      for (int i = 0; i < width/blockSize; i++) {
        for (int j = 0; j < height/blockSize; j++) {
          movColors[i][j] = mov.get(i*blockSize, j*blockSize);
        }
      }
      for (int i = 0; i < width/blockSize; i++) {
        for (int j = 0; j < height/blockSize; j++) {
          noStroke();
          fill(movColors[i][j]);
          rect(i*blockSize, j*blockSize, blockSize, blockSize);
        }
      }
    }
    //Bottom progress bar
    stroke(#FF0000);
    strokeWeight(10);
    //if (showTimeline) {
    rect(0, height-109, //Located on bottom of screen
    (currentFrame/ maxFrames)*(width-100), //Scaled to window width
    1);
    //}
  }

  if (audLoaded) {
    sound.play();

    if (mov.time()==0.0) { //If movie reset
      sound.rewind();    //Rewind audio file
    }
  }
  if (srtLoaded) {
    displaySubs();
  }
}  

//----------File Loading----------\\
void loadFile() {
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  final JFileChooser fc = new JFileChooser();
  int returnVal = fc.showOpenDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();


    if (file.getName().endsWith("mp4") ||
      file.getName().endsWith("mov") ||
      file.getName().endsWith("avi") ||
      file.getName().endsWith("ogg") ) {
      //Load video
      vidLoaded=true;
      mov = new Movie(this, file.getPath());
      mov.loop();
      movFrameRate=(int)mov.frameRate;
      maxFrames = getLength() - 1;
      movColors = new color[width/blockSize][height/blockSize];
    } else if (file.getName().endsWith("mp3") ||
      file.getName().endsWith("wav") ||
      file.getName().endsWith("flac") ||
      file.getName().endsWith("wma") ) {
      //Load audio
      audLoaded=true;
      minim = new Minim(this);
      sound = minim.loadFile(file.getPath());
    } else if (file.getName().endsWith("srt")) {
      //Load subtitles
      srtLoaded=true;
      loadSubs(file);
    }
  }
}


//----------Video Playback----------\\
//From Frames video example
int getFrame() {    
  return ceil(mov.time() * movFrameRate) - 1;
}
int getLength() {
  return int(mov.duration() * movFrameRate);
}  
void setFrame(int n) {
  //mov.play();

  // The duration of a single frame:
  float frameDuration = 1.0 / movFrameRate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = mov.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  mov.jump(where);
} 

void mousePressed() {
  if ((mouseY > (height-115)) && (mouseY < height-109) && mouseX < 360) {
    isJump=true;
    if (vidLoaded) { 
      float whereToJump = ((float)mouseX/(float)(width-100))*maxFrames;
      setFrame(ceil(whereToJump));
    }
    if (audLoaded) { 
      float audioJump = ((float)mouseX/(float)(width-100))*sound.length();
      sound.cue(ceil(audioJump));
    }
  }
}

//Disabled until bugs are fixed
/*void mouseDragged() {
  if (isJump) {
    float whereToJump = ((float)mouseX/(float)width)*maxFrames;
    float audioJump = ((float)mouseX/(float)width)*sound.length();
    setFrame(ceil(whereToJump));
    sound.cue(ceil(audioJump));
  }
}*/

void mouseReleased() {
  isJump=false;
}

//----------Video Effects----------\\
void mouseMoved() {
  if ((mouseX > (0)) && (mouseX < 80) &&
    (mouseY > (0)) && (mouseY < 30)) {
    pixelateButton.setVisible(true);
    pixelateButton.unlock();
  } else {
    pixelateButton.setVisible(false);
    pixelateButton.lock();
  }
  if ((mouseY > (height-30)) && (mouseY < height)) {
    showTimeline = true;
  } else {
    showTimeline = false;
  }
}
void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller().name()=="pixelateButton") {
    if (!pixelateButton.isLock()) {//Will not activate if mouse is not over button
      if (isPixelate) {
        isPixelate=false;
      } else if (!isPixelate) {
        isPixelate=true;
      }
    }
  } else if (theEvent.controller().name()=="chooseFile") {
    loadFile();
  } else if (theEvent.controller().name()=="pauseButton") {
    if (vidLoaded) { 
      mov.pause();
    }
    if (audLoaded) { 
      sound.pause();
    }
  } else if (theEvent.controller().name()=="playButton") {
    if (vidLoaded) { 
      mov.play();
    }
    if (audLoaded) { 
      sound.play();
    }
  } else if (theEvent.controller().name()=="stopButton") {
    if (vidLoaded) {
      mov.jump(0); 
      mov.pause();
    }
    if (audLoaded) {  
      sound.rewind();
      sound.pause();
    }
  }
}
void keyPressed() {
  if ((key == 'p') || (key == 'P')) {
    if (isPixelate) {
      isPixelate=false;
    } else if (!isPixelate) {
      isPixelate=true;
    }
  }
}

//----------Subtitles----------\\
//From http://www.activovision.com/pogg/doku.php?id=examples
void loadSubs(File file) {
  //Loads the subtitles file
  raw = loadStrings(file.getPath());

  //here is going to be convert to an inner format
  subs = new String[raw.length][3];

  subCount = 1;

  //println(raw.length + " lineas a agregar:");

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
      for (int l=0; ! (raw[i+2+l].equals ("")); l++) {
        subtitle = subtitle + raw[i+2+l];
      }

      subs[subCount-1][0]= Integer.toString(start);
      subs[subCount-1][1]= Integer.toString(end);
      subs[subCount-1][2]= subtitle;

      //println(subCount+" "+ start + " -->" + end + " dice " + subtitle);
      subCount++;
    }
  }
}

void displaySubs() {
  float sec = mov.time();
  String time = formatTime(sec);
  if (int(sec) == 0 ) {
    subN = 0; //Starting from beginning
  }
  while ( int (sec) < int(subs[subN][0])) { //if jumping backwards
    subN--;
  }
  if ( int(sec) >= int(subs[subN][0])) {
    textSize(15);
    textAlign(CENTER);

    //Black Outline
    fill(#000000);
    text(subs[subN][2], width/2+1, height - 21);
    text(subs[subN][2], width/2-1, height - 19);

    //White text
    fill(#FFFFFF);
    text(subs[subN][2], width/2, height - 20);

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
  if (minutes<10) {
    time = time+"0";
  }
  time = time+minutes+":";
  if (seconds<10) {
    time = time+"0";
  }
  time = time+seconds;
  return time;
}

