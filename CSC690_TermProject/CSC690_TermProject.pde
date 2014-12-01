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

int fullWidth = 740;
int fullHeight = 460;
int playbackWidth = 640;
int playbackHeight = 360;
int widthDiff = fullWidth-playbackWidth;
int heightDiff = fullHeight-playbackHeight;

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

//Disabled until bugs are fixed
/*void mouseDragged() {
  if (isJump) {
    float whereToJump = ((float)mouseX/(float)width)*maxFrames;
    float audioJump = ((float)mouseX/(float)width)*sound.length();
    setFrame(ceil(whereToJump));
    sound.cue(ceil(audioJump));
  }
}*/

