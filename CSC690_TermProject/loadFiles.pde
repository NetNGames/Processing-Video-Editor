//----------File Loading----------\\
//From https://processing.org/discourse/beta/num_1140107049.html
import javax.swing.*;
Button chooseFileButton;
boolean vidLoaded=false;
boolean audLoaded=false;
boolean srtLoaded=false;
void loadFile() {
  //Makes folder explorer mimic OS
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  final JFileChooser fc = new JFileChooser();
  int returnVal = fc.showOpenDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();

    //Loading video
    if (file.getName().endsWith("mp4") || //Can play audio from mp4
    file.getName().endsWith("mov") ||
      file.getName().endsWith("avi") || //Unable to play audio from avi
    file.getName().endsWith("ogg")) {
      loadVid(file);

      //Loading Audio
    } else if (file.getName().endsWith("mp3") ||
      file.getName().endsWith("wav") ||
      file.getName().endsWith("wma") ||
      file.getName().endsWith("flac")) {
      loadAud(file);

      //Loading SubRip text
    } else if (file.getName().endsWith("srt")) {
      //      if(srtLoaded){ //Only loaded 1 srt at a time
      //If one is already loaded, ask to  overwrite
      srtLoaded=true;
      //      loadSubs(file);
      parseSubFile(file);

      //Loading Project file
    } else if (file.getName().endsWith("pve")) {
      loadProj(file);
    }
  }
}
void loadVid(File file) {
  vidLoaded=true;
  mov = new Movie(this, file.getPath());
  vidList.addItem(file.getName(), movies.size());
  vidList.setIndex(movies.size());
  movieNames.addElement(file.getName());
  movies.addElement(mov);
  mov.play();
  maxDuration+=mov.duration();
  mov.jump(0);
  mov.pause();
  //mov.loop();
  mov=movies.get(0);//Resets to 1st video loaded
  mov.jump(0);
  mov.pause();
  movFrameRate=(int)mov.frameRate;
  //      maxFrames = getLength() - 1;
}
void loadAud(File file) {
  audLoaded=true;
  minim = new Minim(this);
  sound = minim.loadFile(file.getPath());
  audList.addItem(file.getName(), sounds.size());
  audList.setValue(sounds.size());
  sounds.addElement(sound);
  //sound=sounds.get(0); //Resets to 1st sound loaded
  soundNames.addElement(file.getName());
}

void drawFileList() {
  //Movie clip names:
  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("Video Clips: ", width-190, 50);
  //  if (vidLoaded) {
  //      vidList.setIndex(currentSelected);
  //    fill(0, 102, 153);
  //    for (int i = 0; i < movieNames.size (); i++) {
  //      String name = movieNames.get(i);
  //      text(name, width-190, (66+(16*i)));
  //    }
  //  }

  fill(255);
  text("Audio Clips: ", width-190, 200);
  for(int i = 0; i < sounds.size(); i++){
    fill((50*soundPicked+100)%250, (10*soundPicked)%250, (200*soundPicked)%250);
    rect(width-70, 204, 50, 14);
  }
  //  if (audLoaded) {
  //    for (int i = 0; i <soundNames.size (); i++) {
  //      String name = soundNames.get(i);
  //      if(i == soundPicked){ 
  //        fill(255);
  //      } else {
  //        fill(0, 102, 153, 204);
  //      }
  //      text(name, width-190, (216+(16*i)));
  //      stroke(255);
  //      fill(((50*i)+100)%250, (10*i)%250, (200*i)%250);
  //      rect(width-100, (204+(16*i)), 95, 14);
  //    }
  //  }
}

