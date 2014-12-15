//Handles PVE Project files
import java.io.FileReader;
void loadProj(File file) {
  String line="";
  try {
    BufferedReader br = new BufferedReader(new FileReader(file));

    while ( (line = br.readLine ()) != null) {
      if (line.endsWith("mp4") || //Can play audio from mp4
      line.endsWith("mov") ||
        line.endsWith("avi") || //Unable to play audio from avi
      line.endsWith("ogg")) {
        loadVid(new File(line));

        //Loading Audio
      } else if (line.endsWith("mp3") ||
        line.endsWith("wav") ||
        line.endsWith("wma") ||
        line.endsWith("flac")) {
        //          String temp= line.substring(0, line.length()-1);
        loadAud(new File(line));

        //Loading SubRip text
      } else if (line.endsWith("srt")) {
        srtLoaded=true;
        parseSubFile(new File(line));
      }
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}
void saveProj(String outputName) {
  /*  PrintWriter output;  
   for (int i = 0; i<imageList.length; i++) {
   String writeTag="";
   if (!tagList[i].equals("No tags") || tagBoxList[i]!=null) { //Don't create tag file if no new tags
   output = createWriter(sketchPath + "/data/tag/" + list[i]+"_tag.txt");//create tag file with originalName_tag.txt extension 
   if (!tagList[i].equals("No tags")){
   writeTag+=tagList[i]+"\n";
   //println("standard tags: " + writeTag);
   }
   if (tagBoxList[i]!=null){
   writeTag+=tagBoxList[i];
   //println("box tags: " + writeTag);
   }
   //println("all tags: " + writeTag);
   output.print(writeTag); //Overwrites tag file if it existed
   tagSaveButton.setCaptionLabel("Tags saved OK!");
   output.flush(); // Writes the remaining data to the file
   output.close(); // Finishes the file
   }
   }*/
}
void displayLists() {
  //  movItr=movies.listIterator();
  //  while (movItr.hasNext()) {
  //                mov = movItr.next();
  //            }
  JFileChooser fc = new JFileChooser();
  fc.setDialogType(javax.swing.JFileChooser.SAVE_DIALOG);

  fc.setFileSelectionMode(javax.swing.JFileChooser.DIRECTORIES_ONLY);

  final int fd = fc.showDialog(null, "Select folder to save.");
  if (fd == JFileChooser.APPROVE_OPTION) {
    println("Saving subs:");
    String temp;
    movNamesItr=movieNames.listIterator();
    while (movNamesItr.hasNext ()) {
      temp = movNamesItr.next();
      println(movNamesItr.previousIndex()+" "+temp);
    }
    soundNamesItr=soundNames.listIterator();
    while (soundNamesItr.hasNext ()) {
      temp = soundNamesItr.next();
      println(soundNamesItr.previousIndex()+" "+temp);
    }
    println();
  } else {
    this.dispose();
  }
}

