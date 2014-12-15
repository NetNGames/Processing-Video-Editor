//----------Subtitles----------\\
//From https://github.com/JDaren/subtitleConverter/
import java.util.ListIterator;
import java.io.InputStreamReader;
import java.io.FileInputStream;
import java.util.Comparator;
import java.util.Collections;

//For subtitles
TimedTextObject subs;
SubtitleConfig subCfg;
ListIterator<Caption> itr;
Caption current;

static class Caption {
  public SubTime start;
  public SubTime end;
  public String content="";

  //To sort by start time
  //From http://stackoverflow.com/a/1814112
  static Comparator<Caption> COMPARE_BY_START = new Comparator<Caption>() {
    public int compare(Caption one, Caption other) {
      return one.start.mseconds.compareTo(other.start.mseconds);
    }
  };
}

class SubTime {
  SubTime(String value) {
    int h, m, s, ms;
    h = Integer.parseInt(value.substring(0, 2));
    m = Integer.parseInt(value.substring(3, 5));
    s = Integer.parseInt(value.substring(6, 8));
    ms = Integer.parseInt(value.substring(9, 12));

    mseconds = ms + s*1000 + m*60000 + h*3600000;
  }
  //  SubTime(int value) {
  //    mseconds = value;
  //  }
  protected Integer mseconds;

  String getTime() {
    //we use string builder for efficiency
    StringBuilder time = new StringBuilder();
    String aux;

    // this type of format:  01:02:22,501 (used in .SRT)
    int h, m, s, ms;
    h =  mseconds/3600000;
    aux = String.valueOf(h);
    if (aux.length()==1) time.append('0');
    time.append(aux);
    time.append(':');
    m = (mseconds/60000)%60;
    aux = String.valueOf(m);
    if (aux.length()==1) time.append('0');
    time.append(aux);
    time.append(':');
    s = (mseconds/1000)%60;
    aux = String.valueOf(s);
    if (aux.length()==1) time.append('0');
    time.append(aux);
    time.append(',');
    ms = mseconds%1000;
    aux = String.valueOf(ms);
    if (aux.length()==1) time.append("00");
    else if (aux.length()==2) time.append('0');
    time.append(aux);

    return time.toString();
  }
}

class TimedTextObject {
  public String fileName = "";
  public Vector<Caption> captions;
  public String warnings;
  public int offset = 0;
  public boolean built = false;
  protected TimedTextObject() {
    captions = new Vector<Caption>(); 
    warnings = "List of non fatal errors produced during parsing:\n\n";
  }
}

void parseSubFile(File file) {
  try {
    InputStream is = new FileInputStream(file);
    //    subs = new TimedTextObject();
    Caption caption = new Caption();
    int captionNumber = 1;
    boolean allGood;

    //first lets load the file
    InputStreamReader in= new InputStreamReader(is);
    BufferedReader br = new BufferedReader(in);

    //the file name is saved
    subs.fileName = file.getName();

    String line = br.readLine();
    int lineCounter = 0;
    try {
      while (line!=null) {
        line = line.trim();
        lineCounter++;
        //if its a blank line, ignore it, otherwise...
        if (!line.isEmpty()) {
          allGood = false;
          //the first thing should be an increasing number
          try {
            int num = Integer.parseInt(line);
            if (num != captionNumber)
              throw new Exception();
            else {
              captionNumber++;
              allGood = true;
            }
          } 
          catch (Exception e) {
            subs.warnings+= captionNumber + " expected at line " + lineCounter;
            subs.warnings+= "\n instead, line= " +line;
            subs.warnings+= "\n skipping to next line\n\n";
          }
          if (allGood) {
            //we go to next line, here the begin and end time should be found
            try {
              lineCounter++;
              line = br.readLine().trim();
              String start = line.substring(0, 12);
              String end = line.substring(line.length()-12, line.length());
              SubTime time = new SubTime(start);
              caption.start = time;
              time = new SubTime(end);
              caption.end = time;
            } 
            catch (Exception e) {
              subs.warnings += "incorrect time format at line "+lineCounter;
              allGood = false;
            }
          }
          if (allGood) {
            //we go to next line where the caption text starts
            lineCounter++;
            line = br.readLine().trim();
            String text = "";
            while (!line.isEmpty ()) {
              text+=line+"\n";
              line = br.readLine().trim();
              lineCounter++;
            }
            caption.content = text;
            //            int key = caption.start.mseconds;
            //            //in case the key is already there, we increase it by a millisecond, since no duplicates are allowed
            //            while (subs.captions.containsKey(key)) key++;
            //            if (key != caption.start.mseconds)
            //              subs.warnings+= "caption with same start time found...\n\n";
            //we add the caption.
            //            subs.captions.put(key, caption);
            subs.captions.add(caption);
          }
          //we go to next blank
          while (!line.isEmpty ()) {
            line = br.readLine().trim();
            lineCounter++;
          }
          caption = new Caption();
        }
        line = br.readLine();
      }
    }  
    catch (NullPointerException e) {
      subs.warnings+= "unexpected end of file, maybe last caption is not complete.\n\n";
    } 
    finally {
      //we close the reader
      is.close();
    }

    subs.built = true;


    //    return subs;
  }
  catch (Exception e) {
    println(e);
    print(subs.warnings);
  }
}

void displaySubs() {
  //Find current time by milliseconds
  float sec=0.0;
  if (currentSelected==0) {
    sec = mov.time();
  } else if (currentSelected==1) {
    sec = mov.time()+movies.get(0).duration();
  }
  int seconds = (int)sec;
  float fraction = sec-seconds;
  int mill = (int)(fraction *1000);
  int minutes = seconds/60;
  seconds = seconds%60;
  int hours = minutes/60;
  minutes = minutes%60;
  int currentMseconds = mill + seconds*1000 + minutes*60000 + hours*3600000;
  itr = subs.captions.listIterator();
  current = itr.next();
  //    println("current time: "+currentMseconds);
  //
  //      println("sub start: "+current.start.mseconds);
  //      println("sub end: "+current.end.mseconds);
  while (currentMseconds>=current.end.mseconds && itr.hasNext ()) {
    current = itr.next(); //If skipping forwards
  }
  if (currentMseconds>=current.start.mseconds && !(currentMseconds>=current.end.mseconds)) {
    //    println("start");
    textSize(15);
    textAlign(CENTER);
    if (!fullscreenMode) {
      //Black Outline
      fill(#000000);
      text(current.content, playbackWidth/2+1, playbackHeight - 31);
      text(current.content, playbackWidth/2-1, playbackHeight - 29);

      //White text
      fill(#FFFFFF);
      text(current.content, playbackWidth/2, playbackHeight - 30);
    } else {
      //Black Outline
      fill(#000000);
      text(current.content, playbackWidth/2+1, playbackHeight - 51);
      text(current.content, playbackWidth/2-1, playbackHeight - 49);

      //White text
      fill(#FFFFFF);
      text(current.content, playbackWidth/2, playbackHeight - 50);
    }
  }
  if ((currentMseconds>=current.end.mseconds) && //If time period is reached
  (itr.hasNext())) {            //And not at end of subtitles
    //    println("end");
    current = itr.next();
  }
  while (currentMseconds<=current.start.mseconds && itr.hasPrevious ()) {
    current = itr.previous(); //If skipping backwards
  }
}

String formatTime(float sec) {
  int seconds = (int)sec;
  float fraction = sec-seconds;
  int mill = (int)(fraction *1000);
  int minutes = seconds/60;
  seconds = seconds%60;
  int hours = minutes/60;
  minutes = minutes%60;

  String time = "";
  if (hours<10) {
    time = time+"0";
  }
  time = time+hours+":";
  if (minutes<10) {
    time = time+"0";
  }
  time = time+minutes+":";
  if (seconds<10) {
    time = time+"0";
  }
  time = time+seconds+",";
  if (mill<100) {
    time = time+"0";
    if (mill<10) {
      time = time+"0";
    }
  }
  time = time+mill;
  return time;
}

void drawSubTimeline() {
  fill(255);
  textSize(12);
  text("Subtitles:", 5, height-50);
  rect(60, height-60, timelineWidth, 10);
}
void drawSubsOnTimeline() {
  for (int i = 0; i < subs.captions.size (); i++) {
    Caption sub = subs.captions.get(i);
    fill(0, 102, 153);
    //Draw spots where subtitles were placed
    int location=(int)(sub.start.mseconds/1000.0);
    noStroke();
    rect(60+(location/(timeline.getMax()-1))*timelineWidth, height-60, 1, 10);
  }
}

