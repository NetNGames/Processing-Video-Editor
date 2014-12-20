//Handles clips on various timelines
class TimelineClip {
  float start;
  float end;
  color c;
  int index;
  
  TimelineClip(float s, float e, int ind, color col) {
    start = s;
    end = e;
    index = ind;
    c = col;
  }
  
  void update(){
  
  }
  
  void draw(){
  
  }
  
  float getStart() {
    return start;
  }
  
  float getEnd() {
    return end;
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
color genDarkColor(){
  return color((int) random(0, 127), (int) random(0, 127), (int) random(0, 127));
}
color genLightColor(){
  return color((int) random(128, 255), (int) random(128, 255), (int) random(128, 255));
}
