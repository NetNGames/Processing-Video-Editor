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

int fullWidth = 840;
int fullHeight = 490;
int playbackWidth = 640;
int playbackHeight = 360;
int widthDiff = fullWidth-playbackWidth;
int heightDiff = fullHeight-playbackHeight;
int iconWidth = 32;

import java.util.Vector;
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
Button nextButton;
Button prevButton;

//For Timeline
Timeline timeline;

//For Pixelate effect
Button pixelateButton;
boolean isPixelate = false;
int numPixelsWide, numPixelsHigh;
int blockSize = 10; //Should be a number that divides evenly into the height and width
color movColors[][];

//For subtitles
TimedTextObject subs;
//Vector subs;
//String[] raw;
//String[][] subs;
//int subN = 0;
//int subCount;

//For File Chooser
import javax.swing.*;
Button chooseFileButton;
boolean vidLoaded=false;
boolean audLoaded=false;
boolean srtLoaded=false;

//Everything else
PFont font; 

void setup() {
//  frame.setResizable(true);
  size(fullWidth, fullHeight);
  background(0);
  font = createFont("Arial", 16, true); 

  //Load buttons
  cp5 = new ControlP5(this);
  //Button to choose files
  chooseFileButton = cp5.addButton("chooseFile")
    .setPosition(width-130, 10)
      .setSize(70, 20)
        .setCaptionLabel("Load File")
          .setVisible(true);
  cp5.getTooltip().register("chooseFile","Load Video or Audio clips, SRT, or PVE files");
  
  //Button to pixelate video
  pixelateButton = cp5.addButton("pixelateButton")
    .setPosition(10, 10)
      .setSize(70, 20)
        .setCaptionLabel("Pixelate")
          .setVisible(false);
  cp5.getTooltip().register("pixelateButton","Pixelate Video");

  //Playback
  playButton = cp5.addButton("playButton")
    .setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40)
      .setImages(loadImage("PlayNormal.png"), loadImage("PlayHot.png"), loadImage("PlayPressed.png"))
        .updateSize();
  cp5.getTooltip().register("playButton","Play Video or Audio file");

  pauseButton = cp5.addButton("pauseButton")
    .setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40)
      .setImages(loadImage("PauseNormal.png"), loadImage("PauseHot.png"), loadImage("PausePressed.png"))
        .updateSize()
          .setVisible(false);
  cp5.getTooltip().register("pauseButton","Pause Video or Audio file");

  stopButton = cp5.addButton("stopButton")
    .setPosition(playbackWidth/2+(iconWidth*3)/4, height-40)
      .setImages(loadImage("StopNormal.png"), loadImage("StopHot.png"), loadImage("StopPressed.png"))
        .updateSize(); 
  cp5.getTooltip().register("stopButton","Stops and resets Video or Audio file");

  prevButton = cp5.addButton("prevButton")
    .setPosition(playbackWidth/2-iconWidth*2, height-40)
      .setImages(loadImage("BackwardNormal.png"), loadImage("BackwardHot.png"), loadImage("BackwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("prevButton","Go to previous Video or Audio file");

  nextButton = cp5.addButton("nextButton")
    .setPosition(playbackWidth/2+iconWidth*2, height-40)
      .setImages(loadImage("ForwardNormal.png"), loadImage("ForwardHot.png"), loadImage("ForwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("nextButton","Go to next Video or Audio file");
  
  timeline = new Timeline();
  movies = new Vector<Movie>(0, 1);
  movieNames = new Vector<String>(0, 1);
  sounds = new Vector<AudioPlayer>(0, 1);
  soundNames = new Vector<String>(0, 1);
}

void movieEvent(Movie movie) {
  mov.read();
//  println(mov.time());
//  println(timeline.time);
}
