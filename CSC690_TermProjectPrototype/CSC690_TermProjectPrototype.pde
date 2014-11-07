/************************************************* 
 
 File: CSC690_TermProjectPrototype
 By: Elbert Dang and Jacob Gronert
 Date: 10/25/2014
 
 Usage: Run using Processing 2.x with Minim, and ControlP5 libraries
 
 System: JVM 
 
 Description: Processing Video Editor Prototype
 
 *************************************************/
import processing.video.*;

Movie mov;

int movFrameRate = 25;
float currentFrame;
float maxFrames;

void setup() {
  size(640, 360);
  background(0);
  mov = new Movie(this, "Team America.mp4");
  mov.loop();
  maxFrames = getLength() - 1;
}

void movieEvent(Movie movie) {
  mov.read();
}

void draw() {    
  image(mov, 0, 0);

  float newSpeed = map(mouseX, 0, width, 0.1, 2);
  mov.speed(newSpeed);

  fill(255);
  text(nfc(newSpeed, 2) + "X", 10, 30); 
  currentFrame = getFrame();
  stroke(#FF0000);
  strokeWeight(10);
  
  rect(0, height-9 //Located on bottom of screen
      ,(currentFrame/ maxFrames)*width //Scaled to window width
      , 1);
}  
int getFrame() {    
  return ceil(mov.time() * movFrameRate) - 1;
}
int getLength() {
  return int(mov.duration() * movFrameRate);
}  

