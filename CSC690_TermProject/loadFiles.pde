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
    } else if (file.getName().endsWith("srt")) {
      //Load subtitles
      srtLoaded=true;
      loadSubs(file);
    }
  }
}
