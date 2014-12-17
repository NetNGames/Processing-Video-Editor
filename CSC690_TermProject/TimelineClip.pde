//Handles clips on various timelines
class TimelineClip {
  String fileName;
  String filePath;
  float start;
  color c;
  int index;
  
  TimelineClip(float s, int ind, color col) {
    start = floor(s);
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
