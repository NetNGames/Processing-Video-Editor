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

import java.util.*;
//For Video
import processing.video.*;
Movie mov;
Vector<Movie> movies;
Vector<String> movieNames;
int movFrameRate;
float currentFrame;
float maxFrames;
boolean isJump=false;
boolean showTimeline=false;

//For Audio
import ddf.minim.*;
Minim minim;
AudioPlayer sound;
Vector<AudioPlayer> sounds;
Vector<String> soundNames;

//For Buttons
import controlP5.*;
ControlP5 cp5;
Button playButton;
Button pauseButton;
Button stopButton;

//For Timeline
Timeline timeline;

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

//Everything else
PFont font; 

void setup() {
  size(840, 460);
  background(0);
  font = createFont("Arial",16,true); 

  //Load buttons
  cp5 = new ControlP5(this);
  //Button to choose files
  chooseFileButton = cp5.addButton("chooseFile")
    .setPosition(width-130, 10)
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
        
  timeline = new Timeline();
  movies = new Vector<Movie>(0, 1);
  movieNames = new Vector<String>(0, 1);
  sounds = new Vector<AudioPlayer>(0, 1);
  soundNames = new Vector<String>(0, 1);
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
