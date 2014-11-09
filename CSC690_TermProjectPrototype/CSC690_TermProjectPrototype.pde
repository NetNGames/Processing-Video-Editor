/************************************************* 
 
 File: CSC690_TermProjectPrototype
 By: Elbert Dang and Jacob Gronert
 Date: 10/25/2014
 
 Usage: Run using Processing 2.x with Minim, and ControlP5 libraries
 
 System: JVM 
 
 Description: Processing Video Editor Prototype
               -Includes some video effects (from Pixelate example)
               -Embedded subtitles
               -Video, audio, and srt files are hard-coded
               -Able to jump to frame with mouse click (from Frames example)
 
 *************************************************/

//For Video
import processing.video.*;
Movie mov;
int movFrameRate;
float currentFrame;
float maxFrames;
boolean isJump=false;

//For Audio
import ddf.minim.*;
Minim minim;
AudioPlayer sound;

//For Buttons
import controlP5.*;
ControlP5 cp5;

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

void setup() {
  size(640, 360);
  background(0);

  //Load video
  mov = new Movie(this, "AmericaNoAud.mp4");
  mov.loop();
  movFrameRate=(int)mov.frameRate;
  maxFrames = getLength() - 1;
  movColors = new color[width/blockSize][height/blockSize];

  //Load audio
  minim = new Minim(this);
  sound = minim.loadFile("aud.mp3");

  //Load buttons
  cp5 = new ControlP5(this);
  //Button to pixelate video
  pixelateButton = cp5.addButton("pixelateButton")
    .setPosition(10, 10)
      .setSize(70, 20)
        .setCaptionLabel("Pixelate");
        
  //Load subtitles
  loadSubs();
}

void movieEvent(Movie movie) {
  mov.read();
  mov.loadPixels();

  for (int i = 0; i < width/blockSize; i++) {
    for (int j = 0; j < height/blockSize; j++) {
      movColors[i][j] = mov.get(i*blockSize, j*blockSize);
    }
  }
}

void draw() {    
  if (isPixelate) {
    for (int i = 0; i < width/blockSize; i++) {
      for (int j = 0; j < height/blockSize; j++) {
        noStroke();
        fill(movColors[i][j]);
        rect(i*blockSize, j*blockSize, blockSize, blockSize);
      }
    }
  } else {
    image(mov, 0, 0);
  }
  
  currentFrame = getFrame();

  sound.play();
  displaySubs();
  
  //Bottom progress bar
  stroke(#FF0000);
  strokeWeight(10);

  //Progress bar
  rect(0, height-9 //Located on bottom of screen
  , (currentFrame/ maxFrames)*width //Scaled to window width
  , 1);
  
  
}  
int getFrame() {    
  return ceil(mov.time() * movFrameRate) - 1;
}
int getLength() {
  return int(mov.duration() * movFrameRate);
}  

//----------Video Playback----------\\

void setFrame(int n) {
  mov.play();

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
  if ((mouseY > (height-15)) && (mouseY < height)) {
    isJump=true;
    float whereToJump = ((float)mouseX/(float)width)*maxFrames;
    float audioJump = ((float)mouseX/(float)width)*sound.length();
    
    setFrame(ceil(whereToJump));
    sound.cue(ceil(audioJump));
    //mov.jump(ceil(whereToJump)); //not working, use setFrame
    mov.play();
  }
}

void mouseDragged() {
  if (isJump) {
    float whereToJump = ((float)mouseX/(float)width)*maxFrames;
    float audioJump = ((float)mouseX/(float)width)*sound.length();
    setFrame(ceil(whereToJump));
    sound.cue(ceil(audioJump));
    //mov.jump(ceil(whereToJump));
    mov.play();
  }
}
void mouseReleased() {
  isJump=false;
  mov.play();
}

//----------Video Effects----------\\
void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller().name()=="pixelateButton") {
    if (isPixelate) {
      isPixelate=false;
    } else {
      isPixelate=true;
    }
  }
}


//----------Subtitiles----------\\
//From http://www.activovision.com/pogg/doku.php?id=examples
void loadSubs(){
  //Loads the subtitles file
  raw = loadStrings("subs.srt");
  
  //here is going to be convert to an inner format
  subs = new String[raw.length][3];

  int count = 1;
  
  //println(raw.length + " lineas a agregar:");

  for(int i=0; i < raw.length;i++) {
    if( int(raw[i]) == count ) {
      String[] timeRAW = split(raw[i+1]," ");

      String[] startTimeRAW = split(timeRAW[0],":");
      String[] endTimeRAW = split(timeRAW[2],":");
      
      int[] splitStartTimeRAW = int(split(startTimeRAW[2],","));
      int[] splitEndTimeRAW = int(split(endTimeRAW[2],","));

      int start = int(startTimeRAW[0])*60*60+int(startTimeRAW[1])*60+splitStartTimeRAW[0];
      int end = int(endTimeRAW[0])*60*60+int(endTimeRAW[1])*60+splitEndTimeRAW[0];

      String subtitle = "";
      for(int l=0; !(raw[i+2+l].equals("")); l++) {
        subtitle = subtitle + raw[i+2+l];
      }

      subs[count-1][0]= Integer.toString(start);
      subs[count-1][1]= Integer.toString(end);
      subs[count-1][2]= subtitle;
      
      //println(count+" "+ start + " -->" + end + " dice " + subtitle);
      count++;
    }
  }
}

void displaySubs(){
  float sec = mov.time();
  String time = formatTime(sec);
  if ( int(sec) == 0){
    subN = 0; //Starting from beginning
  }
  while( int(sec) < int(subs[subN][0])){ //if jumping backwards
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
    
    if(int(sec) >= int(subs[subN][1])){
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
  if(minutes<10) {
    time = time+"0";
  }
  time = time+minutes+":";
  if(seconds<10) {
    time = time+"0";
  }
  time = time+seconds;
  return time;
}
