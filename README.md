Processing-Video-Editor
=======================

# SFSU CSC690 Term Project for Fall 2014

## By: Elbert Dang and Jacob Gronert

### Last Update: 12/20/2014
 
### Usage: Run CSC690_TermProject.pde using Processing 2.x with Minim, and ControlP5 libraries
 
### System: Java Virtual Machine
 
#### Using Processing Video Editor:
* Load video, audio, or srt subtitle files with Load Files button.
 * For video: avi, mp4, mov, and ogg files are supported.
   * mp4 file can have embedded audio, but audio stream cannot be edited.
 * For audio: mp3, wav, and flac files are supported.
 * For subtitles: SubRipText (srt) files are supported.
* Clear all loaded files with Clear Project button.
* Video to play can be selected using DropdownList.
* Audio clips can be selected using ListBox.
 * If video file loaded, click to place Active audio clip on timeline to play when timeline is ran.
 * If no video file loaded, main window will display audio metadata.
* Press play to start timeline.
 * Current time will be displayed on right of timeline and by red bar.
 * If video loaded, selected video will play in main window].
 * If audio placed on timeline, it will start playing once timeline reaches it.
 * Multiple audio tracks can play simultaneously.
* Video effects can be triggered using ListBox, timeline, or keyboard commands.
 * To activate using Listbox, simply select video effect when video is played.
 * To activate by timeline, click to choose duration and video effect to display when timeline is ran.
 * To activate by Keyboard:
    * 'I' for Inverted colors
    * 'G' for Greyscale
    * 'O' for Posterize
    * 'P' Pixelate
      * Note that Pixelate will do so based on video's original width/height and may display incorrectly on scaled/stretched playback windows.
* Once video and/or audio files are loaded, you may start adding subtitles.
 * Add to current timeline time by pressing the Add Subtitle button.
 * Add to custom time by typing into start/end time text fields or by clicked subtitle timeline.
   * Currently loaded subtitles will display on timeline.
 * Save subtitles by pressing Save Subtitles button.
* Press Save Project to save all loaded files and timeline settings.
 * If subtitles were loaded or saved, they will be included in the output PVE file.
   * Make sure you save any edited subtitles before you save your project or subtitle changes will not be saved.
 
### Website: http://mirix5.github.io/processingvideoeditor/
