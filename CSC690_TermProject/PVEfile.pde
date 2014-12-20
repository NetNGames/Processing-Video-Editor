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
        loadAud(new File(line));
        
        //Loading SubRip text
      } else if (line.endsWith("srt")) {
        loadSub(new File(line));
      } else if (line.endsWith(")-a")) {
        parseAudClip(line);
      }else if (line.endsWith(")-v")) {
        parseVidClip(line);
      }
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}
void savePVEFile() {
  //Using http://docs.oracle.com/javase/tutorial/uiswing/components/filechooser.html
  JFileChooser fc = new JFileChooser();
  PrintWriter output;

  int returnVal = fc.showSaveDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    String outputName=file.getAbsolutePath();
    if (!file.getName().endsWith(".pve")) {//So there are no double ".pve" at end of file
      outputName+=".pve";
    }
    output = createWriter(outputName);
    println("Saving project to "+outputName);
    String out="";
    movNamesItr=movieNames.listIterator();
    while (movNamesItr.hasNext ()) {      
      out += movNamesItr.next () + "\r\n";
    }
    soundNamesItr=soundNames.listIterator();
    while (soundNamesItr.hasNext ()) {
      out += soundNamesItr.next() + "\r\n";
    }
    subNamesItr=subNames.listIterator();
    while (subNamesItr.hasNext ()) {
      out += subNamesItr.next() + "\r\n";
    }
    
    audClipItr=timeline.audioClips.listIterator();
//    if(audClipItr.hasNext ()){ //Checks to see if any audio placed
//      out +="[Audio]\r\n";
//    }
    while (audClipItr.hasNext ()) {
      TimelineClip temp= audClipItr.next();
      out += "("+temp.getStart()+","+temp.getEnd()+"," + temp.getIndex()+","+temp.getColor()+")-a\r\n";
//            println(subNamesItr.previousIndex()+" "+output);
    }
    //    println();
    output.print(out);

    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println("Save Complete!");
  } else {
    println("Save Cancelled");
  }
}

void parseAudClip(String line){
  String[] parseLine = line.split(",|\\(|\\)");
  float x=Float.parseFloat(parseLine[1]);
  float dx=Float.parseFloat(parseLine[2]);
  int index=Integer.parseInt(parseLine[3]);
  color c=Integer.parseInt(parseLine[4]);
  timeline.audioClips.addElement(new TimelineClip(x, x+dx, index, c));
}

void parseVidClip(String line){
  String[] parseLine = line.split(",|\\(|\\)");
  float x=Float.parseFloat(parseLine[1]);
  float dx=Float.parseFloat(parseLine[2]);
  int index=Integer.parseInt(parseLine[3]);
  color c=Integer.parseInt(parseLine[4]);
  timeline.videoEffectClips.addElement(new TimelineClip(x, dx, index, c));
}
