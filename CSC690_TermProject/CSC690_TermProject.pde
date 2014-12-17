/************************************************* 
 
 File: CSC690_TermProject
 By: Elbert Dang and Jacob Gronert
 Last Update: 12/16/2014
 
 Usage: Run CSC690_TermProject.pde using Processing 2.x with Minim, and ControlP5 libraries
 
 System: JVM 
 
 Description: Processing Video Editor
  +Load video, audio, or srt subtitle files with Load Files button
    -For video: avi, mp4, mov, and ogg files supported
    -For audio: mp3, wav, and flac files
    -For subtitles: SubRipText (srt) files
  +Clear all loaded files and settings with Reset Project button
  +Video to play can be selected using DropdownList
  +Audio clips can be selected using ListBox
    +Clips can be placed on timeline to play when timeline is ran
    -If no video file loaded, main window will display audio metadata
  +Press play to start timeline.
    -Current time will be displayed on right of timeline and by red bar.
    -If video loaded, selected video will play in main window
    -If audio placed on timeline, it will start playing once timeline reaches it.
    -Multiple audio tracks can play simultaneously
  +Video effects can be triggered using ListBox or keyboard commands
    -'I' for Inverted colors
    -'G' for Greyscale
    -'O' for Posterize
    -'P' Pixelate
      --Note that Pixelate will do so based on video's original width/height
        and may display incorrectly on scaled/stretched playback windows.
  +Once video and/or audio files are loaded, you may start adding subtitles
    -Add to current timeline time by pressing the Add Subtitle button
    -Add to custom time by typing into start/end time text fields or by clicked subtitle timeline
    -Currently loaded subtitles will display on timeline.
 
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
ListIterator<String> movNamesItr;
int videoPicked = 0;
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
AudioMetaData meta;
Vector<AudioPlayer> sounds;
Vector<String> soundNames;
ListIterator<AudioPlayer> soundItr;
ListIterator<String> soundNamesItr;
int soundPicked = 0;

//For Buttons
import controlP5.*;
ControlP5 cp5;
//Playback
Button playButton, pauseButton, stopButton, nextButton, prevButton;
Button saveButton, saveSRTButton;

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
    .setPosition(width-180, 10)
      .setSize(70, 20)
        .setCaptionLabel("Load File")
          .setVisible(true);
  cp5.getTooltip().register("chooseFile", "Load Video/Audio clips, SRT, or PVE files.");

  resetButton= cp5.addButton("resetButton")
    .setPosition(width-90, 10)
      .setSize(70, 20)
        .setCaptionLabel("Reset Project")
          .setVisible(true);
  cp5.getTooltip().register("resetButton", "Clear and resets project.");

  saveButton= cp5.addButton("saveButton")
    .setPosition(width-180, playbackHeight-30)
      .setSize(70, 20)
        .setCaptionLabel("Save Project")
          .setVisible(true);
  cp5.getTooltip().register("saveButton", "Save Current Project");

  saveSRTButton= cp5.addButton("saveSRTButton")
    .setPosition(width-90, playbackHeight-30)
      .setSize(70, 20)
        .setCaptionLabel("Save Subtitles")
          .setVisible(true);
  cp5.getTooltip().register("saveSRTButton", "Save Current Subtitles");

  //Dropdown Lists
  vidList = cp5.addDropdownList("vidList")
    .setPosition(width-190, 70)
      .setColorActive(255)
        .setBarHeight(15)
          .setCaptionLabel("No video files loaded")
            ;
  vidList.captionLabel().style().marginTop = 3;
  vidList.captionLabel().style().marginLeft = 3;        

  vidEffectList = cp5.addListBox("vidEffectList")
    .setPosition(width-190, 140)
      .setColorActive(255)
        .setBarHeight(15)
          .setCaptionLabel("Video Effects")
//         .setColorActive(color(0))
            ;
            
  ListBoxItem lbi0 = vidEffectList .addItem("Invert", 0);
  ListBoxItem lbi1 = vidEffectList.addItem("Greyscale",1);
  ListBoxItem lbi2 = vidEffectList.addItem("Posterize", 2);
  ListBoxItem lbi3 = vidEffectList.addItem("Pixelate", 3);
  vidEffectList.captionLabel().style().marginTop = 3;
  vidEffectList.captionLabel().style().marginLeft = 3;   
  vidEffectList.setHeight(45).close() ;
  audList = cp5.addListBox("audList")
    .setPosition(width-190, 220)
      .setColorActive(255)
        .setBarHeight(15)
          .setCaptionLabel("Audio List")
            ;
  audList.captionLabel().style().marginTop = 3;
  audList.captionLabel().style().marginLeft = 3; 

  //Button to pixelate video
  fullscreenButton = cp5.addButton("fullscreenButton")
    .setPosition(10, 10)
      .setSize(70, 20)
        .setCaptionLabel("Fullscreen")
          .setVisible(false);
  cp5.getTooltip().register("fullscreenButton", "Toggle Fullscreen");

  //Playback
  playButton = cp5.addButton("playButton")
    .setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/PlayNormal.png"), loadImage(sketchPath +"/data/playback/PlayHot.png"), loadImage(sketchPath +"/data/playback/PlayPressed.png"))
        .updateSize();
  cp5.getTooltip().register("playButton", "Play Video or Audio file").setPositionOffset(7, 0);

  pauseButton = cp5.addButton("pauseButton")
    .setPosition(playbackWidth/2-(iconWidth*3)/4+4, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/PauseNormal.png"), loadImage(sketchPath +"/data/playback/PauseHot.png"), loadImage(sketchPath +"/data/playback/PausePressed.png"))
        .updateSize()
          .setVisible(false);
  cp5.getTooltip().register("pauseButton", "Pause Video or Audio file");

  stopButton = cp5.addButton("stopButton")
    .setPosition(playbackWidth/2+(iconWidth*3)/4, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/StopNormal.png"), loadImage(sketchPath +"/data/playback/StopHot.png"), loadImage(sketchPath +"/data/playback/StopPressed.png"))
        .updateSize(); 
  cp5.getTooltip().register("stopButton", "Stops and resets Video or Audio file");

  prevButton = cp5.addButton("prevButton")
    .setPosition(playbackWidth/2-iconWidth*2, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/BackwardNormal.png"), loadImage(sketchPath +"/data/playback/BackwardHot.png"), loadImage(sketchPath +"/data/playback/BackwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("prevButton", "Go to previous Video or Audio file");

  nextButton = cp5.addButton("nextButton")
    .setPosition(playbackWidth/2+iconWidth*2, height-40)
      .setImages(loadImage(sketchPath +"/data/playback/ForwardNormal.png"), loadImage(sketchPath +"/data/playback/ForwardHot.png"), loadImage(sketchPath +"/data/playback/ForwardPressed.png"))
        .updateSize();
  cp5.getTooltip().register("nextButton", "Go to next Video or Audio file");

  timeline = new Timeline();
  subs = new TimedTextObject();
  subCfg= new SubtitleConfig();
  movies = new Vector<Movie>(0, 1);
  movItr=movies.listIterator();
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

