//----------File Loading----------\\
//From https://processing.org/discourse/beta/num_1140107049.html
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
      vidLoaded=true;
      mov = new Movie(this, file.getPath());
      movieNames.addElement(file.getName());
      movies.addElement(mov);
      //mov.loop();
      mov=movies.get(0);//Resets to 1st video loaded
      mov.pause();
      movFrameRate=(int)mov.frameRate;
      maxFrames = getLength() - 1;
      movColors = new color[width/blockSize][height/blockSize];
      
      //Loading Audio
    } else if (file.getName().endsWith("mp3") ||
               file.getName().endsWith("wav") ||
               file.getName().endsWith("wma") ||
               file.getName().endsWith("flac")) {
      audLoaded=true;
      minim = new Minim(this);
      sound = minim.loadFile(file.getPath());
      sounds.addElement(sound);
      sound=sounds.get(0); //Resets to 1st sound loaded
      soundNames.addElement(file.getName());
      
      //Loading SubRip text
    } else if (file.getName().endsWith("srt")) {
//      if(srtLoaded){ //Only loaded 1 srt at a time
                       //If one is already loaded, ask to  overwrite
      srtLoaded=true;
//      loadSubs(file);
      parseSubFile(file);
      
      //Loading Project file
    }else if (file.getName().endsWith("pve")) {
      //loadProj(file);
    }
  }
}

void drawFileList() {
  //Movie clip names:
  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("Video Clips: ", width-190, 50);
  if (vidLoaded) {
    fill(0, 102, 153);
    for (int i = 0; i < movieNames.size (); i++) {
      String name = movieNames.get(i);
      text(name, width-190, (66+(16*i)));
    }
  }

  fill(255);
  text("Audio Clips: ", width-190, 200);
  if (audLoaded) {
    fill(0, 102, 153, 204);
    for (int i = 0; i <soundNames.size (); i++) {
      String name = soundNames.get(i);
      text(name, width-190, (216+(16*i)));
    }
  }
}


