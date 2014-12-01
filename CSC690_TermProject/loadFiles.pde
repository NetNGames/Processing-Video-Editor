//----------File Loading----------\\
//From https://processing.org/discourse/beta/num_1140107049.html
void loadFile() {
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


    if (file.getName().endsWith("mp4") ||
      file.getName().endsWith("mov") ||
      file.getName().endsWith("avi") ||
      file.getName().endsWith("ogg") ) {
      //Load video
      vidLoaded=true;
      mov = new Movie(this, file.getPath());
      movieNames.addElement(file.getName());
      movies.addElement(mov);
      //mov.loop();
      mov.pause();
      movFrameRate=(int)mov.frameRate;
      maxFrames = getLength() - 1;
      movColors = new color[width/blockSize][height/blockSize];
    } else if (file.getName().endsWith("mp3") ||
      file.getName().endsWith("wav") ||
      file.getName().endsWith("flac") ||
      file.getName().endsWith("wma") ) {
      //Load audio
      audLoaded=true;
      minim = new Minim(this);
      sound = minim.loadFile(file.getPath());
      sounds.addElement(sound);
      soundNames.addElement(file.getName());
    } else if (file.getName().endsWith("srt")) {
      //Load subtitles
      srtLoaded=true;
      loadSubs(file);
    }
  }
}

void drawFileList() {
  //Movie clip names:
  fill(255);
  text("Video Clips: ", width-190, 50);
  if (vidLoaded) {
    fill(0, 102, 153, 204);
    for (int i = 0; i < movieNames.size(); i++) {
      String name = movieNames.get(i);
      text(name, width-190, (66+(16*i)));
    }
  }

  fill(255);
  text("Audio Clips: ", width-190, 200);
  if(audLoaded){
    fill(0, 102, 153, 204);
    for (int i = 0; i <soundNames.size(); i++) {
      String name = soundNames.get(i);
      text(name, width-190, (216+(16*i)));
    }
  }
}















