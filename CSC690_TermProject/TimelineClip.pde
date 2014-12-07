class TimelineClip {
  float start;
  color c;
  
  TimelineClip(float s) {
    start = floor(s);
  }
  
  void update(){
  
  }
  
  void draw(){
  
  }
  
  float getStart() {
    return start;
  }

}

color genRandomColor(){
  return color((int) random(0, 255), (int) random(0, 255), (int) random(0, 255));
}
