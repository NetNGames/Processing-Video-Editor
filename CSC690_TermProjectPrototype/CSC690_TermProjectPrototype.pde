/************************************************* 
 
 File: CSC690_TermProjectPrototype
 By: Elbert Dang and Jacob Gronert
 Date: 10/25/2014
 
 Usage: Run using Processing 2.x with Minim, and ControlP5 libraries
 
 System: JVM 
 
 Description: Processing Video Editor Prototype
 -Includes some video effects
 -Embedded subtitles
 -Video file is hard-coded
 -Able to jump to frame with mouse click
 
 *************************************************/

//For Video
import processing.video.*;
Movie mov;
int movFrameRate = 25;
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
int blockSize = 10;
color movColors[];

void setup() {
  size(640, 360);
  background(0);

  //Load video
  mov = new Movie(this, "AmericaNoAud.mp4");
  mov.loop();
  maxFrames = getLength() - 1;

  //Load audio
  minim = new Minim(this);
  sound = minim.loadFile("aud.mp3");

  cp5 = new ControlP5(this);
  //Button to pixelate video
  pixelateButton = cp5.addButton("pixelateButton")
    .setPosition(10, 10)
      .setSize(70, 20)
        .setCaptionLabel("Pixelate");
}

void movieEvent(Movie movie) {
  mov.read();
}

void draw() {    
  image(mov, 0, 0);

  // Variable speed based on mouse cursor - from Speed example
  //  float newSpeed = map(mouseX, 0, width, 0.1, 2);
  //  mov.speed(newSpeed);
  //
  //  fill(255);
  //  text(nfc(newSpeed, 2) + "X", 10, 30); 
  currentFrame = getFrame();

  sound.play();

  //Bottom progress bar
  stroke(#FF0000);
  strokeWeight(10);

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
    //println(whereToJump);
    setFrame(ceil(whereToJump));
    mov.play();
  }
}

void mouseDragged() {
  if(isJump){
    float whereToJump = ((float)mouseX/(float)width)*maxFrames;
    setFrame(ceil(whereToJump));
    mov.play();
  }
}
void mouseReleased() {
  isJump=false;
  mov.play();
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller().name()=="pixelateButton") {
    if (isPixelate) {
      isPixelate=false;
    } else {
      isPixelate=true;
    }
  }
}

