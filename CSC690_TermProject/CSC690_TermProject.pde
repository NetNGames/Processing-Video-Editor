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
int fullHeight = 520;
int playbackWidth = 640;
int playbackHeight = 360;
int iconWidth = 32;
float thumbHeight;
float thumbWidth;
import java.util.Vector;

//For Video
import processing.video.*;
Movie mov;
Vector<Movie> movies;
Vector<String> movieNames;
ListIterator<Movie> movItr;
int currentSelected=0;
int movFrameRate;
float currentFrame;
float maxFrames;
float maxDuration;
boolean isJump=false;
boolean showTimeline=false;
boolean fullscreenMode=false;

//For Audio
import ddf.minim.*;
Minim minim;
AudioPlayer sound;
Vector<AudioPlayer> sounds;
Vector<String> soundNames;
ListIterator<AudioPlayer> soundItr;
int soundPicked = 0;

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
DropdownList vidList;
ListBox audList, vidEffectList, audClipList;

//Everything else
PFont font; 
PImage empty;
void setup() {
  frame.setResizable(true);
  size(fullWidth, fullHeight);
  background(0);
  font = createFont("Arial", 16, true); 
  empty=loadImage("empty-project.png");
  //Load buttons
  cp5 = new ControlP5(this);
  //Button to choose files
  chooseFileButton = cp5.addButton("chooseFile")
    .setPosition(width-130, 10)
      .setSize(70, 20)
        .setCaptionLabel("Load File")
          .setVisible(true);
  cp5.getTooltip().register("chooseFile","Load Video or Audio clips, SRT, or PVE files");
  
  //Dropdown Lists
  vidList = cp5.addDropdownList("vidList")
          .setPosition(width-190, 70)
          .setColorActive(255)
          .setBarHeight(15)
          .setCaptionLabel("Video List")
          ;
  vidList.captionLabel().style().marginTop = 3;
  vidList.captionLabel().style().marginLeft = 3;        
  
  audList = cp5.addListBox("audList")
          .setPosition(width-190, 220)
          .setColorActive(255)
          .setBarHeight(15)
          .setCaptionLabel("Audio List")
          ;
  audList.captionLabel().style().marginTop = 3;
  audList.captionLabel().style().marginLeft = 3; 
  
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
      .setImages(loadImage(sketchPath +"/data/playback/PlayNormal.png"), loadImage(sketchPath +"/data/playback/PlayHot.png"), loadImage(sketchPath +"/data/playback/PlayPressed.png"))
        .updateSize();
  cp5.getTooltip().register("playButton","Play Video or Audio file").setPositionOffset(7,0);

  pauseButton = cp5.addButton("pauseButton")
    .setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/PauseNormal.png"), loadImage(sketchPath +"/data/playback/PauseHot.png"), loadImage(sketchPath +"/data/playback/PausePressed.png"))
        .updateSize()
          .setVisible(false);
  cp5.getTooltip().register("pauseButton","Pause Video or Audio file");

  stopButton = cp5.addButton("stopButton")
    .setPosition(playbackWidth/2+(iconWidth*3)/4, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/StopNormal.png"), loadImage(sketchPath +"/data/playback/StopHot.png"), loadImage(sketchPath +"/data/playback/StopPressed.png"))
        .updateSize(); 
  cp5.getTooltip().register("stopButton","Stops and resets Video or Audio file");

  prevButton = cp5.addButton("prevButton")
    .setPosition(playbackWidth/2-iconWidth*2, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/BackwardNormal.png"), loadImage(sketchPath +"/data/playback/BackwardHot.png"), loadImage(sketchPath +"/data/playback/BackwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("prevButton","Go to previous Video or Audio file");

  nextButton = cp5.addButton("nextButton")
    .setPosition(playbackWidth/2+iconWidth*2, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/ForwardNormal.png"), loadImage(sketchPath +"/data/playback/ForwardHot.png"), loadImage(sketchPath +"/data/playback/ForwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("nextButton","Go to next Video or Audio file");
  
  timeline = new Timeline();
  subs = new TimedTextObject();
  subCfg= new SubtitleConfig();
  movies = new Vector<Movie>(0, 1);
  currentFrame=0.0;
  movieNames = new Vector<String>(0, 1);
  sounds = new Vector<AudioPlayer>(0, 1);
  soundNames = new Vector<String>(0, 1);
  addMouseWheelListener();
}

void movieEvent(Movie movie) {
  mov.read();
//  println(mov.time());
//  println(timeline.time);
}
