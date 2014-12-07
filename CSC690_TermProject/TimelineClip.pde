//Handles clips on various timelines
class TimelineClip {
  float start;
  color c;
  int index;
  
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

  int getIndex(){
    return index;
  }
  color getColor(){
    return c;
  }
}

color genColor(){
  return color((int) random(0, 255), (int) random(0, 255), (int) random(0, 255));
}
